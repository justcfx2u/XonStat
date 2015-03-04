truncate table summary_stats;
truncate table servers cascade;
truncate table maps cascade;
truncate table hashkeys;
truncate table player_elos;
delete from players where player_id>2;

