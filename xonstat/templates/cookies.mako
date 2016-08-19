<%inherit file="base.mako"/>

<%block name="css">
${parent.css()}
<style>
  #blocked { display: none; }
  h2 { color: orange; }
</style>
</%block>

<h1>Cookie Policy</h1>
<p>
qlstats.net relies on the use of cookies to work properly.
<p><b>qlstats</b> itself uses cookies to <b>remember your user preferences</b> (game type, region, weapons in the accuracy graph, ...) and if you log in using your steam-id, a session-id.
<p>3rd party components from <b>Google and Valve/Steam</b>, which are used by qlstats, may also set cookies, which <b>can</b> be used by these 3rd parties to <b>track your browsing behavior</b> across multiple sites.
<p>

<div id="accept">
  <p>
  To continue using qlstats, you need to agree to the use of cookies.
  <p>
  <button onClick="acceptCookiePolicy();return false">Agree</button>
</div>

<div id="blocked">
  <h2>Your browser is blocking cookies</h2>
  <p>If you wish to use qlstats, you need to enable cookies in your browser and reload this page.
</div>


<script>
function acceptCookiePolicy() {
  setCookie("allowCookies", "true", true);

  var search = window.location.search;
  var params = {};
  search.replace(/[?&]+([^=&]+)=([^&]*)/gi, function(str,key,value) {
    params[key] = decodeURIComponent(value);
  });

  location.href = params["referer"] || "/";
}

setCookie("test", "ok", false);
if (getCookie("test") == "ok")
  setCookie("test", null);
else {
  document.getElementById("accept").style.display="none";
  document.getElementById("blocked").style.display="block";
}
</script>
