
create or replace function xonstat.getOrCreateMap(mapname varchar(64)) returns integer as $$
declare 
  id integer;
begin
  loop
    select map_id into id from xonstat.maps where name=mapname;
    if found then
      return id;
    end if;
    begin   
      insert into xonstat.maps (name) values (mapname);
    exception when unique_violation then
      -- try again
    end;
  end loop;
end;
$$ language plpgsql;

create or replace function xonstat.getOrCreateServer(addr varchar(30), servername varchar(64)) returns integer as $$
declare 
  id integer;
begin
  loop
    update xonstat.servers set name=servername where hashkey=addr;
    if found then
      select server_id into id from xonstat.servers where hashkey=addr;
      return id;
    end if;
    begin   
      insert into xonstat.servers (hashkey,name) values (addr,servername);
    exception when unique_violation then
      -- try again
    end;
  end loop;
end;
$$ language plpgsql;



create or replace function xonstat.getOrCreatePlayer(steamid varchar(30), rawNick varchar(64), strippedNick varchar(64)) returns integer as $$
declare 
  id integer;
  dummy integer;
  oldNick varchar(64);
  allowTracking boolean;
  privacyMode integer;
  rowcount integer;
begin
  loop
    select h.active_ind, p.player_id, nick, privacy_match_hist 
      into allowTracking, id, oldNick, privacyMode 
      from xonstat.hashkeys h left outer join xonstat.players p on p.player_id=h.player_id where h.hashkey=steamid;
    if found then
      if not allowTracking then 
        -- player requested to be erased and forgotten
        return null;
      end if;
      if privacyMode<>3 then 
        -- update nick and aliases in all modes except "anonymous"
        update xonstat.players set nick=rawNick, stripped_nick=strippedNick where player_id=id;
        update xonstat.player_nicks set last_used_dt=now() where player_id=id and stripped_nick=strippedNick;
        get diagnostics rowcount = row_count;
        if rowcount = 0 then
          insert into xonstat.player_nicks(player_id, stripped_nick, nick) values (id, strippedNick, rawNick);
        end if;
        return id;
      end if;
      return -id; -- negative value to indicate privacy = anonymous 
    end if;

    begin
      select nextval('xonstat.players_player_id_seq'::regclass) into id;
      insert into xonstat.players (player_id,privacy_match_hist,nick,stripped_nick) values (id, 3, 'Anonymous', 'Anonymous');
      insert into xonstat.hashkeys (player_id, hashkey) values (id, steamid);
      return -id; -- negative value to indicate privacy = anonymous 
    exception when unique_violation then
      -- try again
    end;

    return null;
  end loop;
end;
$$ language plpgsql;

