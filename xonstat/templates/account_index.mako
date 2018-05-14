<%inherit file="base.mako"/>
<%namespace name="nav" file="nav.mako" />
<%namespace file="navlinks.mako" import="navlinks" />

<%block name="navigation">
${nav.nav('account')}
</%block>

<%block name="css">
${parent.css()}
<style>
  #pageFooter { display:none }
  #xonborder { border-radius: 0; padding-top: 0 }
  html, body { height: 100%; width: 100%; margin: 0; padding: 0; background-color:#444; }
  iframe { position: absolute; top: 38px; left: 0; overflow: hidden; width: 100%; height: 90%; }
</style>
</%block>

<%block name="js">
${parent.js()}
<script>
(function() {
  var oldOnResize = window.resize;

  $.ajax({dataType:"json", url:"/account/user", success:getUserInfoSuccess, error:getUserInfoError});

  function getUserInfoSuccess(user) {
    if (user.id) {
      $("#navAccount").text(user.displayName);
      $("#iframePlaceholder").after('<iframe src="/account" frameborder="0" id="accountIframe"></iframe>');
      onResize();
      window.onresize = onResize;
    }
    else
      getUserInfoError();
  }

  function getUserInfoError() {
    var url = "${request.registry.settings.get('qlstat.feeder_login_url', '')}";
    location.replace(url);
  }

  function onResize() { 
    if (oldOnResize)
      oldOnResize();
    $("#accountIframe").css("height", (window.innerHeight - 73) + "px"); 
  }
})();
</script>
</%block>

<div id="iframePlaceholder"></div>

