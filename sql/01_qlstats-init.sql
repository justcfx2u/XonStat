delete from cd_weapon;
alter table cd_weapon add column weapon_num smallint not null;
insert into cd_weapon(weapon_num, weapon_cd, descr) values (1, 'gt', 'Gauntlet');
insert into cd_weapon(weapon_num, weapon_cd, descr) values (2, 'mg', 'Machinegun');
insert into cd_weapon(weapon_num, weapon_cd, descr) values (3, 'sg', 'Shotgun');
insert into cd_weapon(weapon_num, weapon_cd, descr) values (4, 'gl', 'Grenade Launcher');
insert into cd_weapon(weapon_num, weapon_cd, descr) values (5, 'rl', 'Rocket Launcher');
insert into cd_weapon(weapon_num, weapon_cd, descr) values (6, 'lg', 'Lightning Gun');
insert into cd_weapon(weapon_num, weapon_cd, descr) values (7, 'rg', 'Railgun');
insert into cd_weapon(weapon_num, weapon_cd, descr) values (8, 'pg', 'Plasma Gun');
insert into cd_weapon(weapon_num, weapon_cd, descr) values (9, 'hmg', 'Heavy Machinegun');
insert into cd_weapon(weapon_num, weapon_cd, descr) values (10, 'bfg', 'BFG');
insert into cd_weapon(weapon_num, weapon_cd, descr) values (11, 'cg', 'Chain Gun');
insert into cd_weapon(weapon_num, weapon_cd, descr) values (12, 'ng', 'Nail Gun');
insert into cd_weapon(weapon_num, weapon_cd, descr) values (13, 'pm', 'Prox Mine');
insert into cd_weapon(weapon_num, weapon_cd, descr) values (14, 'gh', 'Grappling Hook');

update cd_game_type set game_type_cd='ffa', descr='Free For All' where game_type_cd='dm';
update cd_game_type set game_type_cd='race', descr='Race' where game_type_cd='rc';
delete from cd_game_type where game_type_cd not in ('ffa', 'duel','tdm','ctf','ca','ft','dom', 'race');

alter table player_elos 
  add column g2_games int not null default 0, 
  add column g2_r float not null default 1500, 
  add column g2_rd float not null default 300, 
  add column g2_vol float not null default 0.06,
  add column g2_dt int;

alter table player_game_stats
  add column g2_score int, 
  add column g2_delta_r float, 
  add column g2_delta_rd float;

alter table games 
  add column g2_status smallint not null default 0;
  
alter table games
  add column score1 smallint,
  add column score2 smallint;

create index games_start_dt on games(start_dt);

alter table servers
  add column region smallint,
  add column country char(2),
  add column state char(5),
  add column latitude decimal(7,4),
  add column longitude decimal(7,4);



alter table player_ranks
  add column g2_r smallint,
  add column g2_rd smallint,
  add column g2_games int,
  add column region smallint;

alter table player_ranks_history
  add column g2_r smallint,
  add column g2_rd smallint,
  add column g2_games int,
  add column region smallint;

alter table players
  add column region smallint;

alter table games
  add column rounds smallint;

-- 2016-01-06 02:00 CET

alter table player_elos 
  alter column g2_r drop default, 
  alter column g2_rd drop default, 
  alter column g2_dt drop default, 
  alter column g2_games drop default;

alter table player_elos
  add column b_games int,
  add column b_r float,
  add column b_rd float,
  add column b_dt int;


-- 2016-01-07 18:00 CET

alter table player_game_stats
  add column g2_old_r float,
  add column g2_old_rd float;

-- 2016-01-08 13:40 CET

insert into cd_game_type (game_type_cd,descr,active_ind) values ('ad','Attack & Defend', true);
alter table player_elos 
  alter column g2_r drop not null,
  alter column g2_rd drop not null,
  alter column g2_vol drop not null,
  alter column g2_dt drop not null,
  alter column g2_games drop not null;


