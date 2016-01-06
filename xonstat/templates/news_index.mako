<%inherit file="base.mako"/>
<%namespace name="nav" file="nav.mako" />
<%namespace file="navlinks.mako" import="navlinks" />

<%block name="navigation">
${nav.nav('news')}
</%block>

<%block name="title">
News
</%block>

<%block name="js">
${parent.js()}
</%block>


<div class="row newsitem">
  <div class="col-sm-2">
    2016-01-06 04:50 CET
  </div>
  <div class="col-sm-10">
    <b>"B-Rating", Recalculated FFA, CTF, FT and TDM ratings</b>
    <br />Matches with custom game settings and factories were removed from the standard rating.
    <br />To provide balancing data for Vampiric PQL CA, instaFreeze, instaCTF and other mods there is now a separate B-rating for all custom matches.
    <br />Support for the B-ratings on the web site is currently under construction.
    <br />The B-ratings can be used by minqlx for balancing by using the /elo_b API URL instead of /elo
    <br />With that in place, FFA, CTF, FT and TDM have been recalculated to remove custom matches from the main ratings and put them in the B-ratings.
  </div>
</div>


<div class="row newsitem">
  <div class="col-sm-2">
    2016-01-05 16:20 CET
  </div>
  <div class="col-sm-10">
    <b>Recalculated CA ratings</b>
    <br />CA ratings were recalculated today. They include 3v3 matches and use a new metric to evaluate each player's performance in a match:
    <br />damage_dealt/100 + 0.25*kills is used to order all players (regardless of teams) and decide pairwise winner, loser or a draw within a 2pt margin.
    <br />Also, for any new matches, the number of rounds played per player is counted and used instead of time_played to scale up partial play time in a match.
  </div>
</div>
