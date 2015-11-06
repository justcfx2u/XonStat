<%def name="accuracy(data, weapons)">

## Parameters: 
## data: dict[player_id] => {  nick, weapons: dict[weapon_cd] => { weapon, stats: []}}
##
## weapon_stats is an array containing what we'll call "weapon_stat"
## objects. These objects have the following attributes:
##
## [0] = Actual damage
## [1] = Max damage
## [2] = Hit
## [3] = Fired

<div style="width:100%;overflow-x:auto">
<table class="table table-condensed" style="min-width:1400px; margin-bottom:5px">
<colgroup>
  <col>
  <col width="80px">
% for weapon_cd in weapons:
  <col width="85px">
% endfor
</colgroup>
<thead>
    <th colspan="2"></th>    
% for weapon_cd in weapons:
    <th><img src="/static/images/24x24/${weapon_cd}.png" alt="${weapons[weapon_cd].descr}" style="width:24px; height:24px;"> ${weapons[weapon_cd].weapon_cd.upper()}</th>
% endfor
</thead>

% for player_id in data:
<tr>
<td>${data[player_id]["nick"]|n}</td>
<td>
  <div>Kills / Acc</div>
  <div style="font-size:x-small; color:#888">Hits / Shots</div>
</td>
% for weapon_cd in weapons:
<%
      weapon_stat = data[player_id]["weapons"][weapon_cd]
      if weapon_stat[1] > 0: 
          damage_pct = int(round(float(weapon_stat[0])/weapon_stat[1]*100, 0))
      else:
          damage_pct = 0
      if weapon_stat[3] > 0: 
          hit_pct = int(round(float(weapon_stat[2])/weapon_stat[3]*100, 0))
      else:
          hit_pct = 0
%>
      ## Note: the name of the image must match up with the weapon_cd 
      ## entry of that weapon, else this won't work
    
      <td>
        <div>${weapon_stat[0]} / ${hit_pct}%</div>
        <div style="font-size:x-small; color:#888">${weapon_stat[2]} / ${weapon_stat[3]}</div>
      </td>
  % endfor
</tr>
% endfor
</table>
</div>
</%def>
