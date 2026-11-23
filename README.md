## DEV-01 - Order Isolation with PostgreSQL RLS

Verify that PostgreSQL row-level security limits order access to the active business when queries run under the SJ Sathi application role.

### Test setup

Use two sample orders in a test database. Business A owns `A-101`, and Business B owns `B-201`. As Business B, read `B-201` and record its status before running the checks.

### Acceptance criteria

| Tenant | Check | Expected result |
| --- | --- | --- |
| Business A | Read `A-101` by order ID | Exactly one row is returned. |
| Business A | Read `B-201` by order ID | No rows are returned. |
| Business A | Set `B-201` to a different status by order ID | Zero rows are updated. |
| Business B | Read `B-201` after the update attempt | Exactly one row is returned with its original status. |

Filter by order ID only for the cross-tenant checks so the database policy determines which rows are accessible.
