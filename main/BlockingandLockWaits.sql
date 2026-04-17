SELECT
    blocking.pid                        AS blocking_pid,
    blocking.usename                    AS blocking_user,
    blocking.query                      AS blocking_query,
    blocked.pid                         AS blocked_pid,
    blocked.usename                     AS blocked_user,
    blocked.query                       AS blocked_query,
    now() - blocked.query_start         AS wait_duration,
    blocked_locks.locktype              AS lock_type
FROM pg_locks AS blocked_locks
JOIN pg_stat_activity AS blocked
    ON blocked.pid = blocked_locks.pid
JOIN pg_locks AS blocking_locks
    ON  blocking_locks.locktype         = blocked_locks.locktype
    AND blocking_locks.database         IS NOT DISTINCT FROM blocked_locks.database
    AND blocking_locks.relation         IS NOT DISTINCT FROM blocked_locks.relation
    AND blocking_locks.page             IS NOT DISTINCT FROM blocked_locks.page
    AND blocking_locks.tuple            IS NOT DISTINCT FROM blocked_locks.tuple
    AND blocking_locks.virtualxid       IS NOT DISTINCT FROM blocked_locks.virtualxid
    AND blocking_locks.transactionid    IS NOT DISTINCT FROM blocked_locks.transactionid
    AND blocking_locks.classid          IS NOT DISTINCT FROM blocked_locks.classid
    AND blocking_locks.objid            IS NOT DISTINCT FROM blocked_locks.objid
    AND blocking_locks.objsubid         IS NOT DISTINCT FROM blocked_locks.objsubid
    AND blocking_locks.pid             != blocked_locks.pid
JOIN pg_stat_activity AS blocking
    ON blocking.pid = blocking_locks.pid
WHERE NOT blocked_locks.granted;
