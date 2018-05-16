set search_path=xonstat,public;

update players set privacy_match_hist=3 where player_id in (24024, 26236);

do $$
declare gid bigint;
begin
select game_id into gid from games where match_id='a6558e8a-b1d4-4c69-acac-5cf3cf13c588';
delete from player_weapon_stats where game_id=gid;
delete from player_game_stats where game_id=gid;
delete from games where game_id=gid;
end
$$;


select * from players where player_id=14;
select * from hashkeys where hashkey='76561198137367816'
delete from hashkeys where hashkey='76561198137367816'          
delete from hashkeys where active_ind=false and timezone('UTC', now()) - delete_dt >= '-1 days';
select *,timezone('UTC', now()) - delete_dt from hashkeys where active_ind=false and timezone('UTC', now()) - delete_dt >= '-1 days';
delete from player_nicks where timezone('UTC', now()) - create_dt >= '60 days' and (last_used_dt is null or timezone('UTC', now()) - create_dt >= '60 days');
select * from player_nicks where player_id=23525
select * from players where player_id=23525

select timezone('utc',now()), now() - timezone('utc',now())

create or replace function xonstat.getOrCreatePlayer(steamid varchar(30), rawNick varchar(64), strippedNick varchar(64)) returns integer as $$
declare 
  id integer;
  dummy integer;
  oldNick varchar(64);
  active boolean;
  privacyMode integer;
  rowcount integer;
begin
  loop
    select h.active_ind, p.player_id, nick, privacy_match_hist 
      into active, id, oldNick, privacyMode 
      from xonstat.hashkeys h left outer join xonstat.players p on p.player_id=h.player_id where h.hashkey=steamid;
    if found then
      if not active then 
        -- player requested to be erased and forgotten
        return null;
      end if;
      if privacyMode<>3 then
        update xonstat.players set nick=rawNick, stripped_nick=strippedNick where player_id=id;
        update xonstat.player_nicks set last_used_dt=now() where player_id=id and stripped_nick=strippedNick;
        get diagnostics rowcount = row_count;
        if rowcount = 0 then
          insert into xonstat.player_nicks(player_id, stripped_nick, nick) values (id, strippedNick, rawNick);
        end if;
      end if;
      return id;
    end if;

    begin
      select nextval('xonstat.players_player_id_seq'::regclass) into id;
      insert into xonstat.players (player_id,privacy_match_hist,nick,stripped_nick) values (id, 3, 'Anonymous Player', 'Anonymous Player');
      insert into xonstat.hashkeys (player_id, hashkey) values (id, steamid);
      return id;
    exception when unique_violation then
      -- try again
    end;

    return null;
  end loop;
end;
$$ language plpgsql;

select getOrCreatePlayer('12345','foo','foo')