insert into cd_game_type (game_type_cd,descr,active_ind) values ('1fctf', '1-flag CTF', true);
insert into cd_game_type (game_type_cd,descr,active_ind) values ('rr', 'Red Rover', true);
insert into cd_game_type (game_type_cd,descr,active_ind) values ('harvester', 'Harvester', true);


-- 2016-01-26

CREATE INDEX games_2014q1_ix001 on games_2014q1(create_dt);
CREATE INDEX games_2014q1_ix002 on games_2014q1 using gin(players);
CREATE UNIQUE INDEX games_2014q1_pk on games_2014q1(game_id);
ALTER TABLE games_2014q1 ADD PRIMARY KEY USING INDEX games_2014q1_pk;
CREATE INDEX games_2014q2_ix001 on games_2014q2(create_dt);
CREATE INDEX games_2014q2_ix002 on games_2014q2 using gin(players);
CREATE UNIQUE INDEX games_2014q2_pk on games_2014q2(game_id);
ALTER TABLE games_2014q2 ADD PRIMARY KEY USING INDEX games_2014q2_pk;
CREATE INDEX games_2014q3_ix001 on games_2014q3(create_dt);
CREATE INDEX games_2014q3_ix002 on games_2014q3 using gin(players);
CREATE UNIQUE INDEX games_2014q3_pk on games_2014q3(game_id);
ALTER TABLE games_2014q3 ADD PRIMARY KEY USING INDEX games_2014q3_pk;
CREATE INDEX games_2014q4_ix001 on games_2014q4(create_dt);
CREATE INDEX games_2014q4_ix002 on games_2014q4 using gin(players);
CREATE UNIQUE INDEX games_2014q4_pk on games_2014q4(game_id);
ALTER TABLE games_2014q4 ADD PRIMARY KEY USING INDEX games_2014q4_pk;
CREATE INDEX games_2015q1_ix001 on games_2015q1(create_dt);
CREATE INDEX games_2015q1_ix002 on games_2015q1 using gin(players);
CREATE UNIQUE INDEX games_2015q1_pk on games_2015q1(game_id);
ALTER TABLE games_2015q1 ADD PRIMARY KEY USING INDEX games_2015q1_pk;
CREATE INDEX games_2015q2_ix001 on games_2015q2(create_dt);
CREATE INDEX games_2015q2_ix002 on games_2015q2 using gin(players);
CREATE UNIQUE INDEX games_2015q2_pk on games_2015q2(game_id);
ALTER TABLE games_2015q2 ADD PRIMARY KEY USING INDEX games_2015q2_pk;
CREATE INDEX games_2015q3_ix001 on games_2015q3(create_dt);
CREATE INDEX games_2015q3_ix002 on games_2015q3 using gin(players);
CREATE UNIQUE INDEX games_2015q3_pk on games_2015q3(game_id);
ALTER TABLE games_2015q3 ADD PRIMARY KEY USING INDEX games_2015q3_pk;
CREATE INDEX games_2015q4_ix001 on games_2015q4(create_dt);
CREATE INDEX games_2015q4_ix002 on games_2015q4 using gin(players);
CREATE UNIQUE INDEX games_2015q4_pk on games_2015q4(game_id);
ALTER TABLE games_2015q4 ADD PRIMARY KEY USING INDEX games_2015q4_pk;
CREATE INDEX games_2016q1_ix001 on games_2016q1(create_dt);
CREATE INDEX games_2016q1_ix002 on games_2016q1 using gin(players);
CREATE UNIQUE INDEX games_2016q1_pk on games_2016q1(game_id);
ALTER TABLE games_2016q1 ADD PRIMARY KEY USING INDEX games_2016q1_pk;
CREATE INDEX games_2016q2_ix001 on games_2016q2(create_dt);
CREATE INDEX games_2016q2_ix002 on games_2016q2 using gin(players);
CREATE UNIQUE INDEX games_2016q2_pk on games_2016q2(game_id);
ALTER TABLE games_2016q2 ADD PRIMARY KEY USING INDEX games_2016q2_pk;
CREATE INDEX games_2016q3_ix001 on games_2016q3(create_dt);
CREATE INDEX games_2016q3_ix002 on games_2016q3 using gin(players);
CREATE UNIQUE INDEX games_2016q3_pk on games_2016q3(game_id);
ALTER TABLE games_2016q3 ADD PRIMARY KEY USING INDEX games_2016q3_pk;
CREATE INDEX games_2016q4_ix001 on games_2016q4(create_dt);
CREATE INDEX games_2016q4_ix002 on games_2016q4 using gin(players);
CREATE UNIQUE INDEX games_2016q4_pk on games_2016q4(game_id);
ALTER TABLE games_2016q4 ADD PRIMARY KEY USING INDEX games_2016q4_pk;
CREATE INDEX games_2017q1_ix001 on games_2017q1(create_dt);
CREATE INDEX games_2017q1_ix002 on games_2017q1 using gin(players);
CREATE UNIQUE INDEX games_2017q1_pk on games_2017q1(game_id);
ALTER TABLE games_2017q1 ADD PRIMARY KEY USING INDEX games_2017q1_pk;
CREATE INDEX games_2017q2_ix001 on games_2017q2(create_dt);
CREATE INDEX games_2017q2_ix002 on games_2017q2 using gin(players);
CREATE UNIQUE INDEX games_2017q2_pk on games_2017q2(game_id);
ALTER TABLE games_2017q2 ADD PRIMARY KEY USING INDEX games_2017q2_pk;
CREATE INDEX games_2017q3_ix001 on games_2017q3(create_dt);
CREATE INDEX games_2017q3_ix002 on games_2017q3 using gin(players);
CREATE UNIQUE INDEX games_2017q3_pk on games_2017q3(game_id);
ALTER TABLE games_2017q3 ADD PRIMARY KEY USING INDEX games_2017q3_pk;
CREATE INDEX games_2017q4_ix001 on games_2017q4(create_dt);
CREATE INDEX games_2017q4_ix002 on games_2017q4 using gin(players);
CREATE UNIQUE INDEX games_2017q4_pk on games_2017q4(game_id);
ALTER TABLE games_2017q4 ADD PRIMARY KEY USING INDEX games_2017q4_pk;
CREATE INDEX games_2018q1_ix001 on games_2018q1(create_dt);
CREATE INDEX games_2018q1_ix002 on games_2018q1 using gin(players);
CREATE UNIQUE INDEX games_2018q1_pk on games_2018q1(game_id);
ALTER TABLE games_2018q1 ADD PRIMARY KEY USING INDEX games_2018q1_pk;
CREATE INDEX games_2018q2_ix001 on games_2018q2(create_dt);
CREATE INDEX games_2018q2_ix002 on games_2018q2 using gin(players);
CREATE UNIQUE INDEX games_2018q2_pk on games_2018q2(game_id);
ALTER TABLE games_2018q2 ADD PRIMARY KEY USING INDEX games_2018q2_pk;
CREATE INDEX games_2018q3_ix001 on games_2018q3(create_dt);
CREATE INDEX games_2018q3_ix002 on games_2018q3 using gin(players);
CREATE UNIQUE INDEX games_2018q3_pk on games_2018q3(game_id);
ALTER TABLE games_2018q3 ADD PRIMARY KEY USING INDEX games_2018q3_pk;
CREATE INDEX games_2018q4_ix001 on games_2018q4(create_dt);
CREATE INDEX games_2018q4_ix002 on games_2018q4 using gin(players);
CREATE UNIQUE INDEX games_2018q4_pk on games_2018q4(game_id);
ALTER TABLE games_2018q4 ADD PRIMARY KEY USING INDEX games_2018q4_pk;
CREATE INDEX games_2019q1_ix001 on games_2019q1(create_dt);
CREATE INDEX games_2019q1_ix002 on games_2019q1 using gin(players);
CREATE UNIQUE INDEX games_2019q1_pk on games_2019q1(game_id);
ALTER TABLE games_2019q1 ADD PRIMARY KEY USING INDEX games_2019q1_pk;
CREATE INDEX games_2019q2_ix001 on games_2019q2(create_dt);
CREATE INDEX games_2019q2_ix002 on games_2019q2 using gin(players);
CREATE UNIQUE INDEX games_2019q2_pk on games_2019q2(game_id);
ALTER TABLE games_2019q2 ADD PRIMARY KEY USING INDEX games_2019q2_pk;
CREATE INDEX games_2019q3_ix001 on games_2019q3(create_dt);
CREATE INDEX games_2019q3_ix002 on games_2019q3 using gin(players);
CREATE UNIQUE INDEX games_2019q3_pk on games_2019q3(game_id);
ALTER TABLE games_2019q3 ADD PRIMARY KEY USING INDEX games_2019q3_pk;
CREATE INDEX games_2019q4_ix001 on games_2019q4(create_dt);
CREATE INDEX games_2019q4_ix002 on games_2019q4 using gin(players);
CREATE UNIQUE INDEX games_2019q4_pk on games_2019q4(game_id);
ALTER TABLE games_2019q4 ADD PRIMARY KEY USING INDEX games_2019q4_pk;
CREATE INDEX games_2020q1_ix001 on games_2020q1(create_dt);
CREATE INDEX games_2020q1_ix002 on games_2020q1 using gin(players);
CREATE UNIQUE INDEX games_2020q1_pk on games_2020q1(game_id);
ALTER TABLE games_2020q1 ADD PRIMARY KEY USING INDEX games_2020q1_pk;
CREATE INDEX games_2020q2_ix001 on games_2020q2(create_dt);
CREATE INDEX games_2020q2_ix002 on games_2020q2 using gin(players);
CREATE UNIQUE INDEX games_2020q2_pk on games_2020q2(game_id);
ALTER TABLE games_2020q2 ADD PRIMARY KEY USING INDEX games_2020q2_pk;
CREATE INDEX games_2020q3_ix001 on games_2020q3(create_dt);
CREATE INDEX games_2020q3_ix002 on games_2020q3 using gin(players);
CREATE UNIQUE INDEX games_2020q3_pk on games_2020q3(game_id);
ALTER TABLE games_2020q3 ADD PRIMARY KEY USING INDEX games_2020q3_pk;
CREATE INDEX games_2020q4_ix001 on games_2020q4(create_dt);
CREATE INDEX games_2020q4_ix002 on games_2020q4 using gin(players);
CREATE UNIQUE INDEX games_2020q4_pk on games_2020q4(game_id);
ALTER TABLE games_2020q4 ADD PRIMARY KEY USING INDEX games_2021q4_pk;



