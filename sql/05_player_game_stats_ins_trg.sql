CREATE OR REPLACE FUNCTION player_game_stats_ins()
RETURNS TRIGGER AS $$
BEGIN
	IF (NEW.create_dt >= DATE '2014-01-01' AND NEW.create_dt < DATE '2014-04-01') THEN
		INSERT INTO player_game_stats_2014Q1 VALUES (NEW.*);
	ELSIF (NEW.create_dt >= DATE '2014-04-01' AND NEW.create_dt < DATE '2014-07-01') THEN
		INSERT INTO player_game_stats_2014Q2 VALUES (NEW.*);
	ELSIF (NEW.create_dt >= DATE '2014-07-01' AND NEW.create_dt < DATE '2014-10-01') THEN
		INSERT INTO player_game_stats_2014Q3 VALUES (NEW.*);
	ELSIF (NEW.create_dt >= DATE '2014-10-01' AND NEW.create_dt < DATE '2015-01-01') THEN
		INSERT INTO player_game_stats_2014Q4 VALUES (NEW.*);
	ELSIF (NEW.create_dt >= DATE '2015-01-01' AND NEW.create_dt < DATE '2015-04-01') THEN
		INSERT INTO player_game_stats_2015Q1 VALUES (NEW.*);
	ELSIF (NEW.create_dt >= DATE '2015-04-01' AND NEW.create_dt < DATE '2015-07-01') THEN
		INSERT INTO player_game_stats_2015Q2 VALUES (NEW.*);
	ELSIF (NEW.create_dt >= DATE '2015-07-01' AND NEW.create_dt < DATE '2015-10-01') THEN
		INSERT INTO player_game_stats_2015Q3 VALUES (NEW.*);
	ELSIF (NEW.create_dt >= DATE '2015-10-01' AND NEW.create_dt < DATE '2016-01-01') THEN
		INSERT INTO player_game_stats_2015Q4 VALUES (NEW.*);
	ELSIF (NEW.create_dt >= DATE '2016-01-01' AND NEW.create_dt < DATE '2016-04-01') THEN
		INSERT INTO player_game_stats_2016Q1 VALUES (NEW.*);
	ELSIF (NEW.create_dt >= DATE '2016-04-01' AND NEW.create_dt < DATE '2016-07-01') THEN
		INSERT INTO player_game_stats_2016Q2 VALUES (NEW.*);
	ELSIF (NEW.create_dt >= DATE '2016-07-01' AND NEW.create_dt < DATE '2016-10-01') THEN
		INSERT INTO player_game_stats_2016Q3 VALUES (NEW.*);
	ELSIF (NEW.create_dt >= DATE '2016-10-01' AND NEW.create_dt < DATE '2017-01-01') THEN
		INSERT INTO player_game_stats_2016Q4 VALUES (NEW.*);
	ELSIF (NEW.create_dt >= DATE '2017-01-01' AND NEW.create_dt < DATE '2017-04-01') THEN
		INSERT INTO player_game_stats_2017Q1 VALUES (NEW.*);
	ELSIF (NEW.create_dt >= DATE '2017-04-01' AND NEW.create_dt < DATE '2017-07-01') THEN
		INSERT INTO player_game_stats_2017Q2 VALUES (NEW.*);
	ELSIF (NEW.create_dt >= DATE '2017-07-01' AND NEW.create_dt < DATE '2017-10-01') THEN
		INSERT INTO player_game_stats_2017Q3 VALUES (NEW.*);
	ELSIF (NEW.create_dt >= DATE '2017-10-01' AND NEW.create_dt < DATE '2018-01-01') THEN
		INSERT INTO player_game_stats_2017Q4 VALUES (NEW.*);
	ELSIF (NEW.create_dt >= DATE '2018-01-01' AND NEW.create_dt < DATE '2018-04-01') THEN
		INSERT INTO player_game_stats_2018Q1 VALUES (NEW.*);
	ELSIF (NEW.create_dt >= DATE '2018-04-01' AND NEW.create_dt < DATE '2018-07-01') THEN
		INSERT INTO player_game_stats_2018Q2 VALUES (NEW.*);
	ELSIF (NEW.create_dt >= DATE '2018-07-01' AND NEW.create_dt < DATE '2018-10-01') THEN
		INSERT INTO player_game_stats_2018Q3 VALUES (NEW.*);
	ELSIF (NEW.create_dt >= DATE '2018-10-01' AND NEW.create_dt < DATE '2019-01-01') THEN
		INSERT INTO player_game_stats_2018Q4 VALUES (NEW.*);
	ELSIF (NEW.create_dt >= DATE '2019-01-01' AND NEW.create_dt < DATE '2019-04-01') THEN
		INSERT INTO player_game_stats_2019Q1 VALUES (NEW.*);
	ELSIF (NEW.create_dt >= DATE '2019-04-01' AND NEW.create_dt < DATE '2019-07-01') THEN
		INSERT INTO player_game_stats_2019Q2 VALUES (NEW.*);
	ELSIF (NEW.create_dt >= DATE '2019-07-01' AND NEW.create_dt < DATE '2019-10-01') THEN
		INSERT INTO player_game_stats_2019Q3 VALUES (NEW.*);
	ELSIF (NEW.create_dt >= DATE '2019-10-01' AND NEW.create_dt < DATE '2020-01-01') THEN
		INSERT INTO player_game_stats_2019Q4 VALUES (NEW.*);
	ELSIF (NEW.create_dt >= DATE '2020-01-01' AND NEW.create_dt < DATE '2020-04-01') THEN
		INSERT INTO player_game_stats_2020Q1 VALUES (NEW.*);
	ELSIF (NEW.create_dt >= DATE '2020-04-01' AND NEW.create_dt < DATE '2020-07-01') THEN
		INSERT INTO player_game_stats_2020Q2 VALUES (NEW.*);
	ELSIF (NEW.create_dt >= DATE '2020-07-01' AND NEW.create_dt < DATE '2020-10-01') THEN
		INSERT INTO player_game_stats_2020Q3 VALUES (NEW.*);
	ELSIF (NEW.create_dt >= DATE '2020-10-01' AND NEW.create_dt < DATE '2021-01-01') THEN
		INSERT INTO player_game_stats_2020Q4 VALUES (NEW.*);
	ELSIF (NEW.create_dt >= DATE '2021-01-01' AND NEW.create_dt < DATE '2021-04-01') THEN
		INSERT INTO games_2020Q1 VALUES (NEW.*);
	ELSIF (NEW.create_dt >= DATE '2021-04-01' AND NEW.create_dt < DATE '2021-07-01') THEN
		INSERT INTO games_2020Q2 VALUES (NEW.*);
	ELSIF (NEW.create_dt >= DATE '2021-07-01' AND NEW.create_dt < DATE '2021-10-01') THEN
		INSERT INTO games_2020Q3 VALUES (NEW.*);
	ELSIF (NEW.create_dt >= DATE '2021-10-01' AND NEW.create_dt < DATE '2022-01-01') THEN
		INSERT INTO games_2020Q4 VALUES (NEW.*);
	ELSIF (NEW.create_dt >= DATE '2022-01-01' AND NEW.create_dt < DATE '2022-04-01') THEN
		INSERT INTO games_2020Q1 VALUES (NEW.*);
	ELSIF (NEW.create_dt >= DATE '2022-04-01' AND NEW.create_dt < DATE '2022-07-01') THEN
		INSERT INTO games_2020Q2 VALUES (NEW.*);
	ELSIF (NEW.create_dt >= DATE '2022-07-01' AND NEW.create_dt < DATE '2022-10-01') THEN
		INSERT INTO games_2020Q3 VALUES (NEW.*);
	ELSIF (NEW.create_dt >= DATE '2022-10-01' AND NEW.create_dt < DATE '2023-01-01') THEN
		INSERT INTO games_2020Q4 VALUES (NEW.*);
	ELSIF (NEW.create_dt >= DATE '2023-01-01' AND NEW.create_dt < DATE '2023-04-01') THEN
		INSERT INTO games_2020Q1 VALUES (NEW.*);
	ELSIF (NEW.create_dt >= DATE '2023-04-01' AND NEW.create_dt < DATE '2023-07-01') THEN
		INSERT INTO games_2020Q2 VALUES (NEW.*);
	ELSIF (NEW.create_dt >= DATE '2023-07-01' AND NEW.create_dt < DATE '2023-10-01') THEN
		INSERT INTO games_2020Q3 VALUES (NEW.*);
	ELSIF (NEW.create_dt >= DATE '2023-10-01' AND NEW.create_dt < DATE '2024-01-01') THEN
		INSERT INTO games_2020Q4 VALUES (NEW.*);
	ELSIF (NEW.create_dt >= DATE '2024-01-01' AND NEW.create_dt < DATE '2024-04-01') THEN
		INSERT INTO games_2020Q1 VALUES (NEW.*);
	ELSIF (NEW.create_dt >= DATE '2024-04-01' AND NEW.create_dt < DATE '2024-07-01') THEN
		INSERT INTO games_2020Q2 VALUES (NEW.*);
	ELSIF (NEW.create_dt >= DATE '2024-07-01' AND NEW.create_dt < DATE '2024-10-01') THEN
		INSERT INTO games_2020Q3 VALUES (NEW.*);
	ELSIF (NEW.create_dt >= DATE '2024-10-01' AND NEW.create_dt < DATE '2025-01-01') THEN
		INSERT INTO games_2020Q4 VALUES (NEW.*);
	ELSIF (NEW.create_dt >= DATE '2025-01-01' AND NEW.create_dt < DATE '2025-04-01') THEN
		INSERT INTO games_2020Q1 VALUES (NEW.*);
	ELSIF (NEW.create_dt >= DATE '2025-04-01' AND NEW.create_dt < DATE '2025-07-01') THEN
		INSERT INTO games_2020Q2 VALUES (NEW.*);
	ELSIF (NEW.create_dt >= DATE '2025-07-01' AND NEW.create_dt < DATE '2025-10-01') THEN
		INSERT INTO games_2020Q3 VALUES (NEW.*);
	ELSIF (NEW.create_dt >= DATE '2025-10-01' AND NEW.create_dt < DATE '2026-01-01') THEN
		INSERT INTO games_2020Q4 VALUES (NEW.*);
	ELSE
		RAISE EXCEPTION 'Date out of range. Fix the player_game_stats_ins() trigger!';
	END IF;
	RETURN NULL;
END
$$
LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS player_game_stats_ins_trg ON xonstat.player_game_stats;
CREATE TRIGGER player_game_stats_ins_trg
    BEFORE INSERT on xonstat.player_game_stats
    FOR EACH ROW EXECUTE PROCEDURE player_game_stats_ins();
