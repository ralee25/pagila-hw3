/*
 * This question and the next one are inspired by the Bacon Number:
 * https://en.wikipedia.org/wiki/Six_Degrees_of_Kevin_Bacon#Bacon_numbers
 *
 * List all actors with Bacall Number 1.
 * That is, list all actors that have appeared in a film with 'RUSSELL BACALL'.
 * Do not list 'RUSSELL BACALL', since he has a Bacall Number of 0.
 */

SELECT DISTINCT CONCAT(a.first_name, ' ', a.last_name) AS "Actor Name"
FROM film_actor AS fa
JOIN film_actor AS bacall_fa ON fa.film_id = bacall_fa.film_id
JOIN actor AS a ON fa.actor_id = a.actor_id
WHERE bacall_fa.actor_id = (SELECT actor_id FROM actor WHERE first_name = 'RUSSELL' AND last_name = 'BACALL')
AND fa.actor_id != bacall_fa.actor_id
ORDER BY "Actor Name";

