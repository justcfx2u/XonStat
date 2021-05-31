<%inherit file="base.mako"/>
<%namespace name="nav" file="nav.mako" />
<%namespace file="navlinks.mako" import="navlinks" />

<%block name="navigation">
${nav.nav('servers')}
</%block>

<%block name="title">
Server Index
</%block>

% if not servers:
<h2>Sorry, no servers yet. Get playing!</h2>

% else:
<div class="row">
  <div class="col-sm-12 col-md-8 col-md-offset-2">
    <form class="indexform" method="get" action="${request.route_path('search')}">
      <input type="hidden" name="fs" />
      <input class="indexbox" type="text" name="server_name" />
      <input type="submit" value="search" />
    </form>
    <table class="table table-hover table-condensed">
      <thead>
        <tr>
          <th style="width:60px;">ID</th>
          <th>Name</th>
          <th class="create-dt">Added</th>
          <th></th>
        </tr>
      </thead>
      <tbody>
        % for server in servers:
        <tr>
          <td>${server.server_id}</td>
          <td><a href="${request.route_path("server_info", id=server.server_id)}" title="Go to this server's info page">${server.name}</a></td>
          <td><span class="abstime" data-epoch="${server.epoch()}" title="${server.create_dt.strftime('%a, %d %b %Y %H:%M:%S UTC')}">${server.fuzzy_date()}</span></td>
          <td class="tdcenter">
            <a href="${request.route_path("game_index", _query={'server_id':server.server_id})}" title="View recent games on this server">
              <i class="glyphicon glyphicon-list"></i>
            </a>
          </td>
        </tr>
        % endfor
      </tbody>
    </table>

    ${navlinks("server_index", servers.page, servers.last_page)}
  </div> <!-- /span4 -->
</div> <!-- /row -->
% endif
