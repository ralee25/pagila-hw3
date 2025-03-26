/*
 * Management also wants to create a "best sellers" list for each category.
 *
 * Write a SQL query that:
 * For each category, reports the five films that have been rented the most for each category.
 *
 * Note that in the last query, we were ranking films by the total amount of payments made,
 * but in this query, you are ranking by the total number of times the movie has been rented (and ignoring the price).
 */

WITH film_rentals AS (
  SELECT
    c.name,
    f.title,
    COUNT(r.rental_id) AS total_rentals
  FROM film f
  JOIN film_category fc ON f.film_id = fc.film_id
  JOIN category c ON fc.category_id = c.category_id
  LEFT JOIN inventory i ON f.film_id = i.film_id
  LEFT JOIN rental r ON i.inventory_id = r.inventory_id
  GROUP BY c.name, f.film_id, f.title
)
SELECT name, title, total_rentals AS "total rentals"
FROM (
  SELECT
    fr.*,
    RANK() OVER (PARTITION BY name ORDER BY total_rentals DESC) AS rnk
  FROM film_rentals fr
) sub
WHERE rnk <= 5
ORDER BY name, rnk;

