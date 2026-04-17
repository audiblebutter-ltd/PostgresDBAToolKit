-- Ask the session to stop (graceful)

SELECT pg_cancel_backend(blocking_pid);


-- Force it to terminate (immediate)

SELECT pg_terminate_backend(blocking_pid);