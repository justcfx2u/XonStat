do $$
declare 
  start integer := 0;
  step integer := 1000;
  maxid integer;
begin
  select max(game_id) into maxid from games;
  loop
    raise notice 'ids starting with %', start;
    update games set match_id=m.match_id from tmp_game_id m where m.min=games.game_id and games.game_id between start and start+step;
    start := start+step;
    exit when start > maxid;    
  end loop;
end
$$ language plpgsql;


