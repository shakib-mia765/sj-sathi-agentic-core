BEGIN;

WITH batch AS (
    SELECT customer_id
    FROM public.customers
    WHERE first_name IS NULL
    ORDER BY customer_id
    LIMIT 1
    FOR UPDATE
)
UPDATE public.customers AS customer
SET customer_name = customer.customer_name
FROM batch
WHERE customer.customer_id = batch.customer_id
RETURNING customer.customer_id, customer.first_name, customer.last_name;

COMMIT;

SELECT count(*) AS remaining_rows
FROM public.customers
WHERE first_name IS NULL;