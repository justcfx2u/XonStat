<%inherit file="base.mako"/>
<%namespace name="nav" file="nav.mako" />
<%
import json 
%>

<%block name="navigation">
% if player.email_addr is not None:
${nav.nav('players', True)}
% else:
${nav.nav('players', False)}
% endif
</%block>

<%block name="css">
${parent.css()}
<style>
#damageChart, #accuracyChart {
  height: 250px;
}
</style>
</%block>

<%block name="js">
${parent.js()}
<script type="text/javascript" src="https://www.google.com/jsapi?autoload={'modules':[{'name':'visualization','version':'1','packages':['corechart']}]}"></script>
<script src="/static/js/weaponCharts.min.js"></script>

<a id="jsonUrl" href="${request.route_url('player_weaponstats_data_json', id=player.player_id, _query={'limit':20})}" style="display:none"></a>
<script type="text/javascript">
// allow IIS URL rewriting by putting the URL inside <a href="...">
// (URLs in the JavaScript source won't be rewritten by IIS)
var jsonUrl = $("#jsonUrl").attr("href"); 

// tabs
$(function () {
  $('#gbtab li').click(function(e) {
    e.preventDefault();
    $(this).tab('show');
  })

  $('#gbtab a:first').tab('show');
})

// game type buttons
% for g in games_played:
$('.tab-${g.game_type_cd}').click(function() { 
  chartGameType="${g.game_type_cd}";
  loadDataAndDrawChart(); 
});
% endfor

// weapon accuracy and damage charts
var chartData, chartName = "accuracyChart", chartOpt = null, chartLimit=20, chartGameType=null;
google.load('visualization', '1.1', {packages: ['corechart']});
function loadDataAndDrawChart() {
  var url = jsonUrl + (chartGameType ? "&game_type=" + chartGameType : "");
  url = url.replace(/limit=\d+/, "limit=" + chartLimit);
  $.getJSON(url, function(data) {
    chartData = data;
    drawChart(chartName);
  });
}
function drawChart(chart, opt) {
  $(".row #chartArea").empty();
  $(".row #chartArea").append('<svg id="' + chart + 'SVG"></svg>')
  if (chart == "accuracyChart")
    drawAccuracyChart(chartData);
  else if (chart == "damageChart")
    drawDamageChart(chartData, opt == "1");
  else if (chart == "fragChart")
    drawFragChart(chartData, opt == "1");
  chartName = chart;
  chartOpt = opt;
}
$("#chartRow h3").click(function() {
  $("#chartRow h3").removeClass("selected");
  $(this).addClass("selected");
  drawChart($(this).data("chart"), $(this).data("arg"));
});
$("#chartRow h4").click(function() {
  $("#chartRow h4").removeClass("selected");
  $(this).addClass("selected");
  chartLimit=parseInt($(this).text()) || 20;
  if (!chartData || chartLimit != chartData.games.length)
    loadDataAndDrawChart();
  //else
  //  drawChart(chartName, chartOpt);
});
loadDataAndDrawChart();

///////////////////////////////////////////////////////////////////////////////

var data = [];
function loadRecentGames(game_type_cd) {
  var args = {};
  if (game_type_cd)
    args.game_type_cd = game_type_cd;
  $.getJSON("/player/${player.player_id}/recent_games.json", args, function(data) {
    fillRecentGames(data);
  });
}

function fillRecentGames(data) {
  var $tbody = $("#recentGames tbody");
  $tbody.empty();
  for (var i=0, c=data.length; i<c; i++) {
    var html=[];
    var rg = data[i];
    html.push('<td>' + (i+1) + '</td>');
    html.push('<td class="tdcenter"><a class="btn btn-primary btn-small" href="/game/' + rg.game_id + '" title="View detailed information about this game">view</a></td>');
    html.push('<td><img src="/static/images/icons/24x24/' + rg.game_type_cd + '.png" width="24" height="24" alt="' + rg.game_type_cd + '" title="' + rg.game_type_descr + '"> ' + rg.game_type_cd + '</td>');
    html.push('<td><a href="/server/' + rg.server_id + '" title="Go to the detail page for this server">' + rg.server_name + '</a></td>');
    html.push('<td><a href="/map/' + rg.map_id + '" title="Go to the detail page for this map">' + rg.map_name + '</a></td>');
    html.push('<td>' + (rg.team ? (rg.team == rg.winner ? "Win" : "Loss") : rg.rank == 1 ? "Win" : "Loss (#" + rg.rank + ")") + "</td>");
    html.push('<td><span class="abstime" data-epoch="' + rg.epoch + '">' + dateStr(rg.epoch) + '</span></td>');
    html.push('<td class="tdcenter"><a href="/game/' + rg.game_id + '" title="View detailed information about this game">');
    var delta = Math.round(rg.g2_delta_r) - Math.round(rg.g2_delta_rd);
    var alt = "r: " + Math.round(rg.g2_delta_r) + "; rd: " + Math.round(rg.g2_delta_rd);
    if (rg.g2_status != 1 || typeof(rg.g2_delta_r) !== "number")
      html.push('<span class="eloneutral"><i class="glyphicon glyphicon-minus"></i></span>');
    else if (rg.g2_delta_r > 0)
      html.push('<span class="eloup" title="' + alt + '">+' + delta + '</span>');
    else
      html.push('<span class="elodown" title="' + alt + '">' + delta + '</span>');
    html.push('</a></td>');

    $tbody.append("<tr>" + html.join("\n") + "</tr>");
  }
}

