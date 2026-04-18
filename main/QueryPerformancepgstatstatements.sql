-- Query Performance (pg_stat_statements)
-- Requires pg_stat_statements extension — see Enabling_pg_stat_statements.sql
-- queryid          Internal hash identifying the normalised query
-- usename          Database user who ran the query
-- calls            Number of times the query has been executed
-- total_exec_time  Total execution time across all calls (ms)
-- mean_exec_time   Average execution time per call (ms)
-- min_exec_time    Fastest execution (ms)
-- max_exec_time    Slowest execution (ms) — spikes here indicate plan instability
-- rows             Total rows returned or affected across all calls
-- shared_blks_hit  Blocks served from shared buffer cache
-- shared_blks_read Blocks read from disk — high values indicate cache misses
-- temp_blks_read   Temp blocks read — sign of memory spill to disk
-- query            Normalised SQL text (literals replaced with $1, $2, etc.)
SELECT
    s.queryid,
    r.usename,
    s.calls,
    ROUND(s.total_exec_time::numeric, 2)            AS total_exec_time_ms,
    ROUND(s.mean_exec_time::numeric, 2)             AS mean_exec_time_ms,
    ROUND(s.min_exec_time::numeric, 2)              AS min_exec_time_ms,
    ROUND(s.max_exec_time::numeric, 2)              AS max_exec_time_ms,
    s.rows,
    s.shared_blks_hit,
    s.shared_blks_read,
    s.temp_blks_read,
    s.query
FROM pg_stat_statements AS s
JOIN pg_roles AS r ON r.oid = s.userid
ORDER BY s.total_exec_time DESC
LIMIT 25;
