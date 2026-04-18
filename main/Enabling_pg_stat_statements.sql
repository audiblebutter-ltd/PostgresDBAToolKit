-- Add to postgresql.conf (requires restart)
shared_preload_libraries = 'pg_stat_statements'


-- Then create the extension in your database
CREATE EXTENSION pg_stat_statements;
