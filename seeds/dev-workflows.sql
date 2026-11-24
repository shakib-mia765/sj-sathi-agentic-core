BEGIN;
CREATE TABLE IF NOT EXISTS public.workflow_templates (
    prompt_id text PRIMARY KEY,
    segment_tag text NOT NULL,
    title text NOT NULL,
    prompt_body text NOT NULL
);

INSERT INTO public.workflow_templates (prompt_id, segment_tag, title, prompt_body)
VALUES
    (
        'DEV-01',
        'SEG_PRO_DEV',
        'Multi-Tenant Architecture',
        'Design PostgreSQL row-level security for a multi-tenant commerce app. Include tenant isolation policies, composite indexes, and connection pooling guidance.'
    ),
    (
        'DEV-02',
        'SEG_PRO_DEV',
        'Zero-Downtime Migration',
        'Given [Table and Column Details], plan an expand-and-contract column migration. Cover dual writes, batched backfill, verification, cutover, and rollback.'
    ),
    (
        'DEV-03',
        'SEG_PRO_DEV',
        'Payment Webhook Idempotency',
        'Review [Webhook Handler Code] and propose a defensive design that prevents duplicate ledger credits. Include atomic transactions, idempotency keys, and retry behavior.'
    )
ON CONFLICT (prompt_id) DO UPDATE
SET segment_tag = EXCLUDED.segment_tag,
    title = EXCLUDED.title,
    prompt_body = EXCLUDED.prompt_body;

COMMIT;
