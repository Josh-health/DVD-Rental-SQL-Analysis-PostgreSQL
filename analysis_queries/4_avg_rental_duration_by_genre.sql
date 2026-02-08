/* ============================================================
   4. ENGAGEMENT TRACKING (RENTAL DURATION BY GENRE)
   Purpose:
   - Measure how long customers keep films before returning them.
   - Helps identify genres with higher engagement time.
   - Longer duration may indicate stronger viewer interest.
   ============================================================ */

WITH RentalDuration AS (
    SELECT
        c.category_id,
        c.name AS genre,
        r.return_date::DATE AS return_date,
        r.rental_date::DATE AS rental_date,

        -- Number of days a film was kept before return
        (r.return_date::DATE - r.rental_date::DATE) AS num_of_rental_days
    FROM category AS c
    JOIN film_category AS fc
        ON c.category_id = fc.category_id
    JOIN inventory AS i
        ON fc.film_id = i.film_id
    JOIN rental AS r
        ON i.inventory_id = r.inventory_id
)

-- Average rental duration per genre
SELECT 
    genre,
    ROUND(AVG(num_of_rental_days), 2) AS avg_rental_days
FROM RentalDuration
GROUP BY genre
ORDER BY avg_rental_days DESC;



