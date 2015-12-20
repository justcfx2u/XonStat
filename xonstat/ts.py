import datetime
import logging
import math
import random
import sys
from xonstat.models import *
from trueskill import Rating, rate

import sqlahelper
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker

logging.basicConfig(level=logging.DEBUG)
log = logging.getLogger(__name__)

FactoriesForGameType = {
    "duel": [ "duel", "qcon_duel" ],
    "ffa": [ "ffa", "mg_ffa_classic" ],
    "tdm": [ "ctdm", "qcon_tdm" ], 
    "ctf": [ "ctf", "ctf2", "qcon_ctf" ]
    }
MinPlayersForGameType = { "duel": 2, "ffa": 4, "tdm": 8, "ctf": 8 }
MinGameLengthForGameType = { "duel": 10, "ffa": 6, "tdm": 10, "ctf": 15 }
BotPlayerId = 0

class PlayerData:
    def __init__(self):
        self.timeRed = 0
        self.timeBlue = 0
        self.score = 0
        self.dmgGiven = 0
        self.dmgTaken = 0
        self.rank = None

def process_ratings(game, session, game_type_cd=None):
    if game_type_cd is None:
        game_type_cd = game.game_type_cd

    # only accept certain factories (e.g. exclude instagib, quadhog, ....)
    if game.game_type_cd not in FactoriesForGameType:
      log.debug("Unsupported game type '" + game.game_type_cd + "' for match " + str(game.game_id))
      return;

    if game.mod not in FactoriesForGameType[game.game_type_cd]:
      log.debug("Unsupported factory '" + game.mod + "' for match " + str(game.game_id))
      return

    if game.duration.seconds <  MinGameLengthForGameType[game.game_type_cd] * 60:
      log.debug("Match duration '" + str(game.duration.seconds) + "' too short for match " + str(game.game_id))
      return;

    if BotPlayerId == 0:
      BotPlayerId = session.query(Hashkey.player_id).filter(Hashkey.hashkey=="0").one_or_none()
      if BotPlayerId is None: BotPlayerId = -1

    players = {}
    for (p,s,a,dg,dt,team) in session.query(PlayerGameStat.player_id, 
            PlayerGameStat.score, PlayerGameStat.alivetime, PlayerGameStat.pushes, PlayerGameStat.destroys, PlayerGameStat.team).\
            filter(PlayerGameStat.game_id==game.game_id).\
            all():
                if p in players:
                    player = players[p]
                else:
                    players[p] = player = PlayerData()
                
                if team == 2: 
                  player.timeBlue += a.seconds 
                else:
                  player.timeRed += a.seconds
                player.score += s;
                player.dmgGiven += dg;
                player.dmgTaken += dt;

    player_ids = players.keys()
    for pid in player_ids:
        p = players[pid]
        if p.timeRed + p.timeBlue > game.duration.seconds:
            if p.timeRed == 0:
                p.timeBlue = game.duration.seconds
            elif p.timeBlue == 0:
                p.timeRed = game.duration.seconds
            else:
                del players[pid]
        elif p.timeRed + p.timeBlue < game.duration.seconds / 2:
            del players[pid]

    player_ids = players.keys()

    # ignore matches with less than the minimum required number of players
    if game.game_type_cd in MinPlayersForGameType and len(player_ids) < MinPlayersForGameType[game.game_type_cd]:    
      log.debug("Not enough players to rate match " + str(game.game_id))
      return 

    elos = {}
    for e in session.query(PlayerElo).\
            filter(PlayerElo.player_id.in_(player_ids)).\
            filter(PlayerElo.game_type_cd==game_type_cd).all():
                elos[e.player_id] = e

    # ensure that all player_ids have an elo record
    for pid in player_ids:
        if pid not in elos.keys():
            elos[pid] = PlayerElo(pid, game_type_cd)
            elos[pid].elo = 100.0

    for pid in player_ids:
        players[pid].rank = -calculate_ranking_score(game, players[pid]);

    elos = update_ratings(game, session, elos, players)

    # add the elos to the session for committing
    for e in elos:
        session.add(elos[e])

def calculate_ranking_score(game, player):
    if game.game_type_cd == "ctf":
        playerTeam =  1 if player.timeRed >= player.timeBlue else 2
        winnerTeam = game.winner
        return (2 if player.dmgTaken == 0 else min(2, max(0.5, player.dmgGiven / player.dmgTaken))) \
          * (player.score + player.dmgGiven / 20) * game.duration.seconds / (player.timeRed + player.timeBlue) \
          + (300 if playerTeam == winnerTeam else 0)
    return player.score


def update_ratings(game, session, elos, players):
    if len(elos) < 2:
        return []

    oldRatings = []
    ranks = []
    for pid in players:
      p = elos[pid]
      #fixme 
      if len(oldRatings) < 8:
        oldRatings.append((Rating(mu=p.mu, sigma=p.sigma),))
        ranks.append(players[pid].rank)

    newRatings = rate(oldRatings, ranks);

    elo_deltas = {}   
    i=0
    for pid in players:
      if i>=8: continue
      old = oldRatings[i][0]
      new = newRatings[i][0]
      elo_deltas[pid] = (new.mu - 3*new.sigma) - (old.mu - 3*old.sigma)
      elos[pid].mu = new.mu
      elos[pid].sigma = new.sigma
      elos[pid].ts_games += 1
      i = i + 1
      log.debug(str(pid) + ": mu=" + str(new.mu) + ", sigma=" + str(new.sigma));

    save_rating_deltas(game, session, elo_deltas)

    return elos


def save_rating_deltas(game, session, elo_deltas):
    """
    Saves the amount by which each player's Elo goes up or down
    in a given game in the PlayerGameStat row, allowing for scoreboard display.

    elo_deltas is a dictionary such that elo_deltas[player_id] is the elo_delta
    for that player_id.
    """
    pgstats = {}
    for pgstat in session.query(PlayerGameStat).\
            filter(PlayerGameStat.game_id == game.game_id).\
            all():
                pgstats[pgstat.player_id] = pgstat

    for pid in elo_deltas.keys():
        try:
            pgstats[pid].ts_delta = elo_deltas[pid]
            session.add(pgstats[pid])
        except:
            log.debug("Unable to save Elo delta value for player_id {0}".format(pid))

#"""
# setup the database engine
engine = create_engine("postgresql+psycopg2://xonstat:xonstat@localhost:5432/xonstatdb")
sqlahelper.add_engine(engine)
initialize_db(engine)
DBSession = sessionmaker(bind=engine)
session = DBSession()
games = session.query(Game).filter(Game.game_type_cd == 'ctf').order_by(Game.start_dt).all()
#games = session.query(Game).filter(Game.match_id == '25c731c1-0909-41bc-aea6-ec1882b34ffc').all()
for game in games:
  log.debug("processing game " + str(game.game_id))
  process_ratings(game, session)
session.commit()
#"""