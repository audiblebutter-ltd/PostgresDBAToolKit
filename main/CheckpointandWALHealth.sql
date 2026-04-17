-- Checkpoint Stats
SELECT
    checkpoints_timed,
    checkpoints_req,
    checkpoint_write_time,
    checkpoint_sync_time,
    buffers_checkpoint,
    buffers_clean,
    buffers_backend,
    maxwritten_clean
FROM pg_stat_bgwriter;


-- WAL Generation (PostgreSQL 14+)
SELECT
    wal_records,
    wal_bytes,
    wal_buffers_full
FROM pg_stat_wal;
