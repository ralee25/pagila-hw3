/* 
 * Finding movies with similar categories still gives you too many options.
 *
 * Write a SQL query that lists all movies that share 2 categories with AMERICAN CIRCUS and 1 actor.
 *
 * HINT:
 * It's possible to complete this problem both with and without set operations,
 * but I find the version using set operations much more intuitive.
 */

SELECT f.title
FROM film f
WHERE f.film_id IN (
  (
    SELECT film_id
    FROM film_category
    WHERE category_id IN (
      SELECT fc.category_id
      FROM film_category fc
      JOIN film f2 ON fc.film_id = f2.film_id
      WHERE f2.title = 'AMERICAN CIRCUS'
    )
    GROUP BY film_id
    HAVING COUNT(DISTINCT category_id) >= 2
  )
  INTERSECT
  (
    SELECT film_id
    FROM film_actor
    WHERE actor_id IN (
      SELECT fa.actor_id
      FROM film_actor fa
      JOIN film f3 ON fa.film_id = f3.film_id
      WHERE f3.title = 'AMERICAN CIRCUS'
    )
    GROUP BY film_id
    HAVING COUNT(DISTINCT actor_id) >= 1
  )
)
ORDER BY f.title;

