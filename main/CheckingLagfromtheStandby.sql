-- On the standby: compare local replay position to known primary WAL position
SELECT
    pg_last_wal_receive_lsn()           AS received,
    pg_last_wal_replay_lsn()            AS replayed,
    pg_is_in_recovery()                 AS is_standby,
    now() - pg_last_xact_replay_timestamp() AS replay_delay;
