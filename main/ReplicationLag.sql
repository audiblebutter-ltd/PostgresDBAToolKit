-- pg_stat_replication (run on primary)
-- client_addr        IP address of the standby server
-- usename            Replication user
-- application_name   Standby name — set in recovery.conf or postgresql.conf on the replica
-- state              streaming = healthy; catchup = recovering; backup = base backup in progress
-- sent_lsn           WAL position sent to this standby
-- write_lsn          WAL position written to standby disk
-- flush_lsn          WAL position flushed (durable) on standby
-- replay_lsn         WAL position applied to standby data files
-- write_lag          Time from primary WAL write to standby write
-- flush_lag          Time from primary WAL write to standby flush
-- replay_lag         Time from primary WAL write to standby replay — the real replication lag
-- sync_state         async, sync, quorum — whether this standby participates in synchronous commit
-- sent_lag_bytes     Bytes of WAL not yet sent to standby
-- replay_lag_bytes   Bytes of WAL sent but not yet replayed
SELECT
    client_addr,
    usename,
    application_name,
    state,
    sent_lsn,
    write_lsn,
    flush_lsn,
    replay_lsn,
    write_lag,
    flush_lag,
    replay_lag,
    sync_state,
    sent_lsn  - replay_lsn   AS sent_lag_bytes,
    write_lsn - replay_lsn   AS replay_lag_bytes
FROM pg_stat_replication
ORDER BY replay_lag DESC NULLS LAST;