function dateStr(unixtimestamp) {
  var date = new Date();
  date.setTime(unixtimestamp * 1000);
  return (1900 + date.getYear()) + "-" + pad(date.getMonth() + 1) + "-" + pad(date.getDay()) + " " + pad(date.getHours()) + ":" + pad(date.getMinutes());

  function pad(num) {
    return ("0" + num).substr(-2);
  }
}

loadRecentGames(null);

$("#gbtab li a").click(function() {
  var alt = $(this).attr("alt");
  loadRecentGames(alt == "overall" ? null : alt);
});
</script>
<script src="https://login.persona.org/include.js" type="text/javascript"></script>
<script type="text/javascript">${request.persona_js}</script>
</%block>

<%block name="title">
Player Information
</%block>

<div class="row" style="min-height: 200px">
  <div class="col-sm-6 col-md-3">
    <h2 style="display:inline-block">${player.nick_html_colors()|n}</h2> <a href="/aliases/${hashkey}">Aliases</a>
    <p>
      <% 
      regions = [ "not set", "Europe", "Africa", "Asia", "Australia", "North America", "South America"]
      region = "unknown" if player.region is None or player.region > len(regions) else regions[player.region]
      %>
      Region: ${region}
      <br>Player ID: ${player.player_id}
      <br>Steam ID: ${hashkey}
      <br>Joined: <span class="abstime" data-epoch="${player.epoch()}" title="${player.create_dt.strftime('%a, %d %b %Y %H:%M:%S UTC')}">Joined ${player.joined_pretty_date()}</span>
      % if cake_day:
      <img src="/static/images/icons/24x24/cake.png" title="Happy cake day!" />
      % endif
    </p>
  </div>

  <div class="col-sm-12 col-md-9 col-lg-6">
    <ul id="gbtab" class="nav nav-tabs" style="margin-top:20px">
      % for g in games_played:
      <li class="tab-${g.game_type_cd}">
        <a href="#tab-${g.game_type_cd}" data-toggle="tab" alt="${g.game_type_cd}" title="${overall_stats[g.game_type_cd].game_type_descr}">
          <img src="/static/images/icons/24x24/${g.game_type_cd}.png" width="24" height="24"><br />
          ${g.game_type_cd} <br />
          <small>(${g.games})</small>
        </a>
      </li>
      % endfor
    </ul>
  </div>

  <div id="gbtabcontainer" class="col-sm-6 col-md-9 col-lg-3 tabbable tabs-below">
    <div class="tab-content">
      % for g in games_played:
      % if not g.game_type_cd in ['cq']:
      <div class="tab-pane  
        % if g.game_type_cd == 'overall':
        active
        % endif
        " id="tab-${g.game_type_cd}">

          <p>
          Win Rate: <small>${round(g.win_pct,2)}% (${g.wins} wins, ${g.losses} losses) <br /></small>

          % if g.game_type_cd in overall_stats:
          % if overall_stats[g.game_type_cd].k_d_ratio is not None:
          Kill Ratio: <small>${round(overall_stats[g.game_type_cd].k_d_ratio,2)} (${overall_stats[g.game_type_cd].total_kills} kills, ${overall_stats[g.game_type_cd].total_deaths} deaths) <br /></small>
          % endif
          % else:
          <small><br /></small>
          % endif

          % if g.game_type_cd in elos:
          % if g.game_type_cd == 'overall':
          Best Glicko: <small>${int(elos[g.game_type_cd].g2_r - elos[g.game_type_cd].g2_rd)} (${elos[g.game_type_cd].game_type_cd}, ${elos[g.game_type_cd].g2_games} games) <br /></small>
          % else:
          Glicko: <small>${int(elos[g.game_type_cd].g2_r - elos[g.game_type_cd].g2_rd)} (${elos[g.game_type_cd].g2_games} games) <br /></small>
          % endif
          % else:
          <small><br /></small>
          % endif

          
          % if g.game_type_cd in ranks:
          % if g.game_type_cd == 'overall':
            Best Rank: 
            <small>
              <a href="${request.route_url('rank_index', game_type_cd=ranks[g.game_type_cd].game_type_cd, region=player.region, _query={'page':(ranks[g.game_type_cd].rank-1)/20+1})}" title="Player rank page for this player">
                ${ranks[g.game_type_cd].rank} of ${ranks[g.game_type_cd].max_rank}
              </a>
              (${ranks[g.game_type_cd].game_type_cd}, percentile: ${round(ranks[g.game_type_cd].percentile,2)}) 
              <br />
            </small>
          % else:
          Rank: 
            <small>
              <a href="${request.route_url('rank_index', game_type_cd=g.game_type_cd, region=player.region, _query={'page':(ranks[g.game_type_cd].rank-1)/20+1})}" title="Player rank page for this player">
                ${ranks[g.game_type_cd].rank} of ${ranks[g.game_type_cd].max_rank}
              </a>
              (percentile: ${round(ranks[g.game_type_cd].percentile,2)})
              <br />
            </small>
          % endif
          % else:
          <small><br /></small>
          % endif
          

          % if g.game_type_cd == 'ctf':
          % if overall_stats[g.game_type_cd].cap_ratio is not None:
          Cap Ratio: <small>${round(overall_stats[g.game_type_cd].cap_ratio,2)} (${overall_stats[g.game_type_cd].total_captures} captures, ${overall_stats[g.game_type_cd].total_pickups} pickups) <br /></small>
          % else:
          <small><br /></small>
          % endif
          % else:
          <small><br /></small>
          % endif
          </p>

          <p>
          % if g.game_type_cd in overall_stats:
          Last Played: <small><span class="abstime" data-epoch="${overall_stats[g.game_type_cd].last_played_epoch}" title="${overall_stats[g.game_type_cd].last_played.strftime('%a, %d %b %Y %H:%M:%S UTC')}"> ${overall_stats[g.game_type_cd].last_played_fuzzy} </span> <br /></small>
          % else:
          <small><br /></small>
          % endif

          Games Played: 
          % if g.game_type_cd == 'overall':
          <small><a href="${request.route_url("player_game_index", player_id=player.player_id)}" title="View recent games">
          % else:
          <small><a href="${request.route_url("player_game_index", player_id=player.player_id, _query={'type':g.game_type_cd})}" title="View recent ${overall_stats[g.game_type_cd].game_type_descr} games">
          % endif
          ${g.games}</a> <br /></small>
          <!--
          Playing Time: <small>${overall_stats[g.game_type_cd].total_playing_time} <br /></small>
          -->
          % if g.game_type_cd in fav_maps:
          Favorite Map: <small><a href="${request.route_url("map_info", id=fav_maps[g.game_type_cd].map_id)}" title="Go to the detail page for this map">${fav_maps[g.game_type_cd].map_name}</a> <br /></small>
          % else:
          <small><br /></small>
          % endif

          % if g.game_type_cd == 'ctf':
          % if overall_stats[g.game_type_cd].total_captures is not None:
          <small><a href="${request.route_url("player_captimes", player_id=player.player_id)}">Fastest flag captures...</a> <br /></small>
          % else:
          <small><br /></small>
          % endif
          % else:
          <small><br /></small>
          % endif
          </p>
        </div>
        % endif
        % endfor
    </div>
  </div>

  

  
