-- Cancel the query but leave the session connected
SELECT pg_cancel_backend(pid);


-- Terminate the session entirely
SELECT pg_terminate_backend(pid);
