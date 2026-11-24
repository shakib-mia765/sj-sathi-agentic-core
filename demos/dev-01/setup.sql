
BEGIN;
CREATE TABLE public.orders (
    order_id text PRIMARY KEY,
    tenant_id text NOT NULL,
    status text NOT NULL
);
INSERT INTO public.orders (order_id, tenant_id, status)
VALUES
    ('A-101', 'business_a', 'pending'),
    ('B-201', 'business_b', 'confirmed');
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_roles WHERE rolname = 'sj_sathi_dev01_app'
    ) THEN
        CREATE ROLE sj_sathi_dev01_app NOLOGIN;
    END IF;
END;
$$;
GRANT USAGE ON SCHEMA public TO sj_sathi_dev01_app;
GRANT SELECT, UPDATE (status) ON public.orders TO sj_sathi_dev01_app;
ALTER TABLE public.orders ENABLE ROW LEVEL SECURITY;
CREATE POLICY orders_tenant_isolation ON public.orders
    TO sj_sathi_dev01_app
    USING (tenant_id = current_setting('app.current_tenant_id', true))
    WITH CHECK (tenant_id = current_setting('app.current_tenant_id', true));
COMMIT;
