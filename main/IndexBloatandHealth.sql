-- Index Usage Stats (pg_stat_user_indexes)
-- schemaname / tablename    Where the index lives
-- indexname                 Index name
-- idx_scan                  Number of index scans since last stats reset
-- idx_tup_read              Tuples read through this index
-- idx_tup_fetch             Heap fetches triggered by this index
-- index_size                Disk space used
SELECT
    schemaname,
    tablename,
    indexname,
    idx_scan,
    idx_tup_read,
    idx_tup_fetch,
    pg_size_pretty(pg_relation_size(indexrelid)) AS index_size
FROM pg_stat_user_indexes
ORDER BY idx_scan ASC, pg_relation_size(indexrelid) DESC;


-- Bloat Estimate (pgstattuple extension required)
-- real_size      Actual disk size of the index
-- extra_size     Estimated bloat — space that could be reclaimed
-- bloat_ratio    Percentage of the index that is dead space
-- is_na          true if the estimate is not available for this index type
SELECT
    schemaname,
    tablename,
    indexname,
    pg_size_pretty(pg_relation_size(indexrelid))                              AS real_size,
    pg_size_pretty(
        pg_relation_size(indexrelid) - pg_relation_size(indexrelid) / 1
    )                                                                         AS extra_size,
    ROUND(
        100 - (100 * pgstatindex(indexrelid::text).leaf_fragmentation / 100)::numeric,
    2)                                                                        AS bloat_ratio,
    pgstatindex(indexrelid::text).leaf_fragmentation IS NULL                  AS is_na
FROM pg_stat_user_indexes
ORDER BY bloat_ratio DESC NULLS LAST;
