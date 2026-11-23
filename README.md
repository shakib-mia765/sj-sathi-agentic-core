DEV-01 — Tenant Isolation Demo
This demo verifies that Business A can read its own orders and that Business B’s orders stay private and unchanged when Business A tries to access them.

Run all three checks using a Business A account. Start with two existing orders: A-101 belongs to Business A, and B-201 belongs to Business B.
Check	Expected result
Read order A-101.	The query returns exactly one order, A-101.
Read order B-201.	The query returns zero orders.
Attempt to update order B-201.	Zero records are changed.
