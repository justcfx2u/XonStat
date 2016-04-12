<%inherit file="base.mako"/>
<%namespace name="nav" file="nav.mako" />
<%namespace file="navlinks.mako" import="navlinks" />

<%block name="navigation">
${nav.nav('players')}
</%block>

<%block name="title">
Player Index
</%block>

% if not players:
<h2>Sorry, no players yet. Get playing!</h2>

% else:
<div class="row">
  <div class="col-sm-12 col-md-8 col-lg-6 col-md-offset-2 col-lg-offset-3">
    <form class="indexform" method="get" action="${request.route_path('search')}">
      <input type="hidden" name="fs" />
      <input class="indexbox" type="text" name="nick" />
      <input type="submit" value="search" />
    </form>
    <table class="table table-hover table-condensed">
      <thead>
        <tr>
          <th style="width:100px;">Player ID</th>
          <th>Nick</th>
          <th class="create-dt" style="width:180px">Joined</th>
          <th style="width:50px"></th>
        </tr>
      </thead>
      <tbody>
        % for player in players:
        <tr>
          <td>${player.player_id}</td>
          <td><a href="${request.route_path("player_info", id=player.player_id)}" title="Go to this player's info page">${player.nick_html_colors()|n}</a></td>
          <td><span class="abstime" data-epoch="${player.epoch()}" title="${player.create_dt.strftime('%a, %d %b %Y %H:%M:%S UTC')}">${player.joined_pretty_date()}</span></td>
          <td class="tdcenter">
            <a href="${request.route_path("player_game_index", player_id=player.player_id, page=1)}" title="View recent games by this player">
              <i class="glyphicon glyphicon-list"></i>
            </a>
          </td>
        </tr>
        % endfor
      </tbody>
    </table>

    ${navlinks("player_index", players.page, players.last_page)}
  </div> <!-- /span4 -->
</div> <!-- /row -->
% endif
