/*
 * List all actors with Bacall Number 2;
 * That is, list all actors that have appeared in a film with an actor that has appeared in a film with 'RUSSELL BACALL',
 * but do not include actors that have Bacall Number < 2.
 */


SELECT DISTINCT CONCAT(a.first_name, ' ', a.last_name) AS "Actor Name"
FROM film_actor AS fa
JOIN film_actor AS fa1 ON fa.film_id = fa1.film_id
JOIN actor AS a ON fa.actor_id = a.actor_id
WHERE fa1.actor_id IN (
    SELECT fa2.actor_id
    FROM film_actor AS fa2
    JOIN actor AS a2 ON fa2.actor_id = a2.actor_id
    WHERE fa2.film_id IN (
        SELECT fa3.film_id
        FROM film_actor AS fa3
        WHERE fa3.actor_id = (SELECT actor_id FROM actor WHERE first_name = 'RUSSELL' AND last_name = 'BACALL')
    )
)
    AND fa.actor_id != (SELECT actor_id FROM actor WHERE first_name = 'RUSSELL' AND last_name = 'BACALL')
    AND fa.actor_id NOT IN (
        SELECT fa4.actor_id 
        FROM film_actor AS fa4
        WHERE fa4.film_id IN (
            SELECT fa5.film_id
            FROM film_actor AS fa5
            WHERE fa5.actor_id = (SELECT actor_id FROM actor WHERE first_name = 'RUSSELL' AND last_name = 'BACALL')
        )
    )
    ORDER BY "Actor Name";

