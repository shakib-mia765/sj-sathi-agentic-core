BEGIN;
CREATE TEMP TABLE demo_ledger (
    event_id text PRIMARY KEY,
    credit_minor integer NOT NULL CHECK (credit_minor > 0)
);

INSERT INTO demo_ledger (event_id, credit_minor)
VALUES ('demo-payment-001', 50000)
ON CONFLICT (event_id) DO NOTHING;

INSERT INTO demo_ledger (event_id, credit_minor)
VALUES ('demo-payment-001', 50000)
ON CONFLICT (event_id) DO NOTHING;

DO $$
BEGIN
    IF (SELECT count(*) FROM demo_ledger) <> 1
       OR (SELECT sum(credit_minor) FROM demo_ledger) IS DISTINCT FROM 50000
    THEN
        RAISE EXCEPTION 'DEV-03 failed: expected one credit of 50000 minor units';
    END IF;
END;
$$;

SELECT count(*) AS credit_count, sum(credit_minor) AS total_minor
FROM demo_ledger;

ROLLBACK;
