-- Vacuum and Bloat Stats (pg_stat_user_tables)
-- schemaname / relname    Table location
-- n_live_tup              Estimated live (visible) rows
-- n_dead_tup              Estimated dead rows not yet cleaned
-- dead_ratio              Dead tuples as a percentage of total — above 10-20% needs attention
-- last_vacuum             When a manual VACUUM last ran on this table
-- last_autovacuum         When autovacuum last ran
-- last_analyze            When statistics were last collected
-- last_autoanalyze        When autovacuum last collected statistics
-- vacuum_count            Total manual vacuum runs since stats reset
-- autovacuum_count        Total autovacuum runs since stats reset
SELECT
    schemaname,
    relname,
    n_live_tup,
    n_dead_tup,
    ROUND(
        100.0 * n_dead_tup / NULLIF(n_live_tup + n_dead_tup, 0),
    2)                  AS dead_ratio,
    last_vacuum,
    last_autovacuum,
    last_analyze,
    last_autoanalyze,
    vacuum_count,
    autovacuum_count
FROM pg_stat_user_tables
ORDER BY n_dead_tup DESC;


-- Transaction ID Wraparound Risk
-- relname            Table name
-- age                Age in transactions since the table was last frozen
-- max_age            The autovacuum_freeze_max_age threshold (default 200 million)
-- pct_to_emergency   How close this table is to forcing an emergency vacuum (%)
SELECT
    relname,
    age(relfrozenxid)                                                               AS age,
    current_setting('autovacuum_freeze_max_age')::bigint                            AS max_age,
    ROUND(
        100.0 * age(relfrozenxid) / current_setting('autovacuum_freeze_max_age')::bigint,
    2)                                                                              AS pct_to_emergency
FROM pg_class
WHERE relkind = 'r'
ORDER BY age(relfrozenxid) DESC;
