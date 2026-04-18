-- Deadlock Counts (pg_stat_database)
-- datname       Database name
-- deadlocks     Cumulative deadlock count since last pg_stat_reset()
-- conflicts     Query conflicts with recovery on standby replicas
-- temp_files    Temp files created — sign of memory pressure during sorts or hash joins
SELECT
    datname,
    deadlocks,
    conflicts,
    temp_files
FROM pg_stat_database
WHERE datname IS NOT NULL
ORDER BY deadlocks DESC;


-- Active Lock Contention (pg_locks + pg_stat_activity)
-- pid           Process ID of the waiting session
-- usename       Database user
-- query         The SQL being blocked
-- locktype      Type of lock requested — relation, tuple, transactionid, etc.
-- mode          Lock mode requested — e.g. RowExclusiveLock, ShareRowExclusiveLock
-- granted       false means this session is waiting
-- wait_event    What specifically the session is waiting on
SELECT
    a.pid,
    a.usename,
    a.query,
    l.locktype,
    l.mode,
    l.granted,
    a.wait_event
FROM pg_locks AS l
JOIN pg_stat_activity AS a ON a.pid = l.pid
WHERE NOT l.granted
ORDER BY a.query_start;
