<%def name="scoreboard(game_type_cd, pgstats, show_elo=False, show_latency=False)">
<table  class="table table-hover table-condensed">
  ${scoreboard_header(game_type_cd, pgstats[0], show_elo)}
  <tbody>
  % for pgstat in pgstats:
    <tr class="${pgstat.team_html_color()}">
      % if show_latency and pgstat.avg_latency is not None:
        <td class="tdcenter">
          ${int(round(pgstat.avg_latency))}
        </td>
      % elif show_latency:
        <td class="tdcenter">-</td>
      % endif

      <td class="player-nick">
        % if pgstat.player_id > 2:
          <a href="${request.route_url("player_info", id=pgstat.player_id)}"
            title="Go to the info page for this player">
            <span class="nick">${pgstat.nick_html_colors()|n}</span>
          </a>
        % else:
          <span class="nick">${pgstat.nick_html_colors()|n}</span>
        % endif
      </td>

      ${scoreboard_row(game_type_cd, pgstat)}

      % if game_type_cd != 'cts' and game_type_cd != 'race':
        <td class="player-score">${pgstat.score}</td>
      % endif
      % if game_type_cd == "ctf":
        <td class="player-score">${pgstat.g2_score}</td>
      % endif

      % if show_elo and game_type_cd != 'race':
        <% 
        if game_type_cd in ["ctf", "ffa"]:
          delta = None if pgstat.g2_delta_r is None else str(round(pgstat.g2_delta_r,0)) + " / " + str(round(pgstat.g2_delta_rd, 0))
        else:
          delta = None if pgstat.elo_delta is None else round(pgstat.elo_delta,2)
        %>
        % if delta is not None:
          <td>${delta}</td>
        % else:
          <td>-</td>
        % endif
      % endif
    </tr>
  % endfor
  </tbody>
</table>
</%def>

##### SCOREBOARD HEADER #####
<%def name="scoreboard_header(game_type_cd, pgstat, show_elo)">
% if game_type_cd == 'as':
<thead>
  <tr>
    % if show_latency:
    <th class="ping">Ping</th>
    % endif
    <th class="nick">Nick</th>
    <th class="time">Time</th>
    <th class="kills">Kills</th>
    <th class="deaths">Deaths</th>
    <th class="suicides">Suicides</th>
    <th class="objectives">Objectives</th>
    <th class="score">Score</th>
    % if show_elo:
    <th>Elo Change</th>
    % endif
  </tr>
</thead>
% endif

% if game_type_cd in 'ca' 'ffa' 'duel' 'tdm':
<thead>
  <tr>
    % if show_latency:
    <th class="ping">Ping</th>
    % endif
    <th class="nick">Nick</th>
    <th class="time">Time</th>
    <th class="kills">Kills</th>
    <th class="deaths">Deaths</th>
    <th class="kills">Damage Dealt</th>
    <th class="deaths">Damage Taken</th>
    <th class="score">Score</th>
    % if show_elo:
    <th>Elo Change</th>
    % endif
  </tr>
</thead>
% endif

% if game_type_cd == 'cq':
<thead>
  <tr>
    % if show_latency:
    <th class="ping">Ping</th>
    % endif
    <th class="nick">Nick</th>
    <th class="time">Time</th>
    <th class="kills">Kills</th>
    <th class="deaths">Deaths</th>
    <th class="captured">Captured</th>
    <th class="released">Released</th>
    <th class="score">Score</th>
    % if show_elo:
    <th>Elo Change</th>
    % endif
  </tr>
</thead>
% endif

% if game_type_cd == 'cts':
<thead>
  <tr>
    % if show_latency:
    <th class="ping">Ping</th>
    % endif
    <th class="nick">Nick</th>
    <th class="fastest">Fastest Time</th>
    <th class="deaths">Deaths</th>
  </tr>
</thead>
% endif

% if game_type_cd == 'ctf':
<thead class="ctf ${pgstat.team_html_color()}">
  <tr>
    % if show_latency:
    <th class="ping">Ping</th>
    % endif
    <th class="nick">Nick</th>
    <th class="time">Time</th>
    <th class="kills">Kills</th>
    <th class="captures">Captures</th>
    <th class="returns">Assists</th>
    <th class="drops">Defends</th>
    <th class="pickups">Damage Dealt</th>
    <th class="fck">Damage Taken</th>
    <th class="score">Score</th>
    <th class="score">Perf</th>
    % if show_elo:
    <th>Elo Change</th>
    % endif
  </tr>
</thead>
% endif

% if game_type_cd == 'dom':
<thead class="dom ${pgstat.team_html_color()}">
  <tr>
    % if show_latency:
    <th class="ping">Ping</th>
    % endif
    <th class="nick">Nick</th>
    <th class="time">Time</th>
    <th class="kills">Kills</th>
    <th class="deaths">Deaths</th>
    <th class="takes">Takes</th>
    <th class="ticks">Ticks</th>
    <th class="score">Score</th>
    % if show_elo:
    <th>Elo Change</th>
    % endif
  </tr>
</thead>
% endif

% if game_type_cd in 'ft' 'freezetag':
<thead class="freezetag ${pgstat.team_html_color()}">
  <tr>
    % if show_latency:
    <th class="ping">Ping</th>
    % endif
    <th class="nick">Nick</th>
    <th class="time">Time</th>
    <th class="kills">Kills</th>
    <th class="deaths">Deaths</th>
    <th class="revivals">Thaws</th>
    <th class="score">Score</th>
    % if show_elo:
    <th>Elo Change</th>
    % endif
  </tr>
</thead>
% endif