update games set create_dt=start_dt where create_dt<start_dt and game_id not in (112090, 112094,112093,112089);

/*
alter table games rename to rgames;
select * into games from rgames;
alter table games add primary key (game_id);
create unique index on games(match_id,server_id);
create index on games(start_dt);

alter table games add foreign key (game_type_cd) references cd_game_type(game_type_cd);
alter table games add foreign key (server_id) references servers(server_id);
alter table games add foreign key (map_id) references maps(map_id);

alter table player_game_stats drop constraint player_game_stats_fk002;
alter table player_game_stats add foreign key (game_id) references games(game_id);
alter table player_weapon_stats drop constraint player_weapon_stats_fk002;
alter table player_weapon_stats add foreign key (game_id) references games(game_id);
alter table team_game_stats drop constraint team_game_stats_fk001;
alter table team_game_stats add foreign key (game_id) references games(game_id);
*/


-- 2016-02-09

alter table games
  add column player_id1 integer references players(player_id),
  add column player_id2 integer references players(player_id);

update games g
  set player_id1=pg1.player_id, score1=(case when pg1.score<1000 then pg1.score else 999 end), player_id2=pg2.player_id, score2=(case when pg2.score<1000 then pg2.score else 999 end)
  from player_game_stats pg1, player_game_stats pg2
  where pg1.game_id=g.game_id and pg1.scoreboardpos=1
  and pg2.game_id=g.game_id and pg2.scoreboardpos<>1
  and g.game_type_cd='duel';

