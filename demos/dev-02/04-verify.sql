BEGIN;

-- Check that all existing rows are ready for the new read path.
DO $$
BEGIN
    IF EXISTS (
        SELECT 1
        FROM public.customers
        WHERE first_name IS NULL
           OR concat_ws(' ', first_name, last_name)
              IS DISTINCT FROM customer_name
    ) THEN
        RAISE EXCEPTION 'DEV-02: Backfill is incomplete or names differ';
    END IF;
END;
$$;

SELECT customer_id, first_name, last_name
FROM public.customers
ORDER BY customer_id;

UPDATE public.customers
SET customer_name = 'Amina Sultana'
WHERE customer_id = 1;

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM public.customers
        WHERE customer_id = 1
          AND customer_name = 'Amina Sultana'
          AND first_name = 'Amina'
          AND last_name = 'Sultana'
    ) THEN
        RAISE EXCEPTION 'DEV-02: Read paths disagree after a legacy update';
    END IF;
END;
$$;

SELECT customer_name AS old_read,
       concat_ws(' ', first_name, last_name) AS new_read
FROM public.customers
WHERE customer_id = 1;

-- Discard the test update.
ROLLBACK;
