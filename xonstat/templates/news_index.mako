<%inherit file="base.mako"/>
<%namespace name="nav" file="nav.mako" />
<%namespace file="navlinks.mako" import="navlinks" />

<%block name="navigation">
${nav.nav('news')}
</%block>

<%block name="css">
${parent.css()}
<style>
  #pageFooter { display:none }
</style>
</%block>

<!DOCTYPE html>

<html lang="en" xmlns="http://www.w3.org/1999/xhtml">
<head>
  <meta charset="utf-8" />
  <title></title>
  <style>
    html, body { height: 100%; width: 100%; margin: 0; padding: 0; }
    iframe { position: absolute; top: 60px; left: 0; overflow: hidden; width: 100%; height: 90%; }
  </style>
</head>
<body>
  <iframe src="" frameborder="0" id="forumIframe"></iframe>

  <script>
    function onResize() { document.getElementById("forumIframe").style.height = (window.innerHeight - 65) + "px"; }

    onResize();
    var url = location.hash ?
      "${request.registry.settings.get('qlstat.forum_posting_url', '')}".replace("$1", location.hash.substr(1)) :
      "${request.registry.settings.get('qlstat.forum_index_url', '')}";
    document.getElementById("forumIframe").src = url;

    window.onresize = onResize;
  </script>
</body>
</html>