<%inherit file="base.mako"/>
<%namespace name="nav" file="nav.mako" />
<%namespace file="scoreboard.mako" import="scoreboard" />
<%namespace file="accuracy.mako" import="accuracy" />

<%block name="navigation">
${nav.nav('games')}
</%block>

<%block name="css">
${parent.css()}
</%block>

<%block name="js">
${parent.js()}
</%block>

<%block name="title">
Game Information
</%block>


% if game is None:
<h2>Sorry, that game wasn't found!</h2>

% else:
<div class="row">
  <div class="col-sm-12 game-detail">
    <h2>Game Detail<span class="note"> ${game.match_id}</span></h2>
    <img width="64" height="64" src="/static/images/icons/48x48/${game.game_type_cd}.png" alt="${game.game_type_cd}"/>
    <p style="display:inline-block">
    Played: <span class="abstime" data-epoch="${game.epoch()}" title="${game.start_dt.strftime('%a, %d %b %Y %H:%M:%S UTC')}">${game.fuzzy_date()}</span><br />
    Game Type: ${gametype.descr} (${game.mod})<br />
    Server: <a href="${request.route_url("server_info", id=server.server_id)}" name="Server info page for ${server.name}">${server.name}</a><br />
    Map: <a href="${request.route_url("map_info", id=map.map_id)}" name="Map info page for ${map.name}">${map.name}</a><br />
    % if game.duration is not None:
    Duration: ${"%s:%02d" % (game.duration.seconds/60, game.duration.seconds%60)}
    % endif
    <br>Glicko:
    <%
    statusMsg={0: "Not rated yet", 1: "Rated", 2: "match aborted", 3: "unsupported round/time/fraglimit", 4: "bots present", 5: "uneven playtime in teams", 6: "not enough players", 7: "missing data", 8: "unsupported game settings/factory" }
    msg= statusMsg[game.g2_status] if game.g2_status<=1 else "Not rated (" + statusMsg[game.g2_status] + ")"
    %>
    ${msg}
    </p>
    <a class="btn btn-primary btn-small" style="vertical-align:top; margin-top: 40px; margin-left: 30px" href="steam://connect/${server.ip_addr}:${server.port}" title="Connect to game server">Join Server</a>
    <span class="clear"></span>
  </div>
  <!--
  % if teamscores:
  <div class="span3 teamscores">
    <table class="table table-condensed">
      <thead>
      <th>Team</th>
      <th>Score</th>
      </thead>
      <tbody>
        % for ts in teamscores:
        <tr class="${ts.team}"><td>${ts.team.capitalize()}</td><td>${ts.score}</td></tr>
        % endfor
      </tbody>
    </table>
  </div>
  % endif
  -->
</div>

% if len(tgstats) == len(stats_by_team):
## if we have teamscores in the db
% for tgstat in tgstats:
<div class="row">
  <div class="col-sm-1 teamscore">
    <div class="teamname ${tgstat.team_html_color()}">
    ${tgstat.team_html_color().capitalize()}
    </div>
    <div class="${tgstat.team_html_color()}">
    % if game.game_type_cd == 'ctf':
    ${tgstat.caps}
    % elif game.game_type_cd == 'ca' or game.game_type_cd == 'ft':
    ${tgstat.rounds}
  ## dom -> ticks, rc -> laps, nb -> goals, as -> objectives
    % else:
    ${tgstat.score}
    % endif
    </div>
  </div>
  <div class="col-sm-11 game">
    ${scoreboard(game.game_type_cd, stats_by_team[tgstat.team], show_elo, show_latency)}
  </div>
</div>
% endfor
% else:
% for team in stats_by_team.keys():
<div class="row">
  <div class="col-sm-12 game">
    ${scoreboard(game.game_type_cd, stats_by_team[team], show_elo, show_latency)}
  </div>
</div>
% endfor
% endif

% if len(captimes) > 0:
<div class="row">
  <div class="col-sm-12 col-md-6">
    <h3>Best Flag Capture Times</h3>
    <table class="table table-hover table-condensed">
      <thead>
        <tr>
          <th>Nick</th>
          <th>Captime</th>
        </tr>
      </thead>
      <tbody>
      % for pgs in captimes:
      <tr>
        <td>
          % if pgs.player_id > 2:
          <a href="${request.route_url("player_info", id=pgs.player_id)}"
            title="Go to the info page for this player">
            <span class="nick">${pgs.nick_html_colors()|n}</span>
          </a>
          % else:
          <span class="nick">${pgs.nick_html_colors()|n}</span>
          % endif
        </td>
        <td>${round(float(pgs.fastest.seconds) + (pgs.fastest.microseconds/1000000.0), 2)}</td>
      </tr>
      % endfor
      </tbody>
    </table>
  </div>
</div>
% endif


% if len(pwstats) > 0:
<div class="row">
  <div class="col-sm-12">
    <h3>Accuracy Information</h3>
    ${accuracy(pwstats, weapons, weaponFired)}
  </div>
</div>
% endif

% endif
