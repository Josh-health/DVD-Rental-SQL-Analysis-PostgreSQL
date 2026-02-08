/* ============================================================
   2. CONTENT GAP ANALYSIS
   Purpose:
   - Identify categories available in store inventory
     that have NEVER been rented.
   - Helps management spot underperforming content areas.
   ============================================================ */

WITH StoreInventory AS (
    -- List all categories available in each store’s inventory
    SELECT DISTINCT
        i.store_id,
        c.name AS category_name
    FROM inventory AS i
    JOIN film_category AS fc
        ON i.film_id = fc.film_id
    JOIN category AS c
        ON fc.category_id = c.category_id
),

StoreSales AS (
    -- List categories that have actually been rented
    SELECT DISTINCT
        i.store_id,
        c.name AS category_name
    FROM rental AS r
    JOIN inventory AS i 
        ON r.inventory_id = i.inventory_id
    JOIN film_category AS fc
        ON i.film_id = fc.film_id
    JOIN category AS c
        ON fc.category_id = c.category_id
)

-- Categories in inventory but never rented (content gap)
SELECT * FROM StoreInventory

EXCEPT

SELECT * FROM StoreSales;



