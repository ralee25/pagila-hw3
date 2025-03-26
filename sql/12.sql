/* 
 * A new James Bond movie will be released soon, and management wants to send promotional material to "action fanatics".
 * They've decided that an action fanatic is any customer where at least 4 of their 5 most recently rented movies are action movies.
 *
 * Write a SQL query that finds all action fanatics.
 */

WITH recent_movies AS (
  -- For each customer, get the most recent rental for each distinct film.
  SELECT DISTINCT ON (r.customer_id, i.film_id)
         r.customer_id,
         i.film_id,
         r.rental_date
  FROM rental r
  JOIN inventory i ON r.inventory_id = i.inventory_id
  ORDER BY r.customer_id, i.film_id, r.rental_date DESC
),
ranked_movies AS (
  -- Rank each distinct movie per customer by rental date (most recent first)
  SELECT rm.*,
         ROW_NUMBER() OVER (PARTITION BY rm.customer_id ORDER BY rm.rental_date DESC) AS rn
  FROM recent_movies rm
),
action_rentals AS (
  -- For each customer's top 5 distinct movies, mark whether the film is an Action movie.
  SELECT rm.customer_id,
         rm.film_id,
         rm.rental_date,
         CASE 
           WHEN EXISTS (
             SELECT 1 
             FROM film_category fc 
             JOIN category c ON fc.category_id = c.category_id
             WHERE fc.film_id = rm.film_id 
               AND c.name = 'Action'
           ) THEN 1 
           ELSE 0 
         END AS is_action
  FROM ranked_movies rm
  WHERE rn <= 5
),
customer_action AS (
  -- Count the number of Action movies in each customer's top 5 rentals.
  SELECT customer_id,
         SUM(is_action) AS action_count
  FROM action_rentals
  GROUP BY customer_id
)
SELECT c.customer_id, c.first_name, c.last_name
FROM customer c
JOIN customer_action ca ON c.customer_id = ca.customer_id
WHERE ca.action_count >= 4
ORDER BY c.customer_id;

