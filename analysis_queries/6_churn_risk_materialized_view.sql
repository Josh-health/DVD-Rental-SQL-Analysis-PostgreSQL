/* ============================================================
   6. MARKETING TARGET VIEW (HIGH-VALUE, AT-RISK CUSTOMERS)
   Purpose:
   - Create a reusable marketing dataset.
   - Targets customers who:
     • Spend heavily (High Lifetime Value)
     • Have been inactive for 30+ days
   - Ideal for email campaigns & re-engagement offers.
   ============================================================ */

CREATE MATERIALIZED VIEW marketing_targets_vw AS
SELECT 
    c.first_name,
    c.last_name,
    c.email,

    -- Total customer spend over lifetime
    SUM(p.amount) AS total_lifetime_spend,

    -- Last recorded rental activity
    MAX(r.rental_date)::DATE AS last_rental_date

FROM customer AS c
JOIN payment AS p
    ON c.customer_id = p.customer_id
JOIN rental AS r
    ON c.customer_id = r.customer_id

GROUP BY 
    c.customer_id, 
    c.first_name, 
    c.last_name, 
    c.email

HAVING 
    -- High-value customers
    SUM(p.amount) > 150
    
    AND
    
    -- Inactive for at least 30 days from reference date
    MAX(r.rental_date)::DATE < ('2006-02-14'::DATE - INTERVAL '30 days');



/* ============================================================
   Refresh the materialized view to keep data up to date
   ============================================================ */
REFRESH MATERIALIZED VIEW marketing_targets_vw;

-- Preview the marketing target list
SELECT * 
FROM marketing_targets_vw;