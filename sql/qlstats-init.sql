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
insert into cd_weapon(weapon_num, weapon_cd, descr) values (11, 'ng', 'Nail Gun');
insert into cd_weapon(weapon_num, weapon_cd, descr) values (12, 'pm', 'Prox Mine');
insert into cd_weapon(weapon_num, weapon_cd, descr) values (13, 'cg', 'Chain Gun');
insert into cd_weapon(weapon_num, weapon_cd, descr) values (14, 'hmg', 'Heavy Machinegun');
insert into cd_weapon(weapon_num, weapon_cd, descr) values (19, 'bfg', 'BFG');

update cd_game_type set game_type_cd='ffa', descr='Free For All' where game_type_cd='dm';
update cd_game_type set game_type_cd='race', descr='Race' where game_type_cd='rc';
delete from cd_game_type where game_type_cd not in ('ffa', 'duel','tdm','ctf','ca','ft','dom', 'race');