% if game_type_cd in 'ka' 'keepaway':
<thead>
  <tr>
    % if show_latency:
    <th class="ping">Ping</th>
    % endif
    <th class="nick">Nick</th>
    <th class="time">Time</th>
    <th class="kills">Kills</th>
    <th class="deaths">Deaths</th>
    <th class="pickups">Pickups</th>
    <th class="bctime">BC Time</th>
    <th class="bckills">BC Kills</th>
    <th class="score">Score</th>
    % if show_elo:
    <th>Elo Change</th>
    % endif
  </tr>
</thead>
% endif

% if game_type_cd == 'kh':
<thead class="kh ${pgstat.team_html_color()}">
  <tr>
    % if show_latency:
    <th class="ping">Ping</th>
    % endif
    <th class="nick">Nick</th>
    <th class="time">Time</th>
    <th class="kills">Kills</th>
    <th class="deaths">Deaths</th>
    <th class="pickups">Pickups</th>
    <th class="caps">Captures</th>
    <th class="losses">Losses</th>
    <th class="pushes">Pushes</th>
    <th class="destroys">Destroys</th>
    <th class="kckills">KC Kills</th>
    <th class="score">Score</th>
    % if show_elo:
    <th>Elo Change</th>
    % endif
  </tr>
</thead>
% endif

% if game_type_cd in 'nb' 'nexball':
<thead class="nb ${pgstat.team_html_color()}">
  <tr>
    % if show_latency:
    <th class="ping">Ping</th>
    % endif
    <th class="nick">Nick</th>
    <th class="time">Time</th>
    <th class="goals">Goals</th>
    <th class="faults">Faults</th>
    <th class="score">Score</th>
    % if show_elo:
    <th>Elo Change</th>
    % endif
  </tr>
</thead>
% endif

% if game_type_cd == 'race':
<thead>
  <tr>
    % if show_latency:
    <th class="ping">Ping</th>
    % endif
    <th class="nick">Nick</th>
    <th class="time">Time</th>
  </tr>
</thead>
% endif

</%def>

##### SCOREBOARD ROWS #####
<%def name="scoreboard_row(game_type_cd, pgstat)">
% if game_type_cd == 'as':
  <td>${pgstat.alivetime}</td>
  <td>${pgstat.kills}</td>
  <td>${pgstat.deaths}</td>
  <td>${pgstat.suicides}</td>
  <td>${pgstat.collects}</td>
% endif

% if game_type_cd in 'ca' 'ffa' 'duel' 'rune' 'tdm':
  <td>${pgstat.alivetime}</td>
  <td>${pgstat.kills}</td>
  <td>${pgstat.deaths}</td>
  <td>${pgstat.pushes}</td>
  <td>${pgstat.destroys}</td>
% endif

% if game_type_cd == 'cq':
  <td>${pgstat.alivetime}</td>
  <td>${pgstat.kills}</td>
  <td>${pgstat.deaths}</td>
  <td>${pgstat.captures}</td>
  <td>${pgstat.drops}</td>
% endif

% if game_type_cd == 'cts':
  % if pgstat.fastest is not None:
    <td>${round(float(pgstat.fastest.seconds) + (pgstat.fastest.microseconds/1000000.0), 2)}</td>
  % else:
    <td>-</td>
  % endif

  <td>${pgstat.deaths}</td>
% endif

% if game_type_cd == 'ctf':
  <td>${pgstat.alivetime}</td>
  <td>${pgstat.kills}</td>
  <td>${pgstat.captures}</td>
  <td>${pgstat.returns}</td>
  <td>${pgstat.drops}</td>
  <td>${pgstat.pushes}</td>
  <td>${pgstat.destroys}</td>
% endif

% if game_type_cd == 'dom':
  <td>${pgstat.alivetime}</td>
  <td>${pgstat.kills}</td>
  <td>${pgstat.deaths}</td>
  <td>${pgstat.pickups}</td>
  <td>${pgstat.drops}</td>
% endif

% if game_type_cd in 'ft' 'freezetag':
  <td>${pgstat.alivetime}</td>
  <td>${pgstat.kills}</td>
  <td>${pgstat.deaths}</td>
  <td>${pgstat.revivals}</td>
% endif

% if game_type_cd in 'ka' 'keepaway':
  <td>${pgstat.alivetime}</td>
  <td>${pgstat.kills}</td>
  <td>${pgstat.deaths}</td>
  <td>${pgstat.pickups}</td>

  % if pgstat.time is not None:
    <td>${round(float(pgstat.time.seconds) + (pgstat.time.microseconds/1000000.0), 2)}</td>
  % else:
    <td>-</td>
  % endif

  <td>${pgstat.carrier_frags}</td>
% endif

% if game_type_cd == 'kh':
  <td>${pgstat.alivetime}</td>
  <td>${pgstat.kills}</td>
  <td>${pgstat.deaths}</td>
  <td>${pgstat.pickups}</td>
  <td>${pgstat.captures}</td>
  <td>${pgstat.drops}</td>
  <td>${pgstat.pushes}</td>
  <td>${pgstat.destroys}</td>
  <td>${pgstat.carrier_frags}</td>
% endif

% if game_type_cd in 'nb' 'nexball':
  <td>${pgstat.alivetime}</td>
  <td>${pgstat.captures}</td>
  <td>${pgstat.drops}</td>
% endif

% if game_type_cd == 'race':
  % if pgstat.score is not None and pgstat.score > 0:
    <td class="player-score">${round(float(pgstat.score)/1000,3)}</td>
  % else:
    <td>-</td>
  % endif
% endif

</%def>
