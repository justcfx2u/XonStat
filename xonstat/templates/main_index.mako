<%inherit file="base.mako"/>

<%block name="title">
Leaderboard
</%block>

<%block name="css">
  ${parent.css()}
</%block>

<%block name="hero_unit">
<div class="text-center shadowtext" style="margin-top: 40px">
  <p id="statline">
    % if stat_line is None:
    Tracking Quake Live statistics since November 2015.
    % else:
    Tracking ${stat_line|n} since November 2015.
    % endif

    % if day_stat_line is not None:
    <br />${day_stat_line|n} in the past 24 hours.
    % endif
  </p>
</div>

<div class="row newsitem" style="background-color:#822;display:none">
  <div class="col-sm-2">
    2016-01-07 22:16 CET
  </div>
  <div class="col-sm-10">
    Duel ratings are being recalculated. ETA ~1.5h
    <br />CA, FFA, TDM, CTF and FT are already done.
  </div>
</div>

<div class="row newsitem">
  <div class="col-sm-2">
    2016-01-14 14:45 CET
  </div>
  <div class="col-sm-10">
    Players with VAC bans or offending nicknames are no longer included in the ranking (but still have a rating)
  </div>
</div>

<div class="row newsitem">
  <div class="col-sm-2">
    2016-01-06 21:00 CET
  </div>
  <div class="col-sm-10">
    added <a href="/news">News/Forum</a> (hosted by plusforward.net) with a <a href="/news#4488">Rating Q&A</a> thread
  </div>
</div>

</%block>

<%block name="js">
  ${parent.js()}

<script>
  var region=parseInt(getCookie("region")) || 1;
  var gameType=getCookie("gametype") || "duel";
  var dataCache={};

  function fillRanking(region, gameType) {
    $("#moreRanking").attr("href", "/ranks/" + gameType + "/" + region);

    if (dataCache.hasOwnProperty(gameType + region))
      fillTable();
    else {
      dataCache[gameType + region] = null;
      $.getJSON("/ranks/" + gameType + "/" + region + ".json", { limit: 10 }, function(data) {
        dataCache[gameType + region] = data;
        fillTable();
      })
      .fail(function(err) { console.log(err); });
    }

    function fillTable() {
      var data = dataCache[gameType + region] || { players: []};
      for (var i=1, c=data.players.length; i<=10; i++) {
        var player=data.players[i-1];
        var $row = $($("#rankingTable tr")[i]);
        var $cells = $row.children();
        $($cells[1]).html(i < c ? "<a href='/player/" + player.player_id + "'>" + player.html_name + "</a>" : "");
        $($cells[2]).html(i < c ? player.rating : "").attr("title", i < c ? "\xb1 " + player.rd : "").css("cursor", "help");
      }
      $("#ratingSelection a").removeClass("selected");
      $("#ratingSelection a[data-region='" + region + "']").addClass("selected");
      $("#ratingSelection a[data-gt='" + gameType + "']").addClass("selected");
    }
  }

  $("#ratingSelection a").on("click", function() {
    var r = $(this).data("region");
    if (r) {
      region = r;
      setCookie("region", region);
    }
    else {
      gameType = $(this).data("gt");
      setCookie("gametype", gameType);
    }
    fillRanking(region, gameType);
  });

  fillRanking(region, gameType);
</script>
</%block>

