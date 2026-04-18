-- Kill any single query running more than 30 seconds for this role
ALTER ROLE app_user SET statement_timeout = '30s';
