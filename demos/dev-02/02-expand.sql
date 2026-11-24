BEGIN;
SET LOCAL lock_timeout = '2s';
ALTER TABLE public.customers
    ADD COLUMN first_name text,
    ADD COLUMN last_name text;

CREATE FUNCTION public.sync_customer_name_parts()
RETURNS trigger
LANGUAGE plpgsql
AS $$
BEGIN
    NEW.first_name := split_part(btrim(NEW.customer_name), ' ', 1);
    NEW.last_name := NULLIF(
        ltrim(substr(btrim(NEW.customer_name), length(NEW.first_name) + 1)),
        ''
    );
    RETURN NEW;
END;
$$;

CREATE TRIGGER customers_sync_name_parts
BEFORE INSERT OR UPDATE OF customer_name ON public.customers
FOR EACH ROW
EXECUTE FUNCTION public.sync_customer_name_parts();

COMMIT;
