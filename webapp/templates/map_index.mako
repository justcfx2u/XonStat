<%inherit file="base.mako"/>
<%namespace name="nav" file="nav.mako" />
<%namespace file="navlinks.mako" import="navlinks" />

<%block name="navigation">
${nav.nav('maps')}
</%block>

<%block name="title">
Map Index
</%block>

% if not maps:
<h2>Sorry, no maps yet. Get playing!</h2>

% else:
<div class="row">
  <div class="col-sm-8 col-sm-offset-2">
    <form class="indexform" method="get" action="${request.route_path('search')}">
      <input type="hidden" name="fs" />
      <input class="indexbox" type="text" name="map_name" />
      <input type="submit" value="search" />
    </form>
    <table class="table table-hover table-condensed">
      <thead>
        <tr>
          <th style="width:70px;">ID</th>
          <th>Name</th>
          <th>Added</th>
          <th></th>
        </tr>
      </thead>
      <tbody>
        % for map in maps:
        <tr>
          <td>${map.map_id}</td>
          <td><a href="${request.route_path("map_info", id=map.map_id)}" title="Go to this map's info page">${map.name}</a></td>
          <td><span class="abstime" data-epoch="${map.epoch()}" title="${map.create_dt.strftime('%a, %d %b %Y %H:%M:%S UTC')}">${map.fuzzy_date()}</span></td>
           <td class="tdcenter">
            <a href="${request.route_path("game_index", _query={'map_id':map.map_id})}" title="View recent games on this map">
              <i class="glyphicon glyphicon-list"></i>
            </a>
          </td>
        </tr>
        % endfor
      </tbody>
    </table>

    <!-- navigation links -->
    ${navlinks("map_index", maps.page, maps.last_page)}
  </div> <!-- /span4 -->
</div> <!-- /row -->
% endif
