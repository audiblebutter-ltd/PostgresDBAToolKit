-- Enables logging of any lock wait that exceeds deadlock_timeout
ALTER SYSTEM SET log_lock_waits = on;

-- Time before a lock wait is checked for deadlock (and logged if log_lock_waits = on)
ALTER SYSTEM SET deadlock_timeout = '1s';

-- Reload config without restarting the server
SELECT pg_reload_conf();