<div class="row">

  ##### RANKS #####
  <div class="col-sm-6 col-md-3">
    <div><h3 style="display:inline-block">Player Ranking</h3><img class="info" alt="information" title="updated daily at 12:00 CET&#x0a;requires a minimum of 10 matches&#x0a;offenders are excluded from rankings" /></div>
    <div id="ratingSelection" style="float:left;width:50px">
      <a data-region="1">EU</a><br>
      <a data-region="5">NA</a><br>
      <a data-region="6">SA</a><br>
      <a data-region="4">AU</a><br>
      <a data-region="3">AS</a><br>
      <a data-region="2">AF</a><br>
      <br>
      <a data-gt="duel">Duel</a><br>
      <a data-gt="ca">CA</a><br>
      <a data-gt="ffa">FFA</a><br>
      <a data-gt="ctf">CTF</a><br>
      <a data-gt="tdm">TDM</a><br>
      <a data-gt="ft">FT</a>
    </div>
    <div style="overflow:hidden">
      <table id="rankingTable" class="table table-hover table-condensed" style="table-layout:fixed;width:100%">
        <thead>
          <tr>
            <th style="width:25px">#</th>
            <th>Player</th>
            <th style="width:50px">Glicko</th>
          </tr>
        </thead>
        <tbody>

          <% i = 1 %>
          % while i <= 10:
          <tr>
            <td>${i}</td>
            <td style="white-space:nowrap;overflow-x:hidden"></td>
            <td></td>
          </tr>
          <% i = i+1 %>
          % endwhile

        </tbody>
      </table>
      <p class="note"><a id="moreRanking" href="" title="See more rankings">More...</a></p>
    </div>
  </div> <!-- /span3 -->

  ##### ACTIVE MAPS #####
  <div class="col-sm-6 col-md-3 col-md-push-6">
    <h3 style="display:inline-block">Most Active Maps</h3><img class="info" alt="information" title="updated every hour with data from the past 7 days" />
    <table class="table table-hover table-condensed">
      <thead>
        <tr>
          <th style="width:40px;">#</th>
          <th style="width:180px;">Map</th>
          <th style="width:60px;">Games</th>
        </tr>
      </thead>
      <tbody>
        <% i = 1 %>
        % for (map_id, name, count) in top_maps:
        <tr>
          <td>${i}</td>
          % if map_id != '-':
          <td class="nostretch" style="max-width:180px;"><a href="${request.route_url('map_info', id=map_id)}" title="Go to the map info page for ${name}">${name}</a></td>
          % else:
          <td class="nostretch" style="max-width:180px;">${name}</td>
          % endif
          <td>${count}</td>
        </tr>
        <% i = i+1 %>
        % endfor
      </tbody>
    </table>
    <p class="note"><a href="${request.route_url('top_maps_by_times_played', page=1)}" title="See more map activity">More...</a></p>
  </div> <!-- /span4 -->
 
  ##### ACTIVE SERVERS #####
  <div class="col-sm-12 col-md-6 col-md-pull-3">
    <h3 style="display:inline-block">Most Active Servers</h3><img class="info" alt="information" title="updated every hour with data from the past 7 days"/>
    <p style="position:absolute;right:15px;top:20px"><a class="btn btn-primary btn-small" href="http://qlstats.net:8081/servers.html">Add Server</a></p>
    <table class="table table-hover table-condensed">
      <thead>
        <tr>
          <th style="width:40px;">#</th>
          <th style="width:40px;">Loc</th>
          <th style="width:250px;">Server</th>
          <th style="width:60px;">Games</th>
        </tr>
      </thead>
      <tbody>
        <% i = 1 %>
        % for (server_id, name, count, country_code, country_name) in top_servers:
        <tr>
          <td>${i}</td>
          <td>
            % if country_code is not None:
            <img src="/static/images/flags/${country_code.lower()}.png" alt="${country_name}" class="flag"> ${country_code}
            % endif
          </td>
          % if server_id != '-':
          <td class="nostretch" style="max-width:180px;"><a href="${request.route_url('server_info', id=server_id)}" title="Go to the server info page for ${name}">${name}</a></td>
          % else:
          <td class="nostretch" style="max-width:180px;">${name}</td>
          % endif
          <td>${count}</td>
        </tr>
        <% i = i+1 %>
        % endfor
      </tbody>
    </table>
    <p class="note"><a href="${request.route_url('top_servers_by_players', page=1)}" title="See more server activity">More...</a></p>
  </div> <!-- /span4 -->

</div> <!-- /row -->

##### RECENT GAMES #####
% if len(recent_games) > 0:
<div class="row">
  <div class="col-sm-12">
    <h3>Recent Games</h3>
    <table class="table table-hover table-condensed">
      <thead>
        <tr>
          <th></th>
          <th>Type</th>
          <th>Loc</th>
          <th>Server</th>
          <th>Map</th>
          <th>Time</th>
          <th>Winner</th>
          <th>Score</th>
          <th>Rated</th>
        </tr>
      </thead>
      <tbody>
        % for rg in recent_games:
        <tr>
          <td class="tdcenter"><a class="btn btn-primary btn-small" href="${request.route_url('game_info', id=rg.game_id)}" title="View detailed information about this game">view</a></td>
          <td><img src="/static/images/icons/24x24/${rg.game_type_cd}.png" alt="${rg.game_type_cd}" width="24" height="24"> ${rg.game_type_cd}</td>
          <td>
            % if rg.country is not None:
            <img src="/static/images/flags/${rg.country.lower()}.png" alt="${rg.country}" width="24" height="24" class="flag"> ${rg.country}
            % endif
          </td>
          <td><a href="${request.route_url('server_info', id=rg.server_id)}" title="Go to the detail page for this server">${rg.server_name}</a></td>
          <td><a href="${request.route_url('map_info', id=rg.map_id)}" title="Go to the map detail page for this map">${rg.map_name}</a></td>
          <td><span class="abstime" data-epoch="${rg.epoch}">${rg.start_dt.strftime('%Y-%m-%d   %H:%M:%S')}</span></td>
          <td class="nostretch">
            % if rg.player_id > 2:
            <a href="${request.route_url('player_info', id=rg.player_id)}" title="Go to the player info page for this player">${rg.nick_html_colors|n}</a>
            % else:
            ${rg.nick_html_colors|n}
            % endif
          </td>
          <td>
            % if rg.score1 is not None:
            ${rg.score1 if rg.score1 is not None else "DNF"}:${rg.score2 if rg.score2 is not None else "DNF"}
            % endif
          </td>
          <td class="tdcenter">
            %if rg.g2_status == 0:
            TBD
            %elif rg.g2_status == 1:
            A
            %elif rg.g2_status == 8:
            B
            %else:
            <i class="glyphicon glyphicon-minus"></i>
            %endif
          </td>
        </tr>
        % endfor
      </tbody>
    </table>
    <p><a href="${request.route_url('game_index')}">More...</a></p>
  </div> <!-- /span12 -->
</div> <!-- /row -->
% endif
