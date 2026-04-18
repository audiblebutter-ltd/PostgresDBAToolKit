-- Long Running Queries (pg_stat_activity)
-- pid                  Process ID — use this to cancel or terminate
-- usename              Database user running the query
-- application_name     Reporting application name from the connection string
-- client_addr          Source IP — helps trace back to the application server
-- state                active = running now; idle in transaction = open transaction, not executing
-- wait_event_type      Category of what the session is waiting on — Lock, IO, Client, etc.
-- wait_event           Specific wait — e.g. relation, DataFileRead, ClientRead
-- duration             How long this query or state has been running
-- query                The SQL text (may be truncated at track_activity_query_size characters)
SELECT
    pid,
    usename,
    application_name,
    client_addr,
    state,
    wait_event_type,
    wait_event,
    now() - query_start   AS duration,
    query
FROM pg_stat_activity
WHERE state != 'idle'
  AND query_start IS NOT NULL
ORDER BY duration DESC;
