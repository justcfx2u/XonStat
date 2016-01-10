update players p
set region=d.region
from (
  select player_id, region
  from (
    select player_id, region, row_number() over (partition by player_id) r
    from (
      select pg.player_id,s.region,count(1) as count
      from player_game_stats pg
      inner join games g on g.game_id=pg.game_id
      inner join servers s on s.server_id=g.server_id 
      where s.region is not null
      group by 1,2
      order by 1,3 desc,2
    ) data
   ) data2
   where r=1
) d
where d.player_id=p.player_id
and p.region is null;