update games g
  set player_id1=pg1.player_id, score1=(case when pg1.score<1000 then pg1.score else 999 end), player_id2=pg2.player_id, score2=(case when pg2.score<1000 then pg2.score else 999 end)
  from player_game_stats pg1, player_game_stats pg2
  where pg1.game_id=g.game_id and pg1.scoreboardpos=1
  and pg2.game_id=g.game_id and pg2.scoreboardpos=2
  and g.game_type_cd in ('ffa', 'race', 'rr');

update games g
  set player_id1=(select player_id from player_game_stats pg where pg.game_id=g.game_id and team=1 and scoreboardpos>=0 order by scoreboardpos limit 1)
  where g.game_type_cd not in ('duel', 'ffa', 'race', 'rr');
update games g
  set player_id2=(select player_id from player_game_stats pg where pg.game_id=g.game_id and team=2 and scoreboardpos>=0 order by scoreboardpos limit 1)
  where g.game_type_cd not in ('duel', 'ffa', 'race', 'rr');


-- 2016-08-13

alter table players add privacy_match_hist smallint not null default 0;


-- 2018-05-11

-- insert players -1 to -64 which will be used as placeholders for deleted players
do
$$
declare
  i integer;
begin
  for i in 1 .. 64 loop
    insert into players (player_id, nick, stripped_nick) values (-i, 'Unnamed ' || i, 'Unnamed ' || i);
  end loop;
