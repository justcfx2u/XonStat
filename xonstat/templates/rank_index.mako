<%inherit file="base.mako"/>
<%namespace file="navlinks.mako" import="navlinks" />

<%block name="title">
% if game_type_cd == 'ffa':
Free For All Rank Index
% elif game_type_cd == 'duel':
Duel Rank Index
% elif game_type_cd == 'tdm':
Team Deathmatch Rank Index
% elif game_type_cd == 'ctf':
Capture The Flag Rank Index
% endif
</%block>

<div class="row">
  <div class="span6 offset3">
    % if not ranks:
    <h2>Sorry, no ranks yet. Get some buddies together and start playing!</h2>

    % else:
    <table id="rank-index-table" class="table table-hover table-condensed" border="1">
      <tr>
        <th style="width:40px;">Rank</th>
        <th style="width:420px;">Nick</th>
        <th style="width:170px;" title="r: estimated rating
RD: rating deviation
r-RD: conservative rating
r&#xb1;RD: 68% confidence interval
r&#xb1;2*RD: 95% confidence interval
Low RD => high confidence, smaller changes">Glicko<br>r-RD &nbsp; (RD)</th>
        <th style="width:90px;">Elo<br>(old)</th>
        <th style="width:90px;" title="Number games included in the rating">Games</th>
      </tr>
      <% i = 1 %>
      % for rank in ranks:
      <tr>
        <td>${rank.PlayerRank.rank}</td>
        <td class="nostretch" style="max-width:420px;"><a href="${request.route_url("player_info", id=rank.PlayerRank.player_id)}" title="Go to this player's info page">${rank.PlayerRank.nick_html_colors()|n}</a></td>
        <td>${int(round(rank.PlayerElo.g2_r - rank.PlayerElo.g2_rd))} &nbsp; (${int(round(rank.PlayerElo.g2_rd))})</td>
        <td>${int(round(rank.PlayerElo.elo))}</td>
        <td>${rank.PlayerElo.g2_games}</td>
      </tr>
      <% i += 1 %>
      % endfor
    </table>
  </div> <!-- /span6 -->
</div> <!-- /row -->

<div class="row">
  <div class="span6 offset3">
    <!-- navigation links -->
    ${navlinks("rank_index", ranks.page, ranks.last_page, game_type_cd=game_type_cd)}
  </div> <!-- /span6 -->
</div> <!-- /row -->
% endif
