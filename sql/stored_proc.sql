
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


create or replace function xonstat.getAndUpdatePlayer(steamid varchar(30), rawNick varchar(64), strippedNick varchar(64)) returns integer as $$
declare 
  id integer;
  dummy integer;
  oldNick varchar(64);
begin
  loop
    select p.player_id, nick into id, oldNick from xonstat.players p inner join xonstat.hashkeys h on h.player_id=p.player_id where h.hashkey=steamid;
    if found then
      if (oldNick <> strippedNick) then
        select player_id into dummy from xonstat.player_nicks where player_id=id and stripped_nick=strippedNick;
        if not found then
          insert into xonstat.player_nicks(player_id, stripped_nick, nick) values (id, strippedNick, rawNick);
        end if;
        update xonstat.players set nick=rawNick, stripped_nick=strippedNick where player_id=id;
      end if;
      return id;
    end if;
    return null;
  end loop;
end;
$$ language plpgsql;