end;
$$ language plpgsql;

-- 2018-05-14
alter table players add privacy_nowplaying boolean not null default false;
alter table hashkeys add delete_dt timestamp without time zone;

-- 2018-05-16
alter table player_nicks add last_used_dt timestamp without time zone default timezone('UTC',now());
drop function if exists getOrUpdatePlayer(steamid varchar(30), rawNick varchar(64), strippedNick varchar(64));
-- stored_proc.sql was updated with a getOrCreatePlayer function

-- 2018-05-24
-- stored_proc.sql was updated with a new getOrCreatePlayer function

-- 2018-05-26
-- before this index could be generated, duplicates had to be eliminated
create unique index games_2018q1_match_id on games_2018q1(match_id);
create unique index games_2018q2_match_id on games_2018q2(match_id);
create unique index games_2018q3_match_id on games_2018q3(match_id);
create unique index games_2018q4_match_id on games_2018q4(match_id);
create unique index games_2019q1_match_id on games_2019q1(match_id);
create unique index games_2019q2_match_id on games_2019q2(match_id);
create unique index games_2019q3_match_id on games_2019q3(match_id);
create unique index games_2019q4_match_id on games_2019q4(match_id);
create unique index games_2020q1_match_id on games_2020q1(match_id);
create unique index games_2020q2_match_id on games_2020q2(match_id);
create unique index games_2020q3_match_id on games_2020q3(match_id);
create unique index games_2020q4_match_id on games_2020q4(match_id);
-- before this index could be generated, duplicates had to be eliminated
create unique index maps_name on maps(name);
-- stored_proc.sql getOrCreateServer() updated

--2018-05-28
alter table hashkeys add sessionkey varchar(80); -- steam auth session cookie
create unique index hashkeys_sessionkey on hashkeys(sessionkey);

