<%namespace name="nav" file="nav.mako"/>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <title>QLStats: Player Statistics for Quake Live</title>
    <meta name="description" content="">
    <meta name="author" content="">

    <!--[if lt IE 9]>
      <script src="http://html5shim.googlecode.com/svn/trunk/html5.js"></script>
    <![endif]-->
    <link href='https://fonts.googleapis.com/css?family=Open+Sans&subset=latin,greek,cyrillic-ext,latin-ext,cyrillic' rel='stylesheet' type='text/css'>
    <link rel="shortcut icon" href="/static/favicon.ico?v=2">

    <%block name="css">
    <link href="/static/css/bootstrap.min.css" rel="stylesheet">
    <link href="/static/css/app.min.css" rel="stylesheet">
    </%block>

    <script>
      (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
      (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
      m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
      })(window,document,'script','//www.google-analytics.com/analytics.js','ga');
      ga('create', 'UA-71098578-1', 'auto');
      ga('send', 'pageview');
    </script>
  </head>

  <body>
    <%block name="navigation">
    ${nav.nav("leaderboard")}
    </%block>

    <div class="container">

      <%block name="hero_unit">
      </%block>

      <div class="row">
        <div class="span12" id="xonborder">
          <div id="title"><%block name="title"></%block></div>
            ${self.body()}
        </div> <!-- /xonborder -->
      </div> <!-- /main row -->

      <%block name="footer">
      <div class="row shadowtext">
        <div class="span10 offset1">
          <p class="text-center" >
		  QLStats is a <a href="http://www.quakelive.com" target="_blank">Quake Live</a> adaptation of <a href="http://stats.xonotic.org" target="_blank">XonStat</a>,
          which was originally created by Antibody for the game <a href="http://www.xonotic.net" target="_blank">Xonotic</a>.
		  <br /><a href="https://github.com/PredatH0r/xonstat" title="Go to the project page" target="_blank">QLStats sources</a> and 
		    <a href="https://github.com/antzucaro/XonStat" title="Go to the project page" target="_blank">XonStat sources</a> are licensed under GPLv2.
		  <br />Questions about Elo? It's explained at the bottom of the <a href="https://github.com/antzucaro/XonStat/wiki/FAQ" title="XonStat FAQ">XonStat FAQ</a>. 
		  </p>
        </div>
      </div>
      </%block>

      <%block name="js">
      <script type='text/javascript' src='//ajax.googleapis.com/ajax/libs/jquery/2.1.1/jquery.min.js'></script>
      <script type='text/javascript' src='/static/js/bootstrap.min.js'></script>
      </%block>

      <!-- RELATIVE TIME CONVERSION -->
      <script type="text/javascript">
      $('.abstime').each(function(i,e){
        var $e = $(e);
        var epoch = $e.attr('data-epoch');
        var d = new Date(0);
        d.setUTCSeconds(epoch);
        var dt = d.getFullYear() + "-" + ("0" + (d.getMonth() + 1)).toString().substr(-2) + "-" + ("0" + d.getDate()).substr(-2);
        var tm = ("0" + d.getHours()).toString().substr(-2) + ":" + ("0" + d.getMinutes()).toString().substr(-2) + ":" + ("0" + d.getSeconds()).toString().substr(-2);
        $e.attr("title", $e.text());
        $e.text(dt + "   " + tm);  
      });
      </script>
    </body>
</html>
