-- Database Summary
SELECT
    datname,
    pg_size_pretty(pg_database_size(datname))   AS pg_size_pretty,
    pg_database_size(datname)                   AS pg_database_size,
    numbackends
FROM pg_stat_database
ORDER BY pg_database_size(datname) DESC;


-- Top Tables by Size
SELECT
    schemaname,
    tablename,
    pg_size_pretty(pg_total_relation_size(schemaname || '.' || tablename))                          AS total_size,
    pg_size_pretty(pg_relation_size(schemaname || '.' || tablename))                                AS table_size,
    pg_size_pretty(pg_indexes_size(schemaname || '.' || tablename))                                 AS index_size,
    n_live_tup                                                                                      AS live_tuples,
    n_dead_tup                                                                                      AS dead_tuples,
    ROUND(n_dead_tup::numeric / NULLIF(n_live_tup + n_dead_tup, 0) * 100, 2)                       AS bloat_ratio
FROM pg_stat_user_tables
ORDER BY pg_total_relation_size(schemaname || '.' || tablename) DESC;


-- Top Indexes by Size
SELECT
    indexrelname                                                        AS indexname,
    pg_size_pretty(pg_relation_size(indexrelid))                       AS index_size,
    idx_scan
FROM pg_stat_user_indexes
ORDER BY pg_relation_size(indexrelid) DESC;
