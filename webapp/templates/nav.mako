<%def name="nav(active='leaderboard', login_logout=False)">

<nav class="navbar navbar-inverse navbar-fixed-top" style="height: auto;">
  <div class="container-fluid">
    <div class="navbar-header">  
      <a class="navbar-toggle" data-toggle="collapse" data-target=".navbar-collapse">
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>
      </a>                      
      <a class="navbar-brand" href="${request.route_path('main_index')}">
        <img width="32" height="32" src="/static/css/img/menu_icon.png" alt="QL Logo" style="float:left;margin-top:-5px;margin-right:10px;-webkit-filter: drop-shadow(0px 5px 5px grey);" />
        QLStats
      </a>           
    </div>
    <div class="navbar-collapse collapse">
      <ul class="nav navbar-nav">
        <li 
          % if active=="leaderboard":
          class="active"
          % endif
          ><a href="${request.route_path('main_index')}" title="Leaderboard">Leaderboard</a></li>
        % if request.registry.settings.get("qlstat.forum_index_url", "") != "":
        <li 
          % if active=="news":
          class="active"
          % endif
          ><a href="${request.route_path('news_index')}" title="News/Forum">News/Forum</a></li>
        % endif
        <li 
          % if active=="players":
          class="active"
          % endif
          ><a href="${request.route_path('player_index')}" title="Player Index">Players</a></li>
        <li 
          % if active=="games":
          class="active"
          % endif
          ><a href="${request.route_path('game_index')}" title="Game Index">Games</a></li>
        <li 
          % if active=="servers":
          class="active"
          % endif
          ><a href="${request.route_path('server_index')}" title="Server Index">Servers</a></li>
        <li 
          % if active=="maps":
          class="active"
          % endif
          ><a href="${request.route_path('map_index')}" title="Map Index">Maps</a></li>

        %if request.registry.settings.get('qlstat.feeder_login_url'):
        <li 
          % if active=="account":
          class="active"
          % endif
          ><a href="/account/login" title="Login/Sign-up" id="navAccount" style="display:none">Login/Sign-up</a></li>

        <li><a href="/account/logout" title="Logout" id="navLogout" style="display:none">Logout</a></li>
        %endif
      </ul>


      <form class="navbar-form navbar-right" role="search" action="${request.route_path('search')}" method="get">
        <input type="hidden" name="fs" />
        <input type="search" class="input-small search" placeholder="search" name="sval" />
        <select class="search" name="stype">
          <option>players</option>
          <option>servers</option>
          <option>maps</option>
        </select>
        [<a href="${request.route_path('search')}" title="Advanced search">+</a>]
      </form>
    </div>
  </div>     

  <script>
  (function() {
    var oldOnLoad=window.onload;
    window.onload=function() {
      if (oldOnLoad)
        oldOnLoad();
      $.getJSON("/account/user", function (user) {
        if (user.id) {
          $("#navAccount").text(user.strippedNick).attr("href", "/my");
          $("#navLogout").css("display", "block");
        }
        $("#navAccount").css("display", "block");
      });
    };
  })();
  </script>

</nav>
</%def>

