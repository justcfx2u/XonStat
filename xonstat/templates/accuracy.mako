<%def name="accuracy(weapon_stats)">

## Parameters: 
## weapon_stats is an array containing what we'll call "weapon_stat"
## objects. These objects have the following attributes:
##
## [0] = Weapon description
## [1] = Weapon code
## [2] = Actual damage
## [3] = Max damage
## [4] = Hit
## [5] = Fired

<table class="table table-condensed">
<colgroup>
  <col width="36px">
</colgroup>
<thead>
    <th></th>
    <th>Weapon</th>
    <th>Hit</th>
    <th>Fired</th>
    <th>Hit %</th>
    <th>Kills</th>
</thead>
% for weapon_stat in weapon_stats:
<%
if weapon_stat[3] > 0: 
    damage_pct = round(float(weapon_stat[2])/weapon_stat[3]*100, 2)
else:
    damage_pct = 0
if weapon_stat[5] > 0: 
    hit_pct = round(float(weapon_stat[4])/weapon_stat[5]*100, 2)
else:
    hit_pct = 0
%>
<tr>
    ## Note: the name of the image must match up with the weapon_cd 
    ## entry of that weapon, else this won't work
    <td><img src="/static/images/24x24/${weapon_stat[1]}.png" style="width:24px; height:24px;"></td>
    <td>${weapon_stat[0]}</td>
    <td>${weapon_stat[4]}</td>
    <td>${weapon_stat[5]}</td>
    <td>${hit_pct}%</td>
    <td>${weapon_stat[2]}</td>
</tr>
% endfor
</table>
</%def>