--2021-05-30
CREATE TABLE IF NOT EXISTS xonstat.games_2020q1 ( 
	CHECK ( create_dt >= DATE '2021-01-01' AND create_dt < DATE '2021-04-01' ) 
) INHERITS (games);

CREATE TABLE IF NOT EXISTS xonstat.games_2020q2 ( 
	CHECK ( create_dt >= DATE '2021-04-01' AND create_dt < DATE '2021-07-01' ) 
) INHERITS (games);

CREATE TABLE IF NOT EXISTS xonstat.games_2020q3 ( 
	CHECK ( create_dt >= DATE '2021-07-01' AND create_dt < DATE '2021-10-01' ) 
) INHERITS (games);

CREATE TABLE IF NOT EXISTS xonstat.games_2020q4 ( 
	CHECK ( create_dt >= DATE '2021-10-01' AND create_dt < DATE '2022-01-01' ) 
) INHERITS (games);


CREATE TABLE IF NOT EXISTS xonstat.games_2020q1 ( 
	CHECK ( create_dt >= DATE '2022-01-01' AND create_dt < DATE '2022-04-01' ) 
) INHERITS (games);

CREATE TABLE IF NOT EXISTS xonstat.games_2020q2 ( 
	CHECK ( create_dt >= DATE '2022-04-01' AND create_dt < DATE '2022-07-01' ) 
) INHERITS (games);

CREATE TABLE IF NOT EXISTS xonstat.games_2020q3 ( 
	CHECK ( create_dt >= DATE '2022-07-01' AND create_dt < DATE '2022-10-01' ) 
) INHERITS (games);

CREATE TABLE IF NOT EXISTS xonstat.games_2020q4 ( 
	CHECK ( create_dt >= DATE '2022-10-01' AND create_dt < DATE '2023-01-01' ) 
) INHERITS (games);


CREATE TABLE IF NOT EXISTS xonstat.games_2020q1 ( 
	CHECK ( create_dt >= DATE '2023-01-01' AND create_dt < DATE '2023-04-01' ) 
) INHERITS (games);

CREATE TABLE IF NOT EXISTS xonstat.games_2020q2 ( 
	CHECK ( create_dt >= DATE '2023-04-01' AND create_dt < DATE '2023-07-01' ) 
) INHERITS (games);

CREATE TABLE IF NOT EXISTS xonstat.games_2020q3 ( 
	CHECK ( create_dt >= DATE '2023-07-01' AND create_dt < DATE '2023-10-01' ) 
) INHERITS (games);

CREATE TABLE IF NOT EXISTS xonstat.games_2020q4 ( 
	CHECK ( create_dt >= DATE '2023-10-01' AND create_dt < DATE '2024-01-01' ) 
) INHERITS (games);


CREATE TABLE IF NOT EXISTS xonstat.games_2020q1 ( 
	CHECK ( create_dt >= DATE '2024-01-01' AND create_dt < DATE '2024-04-01' ) 
) INHERITS (games);

CREATE TABLE IF NOT EXISTS xonstat.games_2020q2 ( 
	CHECK ( create_dt >= DATE '2024-04-01' AND create_dt < DATE '2024-07-01' ) 
) INHERITS (games);

CREATE TABLE IF NOT EXISTS xonstat.games_2020q3 ( 
	CHECK ( create_dt >= DATE '2024-07-01' AND create_dt < DATE '2024-10-01' ) 
) INHERITS (games);

CREATE TABLE IF NOT EXISTS xonstat.games_2020q4 ( 
	CHECK ( create_dt >= DATE '2024-10-01' AND create_dt < DATE '2025-01-01' ) 
) INHERITS (games);


CREATE TABLE IF NOT EXISTS xonstat.games_2020q1 ( 
	CHECK ( create_dt >= DATE '2025-01-01' AND create_dt < DATE '2025-04-01' ) 
) INHERITS (games);

