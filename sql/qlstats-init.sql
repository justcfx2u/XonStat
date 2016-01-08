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
