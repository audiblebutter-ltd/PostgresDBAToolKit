-- Reset all stats (do this after a major tuning change to get a clean baseline)
SELECT pg_stat_statements_reset();


-- Reset stats for a specific database only (PostgreSQL 12+)
SELECT pg_stat_statements_reset(0, oid, 0) FROM pg_database WHERE datname = 'mydb';
