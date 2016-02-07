<%!
from xonstat.util import html_colors
%>

<%inherit file="base.mako"/>
<%namespace name="nav" file="nav.mako" />
<%namespace file="navlinks.mako" import="navlinks" />

<%block name="css">
${parent.css()}
</%block>

<%block name="navigation">
${nav.nav('games')}
</%block>

<%block name="title">
Aliases
</%block>

%if data is None:
<div class="row">
  <div class="col-xs-12" style="text-align:center">
    <p>No data found</p>
  </div>
</div>
%else:
%for steamid in data:
%if steamid != "deactivated":
<div class="row">
  <div class="col-xs-12" style="text-align:center;margin-bottom:30px">
    Steam-ID: <a href="/player/${steamid}">${steamid}</a>
  </div>
  <div class="col-sm-6 col-sm-offset-3">
    <table class="table table-condensed">
      <thead>
        <tr>
          <th>Nickname</th>
          <th>Created</th>
        </tr>
      </thead>
      <tbody>

        %for alias in data[steamid]:
        <tr>
          <td>${html_colors(data[steamid][alias]["nick"])|n}</td>
          <td class="tdcenter">${data[steamid][alias]["created"]}</td>
        </tr>
        %endfor
      </tbody>
    </table>
  </div>
</div>
%endif
%endfor
%endif

