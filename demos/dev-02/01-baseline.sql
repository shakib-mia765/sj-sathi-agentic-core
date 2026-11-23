CREATE TABLE public.customers (
    customer_id integer PRIMARY KEY,
    customer_name text NOT NULL
);

INSERT INTO public.customers (customer_id, customer_name)
VALUES
    (1, 'Amina Rahman'),
    (2, 'Karim Hasan');

SELECT customer_id, customer_name
FROM public.customers
ORDER BY customer_id;