<%inherit file="base.mako"/>
<%namespace name="nav" file="nav.mako" />
<%namespace file="navlinks.mako" import="navlinks" />
<%from xonstat.util import html_colors %>

<%block name="navigation">
${nav.nav('maps')}
</%block>

<%block name="title">
% if gmap:
Map Information
% endif

${parent.title()}
</%block>

<%block name="css">
    ${parent.css()}
</%block>

% if gmap is None:
<h2>Sorry, that map wasn't found!</h2>

% else:
% if gmap.image != "":
    <div style="background-image: url(${gmap.image});" id="map-preview"></div>
% endif
<h2>${gmap.name}</h2>
<p>
  Added <span class="abstime" data-epoch="${gmap.epoch()}" title="${gmap.create_dt.strftime('%a, %d %b %Y %H:%M:%S UTC')}">${gmap.fuzzy_date()}</span>
</p>
<div class="row">
  <div class="col-sm-6 col-md-4">
    <h3>Top Scoring Players</h3>
    <table class="table table-hover table-condensed">
      <thead>
        <tr>
          <th style="width:40px;">#</th>
          <th style="width:150px;">Nick</th>
          <th style="width:90px;">Score</th>
        </tr>
      </thead>
      <tbody>
        <% i = 1 %>
        % for (score_player_id, score_nick, score_value) in top_scorers:
        <tr>
          <td>${i}</td>
          % if score_player_id != '-':
          <td class="nostretch" style="max-width:150px;"><a href="${request.route_path('player_info', id=score_player_id)}" title="Go to the player info page for this player">${score_nick|n}</a></td>
          % else:
          <td class="nostretch" style="max-width:150px;">${score_nick}</td>
          % endif
          <td>${score_value}</td>
        </tr>
        <% i = i+1 %>
        % endfor
        </tbody>
    </table>
  </div>


  <div class="col-sm-6 col-md-4">
    <h3>Most Active Players</h3>
    <table class="table table-hover table-condensed">
      <thead>
        <tr>
          <th style="width:40px;">#</th>
          <th style="width:150px;">Nick</th>
          <th style="width:90px;">Playing Time</th>
        </tr>
      </thead>
      <tbody>
        <% i = 1 %>
        % for (player_id, nick, alivetime) in top_players:
        <tr>
          <td>${i}</td>
          % if player_id != '-':
          <td class="nostretch" style="max-width:150px;"><a href="${request.route_path('player_info', id=player_id)}" title="Go to the player info page for this player">${nick|n}</a></td>
          % else:
          <td class="nostretch" style="max-width:150px;">${nick}</td>
          % endif
          <td>${alivetime}</td>
        </tr>
        <% i = i+1 %>
        % endfor
      </tbody>
    </table>
  </div>


  <div class="col-sm-6 col-md-4">
    <h3>Most Active Servers</h3>
    <table class="table table-hover table-condensed">
      <thead>
        <tr>
          <th style="width:40px;">#</th>
          <th style="width:150px;">Name</th>
          <th style="width:90px;"># Games</th>
        </tr>
      </thead>
      <tbody>
        <% i = 1 %>
        % for (server_id, name, times_played) in top_servers:
        <tr>
          <td>${i}</td>
          <td class="nostretch" style="max-width:150px;"><a href="${request.route_path('server_info', id=server_id)}" title="Go to the server info page for this server">${name}</a></td>
          <td>${times_played}</td>
        </tr>
        <% i = i+1 %>
        % endfor
      </tbody>
    </table>
  </div>
</div> <!-- /row -->

<div class="row">
  <div class="col-sm-12">
    <p class="note">*Most active stats are from the past 7 days</p>
  </div>
</div>

% if len(captimes) > 0:
<div class="row">
  <div class="col-sm-6 col-md-4">
    <h3>Best Flag Capture Times</h3>
    <table class="table table-hover table-condensed">
      <thead>
        <tr>
          <th>Nick</th>
          <th>Captime</th>
        </tr>
      </thead>
      <tbody>
        % for c in captimes:
        <tr>
          <td>
            % if c.player_id > 2:
            <a href="${request.route_path(" player_info", id=c.player_id)}"
               title="Go to the info page for this player">
              <span class="nick">${c.nick_html_colors|n}</span>
            </a>
            % else:
            <span class="nick">${c.nick_html_colors|n}</span>
            % endif
          </td>
          <td>
            <a href="${request.route_path(" game_info", id=c.game_id)}"
               title="View the game in which this cap was made">
              ${round(float(c.fastest_cap.seconds) + (c.fastest_cap.microseconds/1000000.0), 2)}
            </a>
          </td>
        </tr>
        % endfor
      </tbody>
    </table>
  </div>
</div>
% endif


% if len(recent_games) > 0:
<div class="row">
  <div class="col-sm-12">
    <h3>Most Recent Games</h3>
    <table class="table table-hover table-condensed">
      <thead>
        <tr>
          <th></th>
          <th>Time</th>
          <th>Type</th>
          <th>Server</th>
          <th>Players</th>
          <th>Result</th>
        </tr>
      </thead>
      <tbody>
        % for rg in recent_games:
        <tr>
          <td class="tdcenter"><a class="btn btn-primary btn-small" href="${request.route_path('game_info', id=rg.game_id)}" title="View detailed information about this game">View</a></td>
          <td><span class="abstime" data-epoch="${rg.epoch}" title="${rg.start_dt.strftime('%a, %d %b %Y %H:%M:%S UTC')}">${rg.fuzzy_date}</span></td>
          <td class="tdcenter"><img src="/static/images/icons/24x24/${rg.game_type_cd}.png" width="24" height="24" alt="${rg.game_type_cd}" title="${rg.game_type_descr}"></span></td>
          <td><a href="${request.route_path('server_info', id=rg.server_id)}" title="Go to the detail page for this server">${rg.server_name}</a></td>
          <td class="nostretch">
            % if rg.pg1_player_id > 2:
            <a href="${request.route_path('player_info', id=rg.pg1_player_id)}" title="Go to the player info page for this player">${html_colors(rg.pg1_nick)|n}</a>
            % else:
            ${html_colors(rg.pg1_nick)|n}
            % endif

            &nbsp; vs &nbsp;

            % if rg.pg2_player_id > 2:
            <a href="${request.route_path('player_info', id=rg.pg2_player_id)}" title="Go to the player info page for this player">${html_colors(rg.pg2_nick)|n}</a>
            % else:
            ${html_colors(rg.pg2_nick)|n}
            % endif
          </td>
          <td>${rg.score1}:${rg.score2}</td>
        </tr>
        % endfor
      </tbody>
    </table>
    <p><a href="${request.route_path('game_index', _query={'map_id':gmap.map_id})}">More...</a></p>
  </div>
</div>
% endif


% endif
