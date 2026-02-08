/* ============================================================
   5. BEST PERFORMING CATEGORIES (REVENUE ANALYSIS)
   Purpose:
   - Identify film categories generating above-average revenue.
   - Helps guide:
     • Content acquisition strategy
     • Marketing focus
     • Inventory expansion decisions
   ============================================================ */

WITH CategorySales AS (
    SELECT 
        c.name AS category_name,
        SUM(p.amount) AS total_revenue
    FROM category AS c
    JOIN film_category AS fc
        ON c.category_id = fc.category_id
    JOIN inventory AS i
        ON fc.film_id = i.film_id
    JOIN rental AS r
        ON i.inventory_id = r.inventory_id
    JOIN payment AS p
        ON r.rental_id = p.rental_id
    GROUP BY c.name
)

-- Select categories performing above the overall average revenue
SELECT 
    category_name,
    total_revenue
FROM CategorySales
WHERE total_revenue > (
    SELECT AVG(total_revenue) 
    FROM CategorySales
)
ORDER BY total_revenue DESC;



