/* ============================================================
   1. CUSTOMER SEGMENTATION ANALYSIS
   Purpose:
   - Classify customers into business-friendly segments:
     • Top Tier   → High spenders
     • At Risk    → Haven’t rented recently
     • Occasional → Everyone else
   - Uses a simulated "current date" based on the latest rental.
   ============================================================ */

WITH TodayDate AS (
    -- Simulate today's date using the latest rental date in the dataset
    SELECT 
        MAX(rental_date)::DATE + INTERVAL '2 days' AS simulation_date
    FROM rental
),

CustomerStats AS (
    -- Aggregate customer spending and last activity date
    SELECT 
        c.customer_id,
        c.first_name,
        c.last_name,
        SUM(p.amount) AS total_spend,
        MAX(r.rental_date)::DATE AS last_rental_date
    FROM customer AS c
    JOIN payment AS p
        ON c.customer_id = p.customer_id
    JOIN rental AS r
        ON c.customer_id = r.customer_id
    GROUP BY 
        c.customer_id, 
        c.first_name, 
        c.last_name
)

-- Assign customer segment labels based on behavior
SELECT 
    cs.*,
    CASE
        -- Customers inactive for more than 30 days
        WHEN (tod.simulation_date::DATE - cs.last_rental_date::DATE) > 30 
            THEN 'At Risk'

        -- High-value customers
        WHEN cs.total_spend > 150
            THEN 'Top Tier'

        -- Remaining customers
        ELSE 'Occasional'
    END AS customer_segment
FROM CustomerStats AS cs
CROSS JOIN TodayDate AS tod;



