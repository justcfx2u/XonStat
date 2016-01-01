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
  <p>No data found</p>
%else:
%for steamid in data:
<h2><a href="/player/${steamid}">${steamid}</a></h2>
<table>
  <thead>
    <tr>
      <th>Nickname</th>
      <th>Created</th>
    </tr>
  </thead>
  <tbody>
      
  %for alias in data[steamid]:
  <tr>
    <td class="tdcenter">${html_colors(data[steamid][alias]["nick"])|n}</td>
    <td class="tdcenter">${data[steamid][alias]["created"]}</td>
  </tr>
  %endfor
  </tbody>
</table>
%endfor
%endif