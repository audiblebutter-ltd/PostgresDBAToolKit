-- Create the history table (run once)
CREATE TABLE IF NOT EXISTS dba_size_history (
    snapshot_time   TIMESTAMPTZ     NOT NULL DEFAULT NOW(),
    datname         TEXT            NOT NULL,
    size_bytes      BIGINT          NOT NULL
);


-- Log a snapshot (run on a schedule)
INSERT INTO dba_size_history (snapshot_time, datname, size_bytes)
SELECT NOW(), datname, pg_database_size(datname)
FROM pg_database
WHERE datistemplate = false;


-- Compare snapshots to project growth
SELECT
    datname,
    snapshot_time,
    size_bytes,
    pg_size_pretty(size_bytes)                                                          AS size_pretty,
    size_bytes - LAG(size_bytes) OVER (PARTITION BY datname ORDER BY snapshot_time)    AS bytes_delta,
    pg_size_pretty(
        size_bytes - LAG(size_bytes) OVER (PARTITION BY datname ORDER BY snapshot_time)
    )                                                                                   AS growth_since_last,
    ROUND(
        (size_bytes - LAG(size_bytes) OVER (PARTITION BY datname ORDER BY snapshot_time))::numeric
        / NULLIF(LAG(size_bytes) OVER (PARTITION BY datname ORDER BY snapshot_time), 0) * 100, 2
    )                                                                                   AS growth_pct
FROM dba_size_history
ORDER BY datname, snapshot_time DESC;