CREATE TABLE IF NOT EXISTS xonstat.games_2020q2 ( 
	CHECK ( create_dt >= DATE '2025-04-01' AND create_dt < DATE '2025-07-01' ) 
) INHERITS (games);

CREATE TABLE IF NOT EXISTS xonstat.games_2020q3 ( 
	CHECK ( create_dt >= DATE '2025-07-01' AND create_dt < DATE '2025-10-01' ) 
) INHERITS (games);

CREATE TABLE IF NOT EXISTS xonstat.games_2020q4 ( 
	CHECK ( create_dt >= DATE '2025-10-01' AND create_dt < DATE '2026-01-01' ) 
) INHERITS (games);

create unique index games_2021q1_match_id on games_2021q1(match_id);
create unique index games_2021q2_match_id on games_2021q2(match_id);
create unique index games_2021q3_match_id on games_2021q3(match_id);
create unique index games_2021q4_match_id on games_2021q4(match_id);
create unique index games_2022q1_match_id on games_2022q1(match_id);
create unique index games_2022q2_match_id on games_2022q2(match_id);
create unique index games_2022q3_match_id on games_2022q3(match_id);
create unique index games_2022q4_match_id on games_2022q4(match_id);
create unique index games_2023q1_match_id on games_2023q1(match_id);
create unique index games_2023q2_match_id on games_2023q2(match_id);
create unique index games_2023q3_match_id on games_2023q3(match_id);
create unique index games_2023q4_match_id on games_2023q4(match_id);
create unique index games_2024q1_match_id on games_2024q1(match_id);
create unique index games_2024q2_match_id on games_2024q2(match_id);
create unique index games_2024q3_match_id on games_2024q3(match_id);
create unique index games_2024q4_match_id on games_2024q4(match_id);
create unique index games_2025q1_match_id on games_2025q1(match_id);
create unique index games_2025q2_match_id on games_2025q2(match_id);
create unique index games_2025q3_match_id on games_2025q3(match_id);
create unique index games_2025q4_match_id on games_2025q4(match_id);

CREATE INDEX games_2021q4_ix001 on games_2021q4(create_dt);
CREATE INDEX games_2021q4_ix002 on games_2021q4 using gin(players);
CREATE UNIQUE INDEX games_2021q4_pk on games_2021q4(game_id);
ALTER TABLE games_2021q4 ADD PRIMARY KEY USING INDEX games_2021q4_pk;

CREATE INDEX games_2022q4_ix001 on games_2022q4(create_dt);
CREATE INDEX games_2022q4_ix002 on games_2022q4 using gin(players);
CREATE UNIQUE INDEX games_2022q4_pk on games_2022q4(game_id);
ALTER TABLE games_2022q4 ADD PRIMARY KEY USING INDEX games_2022q4_pk;

CREATE INDEX games_2023q4_ix001 on games_2023q4(create_dt);
CREATE INDEX games_2023q4_ix002 on games_2023q4 using gin(players);
CREATE UNIQUE INDEX games_2023q4_pk on games_2023q4(game_id);
ALTER TABLE games_2023q4 ADD PRIMARY KEY USING INDEX games_2023q4_pk;

CREATE INDEX games_2024q4_ix001 on games_2024q4(create_dt);
CREATE INDEX games_2024q4_ix002 on games_2024q4 using gin(players);
CREATE UNIQUE INDEX games_2024q4_pk on games_2024q4(game_id);
ALTER TABLE games_2024q4 ADD PRIMARY KEY USING INDEX games_2024q4_pk;

CREATE INDEX games_2025q4_ix001 on games_2025q4(create_dt);
CREATE INDEX games_2025q4_ix002 on games_2025q4 using gin(players);
CREATE UNIQUE INDEX games_2025q4_pk on games_2025q4(game_id);
ALTER TABLE games_2025q4 ADD PRIMARY KEY USING INDEX games_2025q4_pk;