SELECT (case state when 'idle' then state_change else now() end) - query_start as "runtime", usename, datname, waiting, state, query
  FROM  pg_stat_activity
  WHERE (case state when 'idle' then state_change else now() end) - query_start > '1 seconds'::interval
 ORDER BY runtime DESC;
