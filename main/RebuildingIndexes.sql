-- Rebuild without locking the table (PostgreSQL 12+)
REINDEX INDEX CONCURRENTLY idx_orders_customer_id;


-- Rebuild all indexes on a table without locking
REINDEX TABLE CONCURRENTLY orders;
