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
  #xonborder { border-radius: 0; padding-top: 0 }
  body { background-color:#ccc;}
    html, body { height: 100%; width: 100%; margin: 0; padding: 0; }
    iframe { position: absolute; top: 60px; left: 0; overflow: hidden; width: 100%; height: 90%; }
</style>
</%block>

<%block name="js">
${parent.js()}
<script>
  function onResize() { document.getElementById("forumIframe").style.height = (window.innerHeight - 65) + "px"; }

  onResize();
  var url = location.hash ?
    "${request.registry.settings.get('qlstat.forum_posting_url', '')}".replace("$1", location.hash.substr(1)) :
    "${request.registry.settings.get('qlstat.forum_index_url', '')}";
  document.getElementById("forumIframe").src = url;

  window.onresize = onResize;
</script>
</%block>

<iframe src="" frameborder="0" id="forumIframe"></iframe>

