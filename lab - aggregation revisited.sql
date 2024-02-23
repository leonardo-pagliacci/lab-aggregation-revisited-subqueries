-- Select the first name, last name, and email address of all the customers who have rented a movie.
select distinct(concat(c.first_name, ' ', c.last_name)) as customer_name,
	c.email as email
from sakila.customer c
left join sakila.rental r on c.customer_id = r.customer_id;

-- What is the average payment made by each customer 
-- (display the customer id, customer name (concatenated), and the average payment made).
select
	concat(c.first_name, ' ', c.last_name) as customer_name,
    c.customer_id as customer_id,
    avg(p.amount) as average_payment_made
from sakila.customer c
left join sakila.payment p on c.customer_id = p.customer_id
group by customer_id;

-- Select the name and email address of all the customers who have rented the "Action" movies.
-- 1. Write the query using multiple join statements
select
	concat(c.first_name, ' ', c.last_name) as customer_name,
    c.email as email,
    cat.name as category_name
from sakila.customer c
left join sakila.rental r on c.customer_id = r.customer_id
left join sakila.inventory i on r.inventory_id = i.inventory_id
left join sakila.film f on i.film_id = f.film_id
left join sakila.film_category fc on f.film_id = fc.film_id
left join sakila.category cat on fc.category_id = cat.category_id
where cat.name like 'Action';



-- 2. Write the query using sub queries with multiple WHERE clause and IN condition



select
	concat(first_name, ' ', last_name) as customer_name,
    email
from sakila.customer
where customer_id in
(select customer_id
from sakila.rental
where inventory_id in
(select inventory_id
from sakila.inventory
where film_id in
(select film_id
from sakila.film_category
where category_id in
(select category_id
from sakila.category
where name like 'Action'))));


-- Verify if the above two queries produce the same results or not --> YEP!

-- Use the case statement to create a new column classifying existing columns as either
-- or high value transactions based on the amount of payment. 
-- If the amount is between 0 and 2, label should be low and if the amount is between 2 and 4, the label should be medium,
-- and if it is more than 4, then it should be high.

select *,
case
    WHEN amount > 0 AND amount < 2 THEN 'Low'
    WHEN amount >= 2 AND amount < 4 THEN 'Medium'
    ELSE 'High'
end as bin_amount
from sakila.payment
