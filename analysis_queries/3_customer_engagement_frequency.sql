/* ============================================================
   3. CUSTOMER ENGAGEMENT PERFORMANCE METRIC
   Purpose:
   - Measure average time between rentals for each customer.
   - Useful for understanding engagement frequency.
   - Lower average gap = more engaged customer.
   ============================================================ */

WITH RentalGap AS (
    SELECT 
        customer_id,
        rental_date::DATE AS first_rental_date,

        -- Next rental date for the same customer
        LEAD(rental_date::DATE) OVER (
            PARTITION BY customer_id 
            ORDER BY rental_date
        ) AS next_rental_date,

        -- Difference in days between consecutive rentals
        LEAD(rental_date::DATE) OVER (
            PARTITION BY customer_id 
            ORDER BY rental_date
        ) - rental_date::DATE AS rental_dates_diff
    FROM rental
)

-- Calculate average rental interval per customer
SELECT 
    customer_id,
    ROUND(AVG(rental_dates_diff), 2) AS avg_rental_days
FROM RentalGap
WHERE rental_dates_diff IS NOT NULL
GROUP BY customer_id;