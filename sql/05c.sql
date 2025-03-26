/* 
 * You also like the acting in the movies ACADEMY DINOSAUR and AGENT TRUMAN,
 * and so you'd like to see movies with actors that were in either of these movies or AMERICAN CIRCUS.
 *
 * Write a SQL query that lists all movies where at least 3 actors were in one of the above three movies.
 * (The actors do not necessarily have to all be in the same movie, and you do not necessarily need one actor from each movie.)
 */

SELECT f.title
FROM film f
WHERE (
  SELECT COUNT(DISTINCT fa.actor_id)
  FROM film_actor fa
  WHERE fa.film_id = f.film_id
    AND fa.actor_id IN (
      SELECT DISTINCT fa_sub.actor_id
      FROM film_actor fa_sub
      JOIN film f_sub ON fa_sub.film_id = f_sub.film_id
      WHERE f_sub.title IN ('ACADEMY DINOSAUR', 'AGENT TRUMAN', 'AMERICAN CIRCUS')
    )
) >= 3;

