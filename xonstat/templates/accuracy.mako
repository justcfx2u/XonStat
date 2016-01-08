<%def name="accuracy(data, weapons, weaponsFired)">

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
<table class="table table-condensed table-hover" style="margin-bottom:5px;text-align:right" id="accuracyTable">
<colgroup>
  <col style="min-width:150px">
  <col width="80px" style="min-width:80px">
% for weapon_cd in weapons:
  % if weaponFired.has_key(weapon_cd) or weapon_cd not in ["bfg","cg","ng","pm","gh"]:
  <col width="85px" style="min-width:85px">
  %endif
% endfor
</colgroup>
<thead>
    <th colspan="2"></th>    
% for weapon_cd in weapons:
    % if weaponFired.has_key(weapon_cd) or weapon_cd not in ["bfg","cg","ng","pm","gh"]:
    <th style="text-align:right"><img src="/static/images/24x24/${weapon_cd}.png" alt="${weapons[weapon_cd].descr}" style="width:24px; height:24px;"> ${weapons[weapon_cd].weapon_cd.upper()}</th>
    % endif
% endfor
</thead>

% for player_id in data:
<tr>
<td style="text-align:left"><a href="/player/${player_id}">${data[player_id]["nick"]|n}</a></td>
<td>&nbsp;</td>
% for weapon_cd in weapons:
  % if weaponFired.has_key(weapon_cd) or weapon_cd not in ["bfg","cg","ng","pm","gh"]: 
<td>&nbsp;</td>
  % endif
% endfor
</tr>
% endfor
</table>
</div>

<script>
var weaponCols=[], i=0;
% for weapon_cd in weapons:
  % if weaponFired.has_key(weapon_cd) or weapon_cd not in ["bfg","cg","ng","pm","gh"]:
weaponCols[i++] = '${weapon_cd}';
  %endif
% endfor

var weaponStats=[];
i=0;
% for player_id in data:
  var p = weaponStats[i++] = {};
  % for weapon_cd in weapons:
    % if weaponFired.has_key(weapon_cd) or weapon_cd not in ["bfg","cg","ng","pm","gh"]:
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
      p['${weapon_cd}'] = { kills: ${weapon_stat[0]}, acc: ${hit_pct}, hits: ${weapon_stat[2]}, fired: ${weapon_stat[3]} };     
    % endif
  % endfor
% endfor


</script>
</%def>
