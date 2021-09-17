/*Query 1 - the query used for first insight*/
SELECT DISTINCT(t1.name) AS film_category, title, COUNT(t1.rental_id) 
FROM
  (SELECT f.title, c.name, r.rental_id 
	FROM film f
     	JOIN film_category fc 
	ON f.film_id = fc.film_id
     	JOIN category c 
	ON fc.category_id = c.category_id
     	JOIN inventory AS i 
	ON f.film_id = i.film_id
     	JOIN rental AS r 
	ON i.inventory_id = r.inventory_id
	WHERE c.name = 'Animation' OR c.name ='Children' OR c.name ='Classics' OR c.name ='Comedy' OR c.name ='Family' OR c.name ='Music') AS t1
GROUP BY t1.name, t1.title
ORDER BY t1.name;

/*Query 2 - the query used for second insight*/
SELECT title, name, rental_duration, 
	NTILE(4) OVER (ORDER BY name) AS quartiles
    FROM 
	(SELECT f.title, c.name, f.rental_duration FROM film f 
	JOIN film_category fc 
	ON f.film_id = fc.film_id 
	JOIN category c 
	ON fc.category_id = c.category_id
	WHERE c.name = 'Animation' OR c.name ='Children' OR c.name ='Classics' OR c.name ='Comedy' OR c.name ='Family' OR c.name ='Music') AS t1
ORDER BY QUARTILES;

/*Query 3 - the query used for third insight*/
SELECT  DATE_PART('year', r.rental_date) AS year, DATE_PART('month', r.rental_date) AS month, s.store_id, COUNT(r.rental_id) 
FROM store s
JOIN staff st 
ON s.store_id = st.store_id 
JOIN rental r 
ON st.staff_id = r.staff_id
GROUP BY year, month, s.store_id
ORDER BY year, month;

/*Query 4 - the query used for fourth insight*/
SELECT pay_month, CONCAT(first_name, ' ', last_name) AS full_name, pay_counterpermonth, total 
FROM 
(SELECT DATE_TRUNC('month', p.payment_date) AS pay_month,  c.customer_id, c.first_name, c.last_name, COUNT(p.payment_id) AS pay_counterpermonth, SUM(p.amount) AS total FROM payment p 
	JOIN customer c 
	ON p.customer_id= c.customer_id
	WHERE p.payment_date BETWEEN '2006-12-31' AND '2007-12-31' 
	GROUP BY pay_month, c.customer_id
	ORDER BY total DESC
	LIMIT 10) AS sub;