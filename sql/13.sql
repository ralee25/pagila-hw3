/*
 * Management wants to create a "best sellers" list for each actor.
 *
 * Write a SQL query that:
 * For each actor, reports the three films that the actor starred in that have brought in the most revenue for the company.
 * (The revenue is the sum of all payments associated with that film.)
 *
 * HINT:
 * For correct output, you will have to rank the films for each actor.
 * My solution uses the `rank` window function.
 */

WITH film_revenue AS (
  SELECT
    f.film_id,
    f.title,
    SUM(p.amount) AS revenue
  FROM film f
  JOIN inventory i ON f.film_id = i.film_id
  JOIN rental r ON i.inventory_id = r.inventory_id
  JOIN payment p ON r.rental_id = p.rental_id
  GROUP BY f.film_id, f.title
)
SELECT
  actor_id,
  first_name,
  last_name,
  film_id,
  title,
  rnk AS "rank",
  revenue
FROM (
  SELECT
    a.actor_id,
    a.first_name,
    a.last_name,
    fr.film_id,
    fr.title,
    fr.revenue,
    RANK() OVER (PARTITION BY a.actor_id ORDER BY fr.revenue DESC, fr.film_id ASC) AS rnk
  FROM actor a
  JOIN film_actor fa ON a.actor_id = fa.actor_id
  JOIN film_revenue fr ON fa.film_id = fr.film_id
) sub
WHERE rnk <= 3
ORDER BY actor_id, rnk;

