<%inherit file="base.mako"/>
<%namespace name="nav" file="nav.mako" />
<%namespace file="navlinks.mako" import="navlinks" />

<%block name="navigation">
${nav.nav('players')}
</%block>

<%block name="title">
Player captimes
</%block>

% if len(captimes) == 0:
<h2>Sorry, no caps yet. Get playing!</h2>
<p><a href="${request.route_path('player_info', id=player.player_id)}">Back to player info page</a></p>
% else:

<div class="row">
  <div class="col-md-8 col-md-offset-2">
    <h3>Fastest Flag Captures by
      <a href="${request.route_path('player_info', id=player.player_id)}">
        ${player.nick_html_colors()|n}
      </a>
    </h3>
 
    <table class="table table-hover table-condensed">
      <thead>
        <tr>
           <th>Game</th>
           <th>Captime</th>
           <th>Map</th>
           <th>Server</th>
           <th>Date</th>
        </tr>
      </thead>
      <tbody>
      % for ct in captimes.items:
        <tr>
          <td class="tdcenter"><a class="btn btn-primary btn-small" href="${request.route_path('game_info', id=ct.game_id)}" title="View detailed information about this game">view</a></td>
          <td>${ct.fastest_cap.total_seconds()} seconds</td>
          <td><a href="${request.route_path('map_info', id=ct.map_id)}" title="Go to the detail page for this map">${ct.map_name}</a></td>
          <td><a href="${request.route_path('server_info', id=ct.server_id)}" title="Go to the detail page for this server">${ct.server_name}</a></td>
          <td><span class="abstime" data-epoch="${ct.create_dt_epoch}" title="${ct.create_dt.strftime('%a, %d %b %Y %H:%M:%S UTC')}">${ct.create_dt_fuzzy}</span></td>
      % endfor
      </tbody>
    </table>

  </div>
</div>

<!-- navigation links -->
${navlinks("player_captimes", captimes.page, captimes.last_page, player_id=player_id, search_query=request.GET)}
% endif
