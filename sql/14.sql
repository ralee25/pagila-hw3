/*
 * Management also wants to create a "best sellers" list for each category.
 *
 * Write a SQL query that:
 * For each category, reports the five films that have been rented the most for each category.
 *
 * Note that in the last query, we were ranking films by the total amount of payments made,
 * but in this query, you are ranking by the total number of times the movie has been rented (and ignoring the price).
 */

SELECT
    c.name,
    tf.title,
    tf.total_rentals AS "total rentals"
FROM category c
CROSS JOIN LATERAL (
    SELECT
        f.title,
        COUNT(r.rental_id) AS total_rentals
    FROM film_category fc
    JOIN film f ON fc.film_id = f.film_id
    JOIN inventory i ON f.film_id = i.film_id
    JOIN rental r ON i.inventory_id = r.inventory_id
    WHERE fc.category_id = c.category_id
    GROUP BY f.title
    ORDER BY COUNT(r.rental_id) DESC, f.title DESC
    LIMIT 5
) tf
ORDER BY c.name, tf.total_rentals DESC, tf.title;
