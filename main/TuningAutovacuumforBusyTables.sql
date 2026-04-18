-- Lower the threshold so vacuum fires sooner on this table
ALTER TABLE orders SET (
    autovacuum_vacuum_scale_factor  = 0.01,   -- fire at 1% dead tuples (default 20%)
    autovacuum_analyze_scale_factor = 0.005   -- analyze at 0.5% row changes
);
