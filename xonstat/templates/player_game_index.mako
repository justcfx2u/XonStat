<%inherit file="base.mako"/>
<%namespace name="nav" file="nav.mako" />
<%namespace file="navlinks.mako" import="navlinks" />
<% from xonstat.util import html_colors %>

<%block name="css">
${parent.css()}
</%block>

<%block name="navigation">
${nav.nav('games')}
</%block>

<%block name="title">
Recent Games
</%block>

% if not games:
<h2>Sorry, no 
    % if game_type_descr:
    ${game_type_descr.lower()}
    % endif
  games yet for 
  <a href="${request.route_path('player_info', id=player.player_id)}">${player.nick_html_colors()|n}</a>. Get playing!
</h2>
<p><a href="${player_url}">Back to player info page</a></p>

% else:
<div class="row">
  <div class="col-sm-12">
    <h3>Recent 
      % if game_type_descr:
      ${game_type_descr}
      % endif
      Games by 
      <a href="${request.route_path('player_info', id=player.player_id)}">
        ${player.nick_html_colors()|n}
      </a>
    </h3>
  </div>
</div>

<div class="row">
  <div class="col-sm-12 tabbable">
    <ul class="nav nav-tabs">
      % for game in games_played:
      % if not game.game_type_cd in ['cq']:
      <li 
      % if game.game_type_cd == game_type_cd or (game.game_type_cd == 'overall' and game_type_cd is None):
      class="active"
      % endif
      >
      % if game.game_type_cd == 'overall':
      <a href="${request.route_path("player_game_index", player_id=player.player_id)}" alt="${game.game_type_cd}" title="" data-toggle="none">
      % else:
      <a href="${request.route_path("player_game_index", player_id=player.player_id, _query={'type':game.game_type_cd})}" alt="${game.game_type_cd}" title="" data-toggle="none">
      % endif
        <img src="/static/images/icons/24x24/${game.game_type_cd}.png" width="24" height="24"><br />
        ${game.game_type_cd} <br />
      </a>
      </li>
      % endif
      % endfor
    </ul>
  </div>
  <div class="col-sm-12 tab-content" style="margin-top:10px;">
    <table class="table table-hover table-condensed">
      <thead>
        <tr>
          <th></th>
          <th>Played</th>
          <th>Type</th>
          <th>Server</th>
          <th>Map</th>
          <th>Result</th>
          <th>Opponent</th>
          <th>Rating</th>
          <th title="Rating &plusmn; Uncertainty">Old Glicko</th>
          <th title="Rating / Uncertainty">Glicko Change</th>
        </tr>
      </thead>
      <tbody>
      % for rg in games.items:
      <tr>
        <td class="tdcenter"><a class="btn btn-primary btn-small" href="${request.route_path('game_info', id=rg.game_id)}" title="View detailed information about this game">view</a></td>
        <td><span class="abstime" data-epoch="${rg.epoch}" title="${rg.start_dt.strftime('%a, %d %b %Y %H:%M:%S UTC')}">${rg.fuzzy_date}</span></td>
        <td><img title="${rg.game_type_cd}" src="/static/images/icons/24x24/${rg.game_type_cd}.png" alt="${rg.game_type_cd}" /> ${rg.game_type_cd}</td>
        <td><a href="${request.route_path("server_info", id=rg.server_id)}" name="Server info page for ${rg.server_name}">${rg.server_name}</a></td>
        <td><a href="${request.route_path("map_info", id=rg.map_id)}" name="Map info page for ${rg.map_name}">${rg.map_name}</a></td>
        <td class="
                    % if (rg.pg3_team != None and rg.pg3_team == rg.winner) or rg.pg3_rank == 1:
                        eloup
                    % else:
                        elodown
                    % endif
                    ">
            ${rg.score1}:${rg.score2}
                % if rg.game_type_cd != "duel":
                    (#${rg.pg3_rank})
                % endif
        </td>
        % if rg.pg3_player_id == rg.pg1_player_id:
            <td><a href="/player/${rg.pg2_player_id}">${html_colors(rg.pg2_nick)|n}</a></td>
            <td>
                %if rg.pg2_old_r:
                    ${int(round(rg.pg2_old_r))} &plusmn; ${int(round(rg.pg2_old_rd))}
                %endif
            </td>
        % else:
            <td><a href="/player/${rg.pg1_player_id}">${html_colors(rg.pg1_nick)|n}</a></td>
            <td>
                % if rg.pg1_old_r:
                    ${int(round(rg.pg1_old_r))} &plusmn; ${int(round(rg.pg1_old_rd))}
                % endif
            </td>
        % endif
        <td>${str(int(round(rg.pg3_old_r,0))) + " &plusmn; " + str(int(round(rg.pg3_old_rd,0))) if rg.pg3_old_r else ""|n}</td>
        <td class="tdcenter">
          <a href="${request.route_path('game_info', id=rg.game_id, _query={'show_elo':1})}" title="View detailed information about this game">           
            % if rg.pg3_delta_r is None or rg.pg3_delta_r==0:
            <span class="eloneutral"><i class="glyphicon glyphicon-minus"></i></span>
            % elif rg.pg3_delta_r > 0:
            <span class="eloup">+${int(round(rg.pg3_delta_r,0))} / ${int(round(rg.pg3_delta_rd, 0))}</span>
            %else:
            <span class="elodown">${int(round(rg.pg3_delta_r,0))} / ${int(round(rg.pg3_delta_rd, 0))}</span>
            % endif
          </a>
          %if rg.g2_status == 8:
          &nbsp; (<span title="B-Rating for fun mods">B</span>)
          %endif
        </td>
      </tr>
      % endfor
      </tbody>
    </table>
  </div>
</div>


<!-- navigation links -->
${navlinks("player_game_index", games.page, games.last_page, player_id=player_id, search_query=request.GET)}
% endif
