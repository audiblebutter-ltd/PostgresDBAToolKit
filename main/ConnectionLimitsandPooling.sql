-- Connection Summary
SELECT
    max_conn.setting::int                                               AS max_connections,
    COUNT(a.pid)                                                        AS used_connections,
    max_conn.setting::int - COUNT(a.pid)                               AS connections_remaining,
    reserved.setting::int                                               AS superuser_reserved,
    COUNT(a.pid) FILTER (WHERE a.state = 'active')                     AS active_connections,
    COUNT(a.pid) FILTER (WHERE a.state = 'idle')                       AS idle_connections,
    COUNT(a.pid) FILTER (WHERE a.state = 'idle in transaction')        AS idle_in_transaction
FROM pg_stat_activity AS a
CROSS JOIN pg_settings AS max_conn
CROSS JOIN pg_settings AS reserved
WHERE max_conn.name  = 'max_connections'
  AND reserved.name  = 'superuser_reserved_connections'
GROUP BY max_conn.setting, reserved.setting;


-- Per User / Application Breakdown
SELECT
    a.usename,
    a.application_name,
    a.state,
    COUNT(*)                                                            AS count,
    r.rolconnlimit                                                      AS max_conn_for_user
FROM pg_stat_activity AS a
JOIN pg_authid AS r
    ON r.rolname = a.usename
WHERE a.usename IS NOT NULL
GROUP BY a.usename, a.application_name, a.state, r.rolconnlimit
ORDER BY count DESC;