</div>

  ##### Charts ####
  <div id="chartRow" class="row">
    <div class="col-sm-12">
      <h3 data-chart="accuracyChart" class="selected">Accuracy</h3>
      <h3 data-chart="fragChart" data-arg="0">Frag #</h3>
      <h3 data-chart="fragChart" data-arg="1">Frag %</h3>
      <h3 data-chart="damageChart" data-arg="0">Damage #</h3>
      <h3 data-chart="damageChart" data-arg="1">Damage %</h3>
      <h4 class="selected">20</h4>
      <h4>50</h4>
      <h4>100</h4>
      <noscript>
        Sorry, but you've disabled JavaScript! It is required to draw the accuracy chart.
      </noscript>
      <div id="chartArea" style="height:300px">
        <!--<svg id="....ChartSVG"></svg>-->
      </div>
    </div> <!-- end span12 -->
  </div> <!-- end row -->


##### RECENT GAMES (v2) ####

<div class="row">
  <div class="col-sm-12" id="recentGames">
    <h3>Recent Games</h3>
    <table class="table table-hover table-condensed">
      <thead>
        <tr>
          <th>#</th>
          <th></th>
          <th>Type</th>
          <th>Server</th>
          <th>Map</th>
          <th>Result</th>
          <th>Played</th>
          <th title="Rating (Uncertainty)">Glicko Change</th>
        </tr>
      </thead>
      <tbody>

      </tbody>
    </table>
    <p><a href="${request.route_url("player_game_index", player_id=player.player_id, page=1)}" title="Game index for ${player.stripped_nick}">More...</a></p>
  </div>
</div>
