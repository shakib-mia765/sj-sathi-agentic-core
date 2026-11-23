-- Run as postgres after setup. Queries use the restricted demo role.
BEGIN;
SET LOCAL ROLE sj_sathi_dev01_app;
-- Baseline: B-201 exists and its status is confirmed.
SET LOCAL app.current_tenant_id = 'business_b';
SELECT order_id, status FROM public.orders WHERE order_id = 'B-201';
SET LOCAL app.current_tenant_id = 'business_a';
-- Expected: A-101, pending.
SELECT order_id, status FROM public.orders WHERE order_id = 'A-101';
-- Expected: zero rows.
SELECT order_id, status FROM public.orders WHERE order_id = 'B-201';
-- Expected: UPDATE 0.
UPDATE public.orders SET status = 'cancelled' WHERE order_id = 'B-201';
-- Expected: B-201 still has its original status, confirmed.
SET LOCAL app.current_tenant_id = 'business_b';
SELECT order_id, status FROM public.orders WHERE order_id = 'B-201';
ROLLBACK;
