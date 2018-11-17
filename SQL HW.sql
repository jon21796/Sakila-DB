use sakila;

select * from actor;
-- 1a. Display the first and last names of all actors from the table actor.
select first_name, last_name from actor;

-- 1b. Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name.
select concat(upper(first_name), ' ', upper(last_name)) as 'Actor Name' from actor;

-- 2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." What is one query would you use to obtain this information?
select actor_id, first_name, last_name 
from actor
where first_name like 'Joe%';

-- 2b. Find all actors whose last name contain the letters GEN:
select actor_id, first_name, last_name 
from actor
where last_name like '%GEN%';

-- 2c. Find all actors whose last names contain the letters LI. This time, order the rows by last name and first name, in that order:
select first_name, last_name 
from actor
where last_name like '%LI%'
order by 2, 1;

-- 2d. Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China:
select country_id, country
from country
where country in ('Afghanistan', 'Bangladesh', 'China');


-- 3a. You want to keep a description of each actor. You don't think you will be performing queries on a description, so create a column in the table actor named description and use the data type BLOB (Make sure to research the type BLOB, as the difference between it and VARCHAR are significant).
alter table actor ADD Description BLOB NULL;

-- 3b. Very quickly you realize that entering descriptions for each actor is too much effort. Delete the description column.
alter table actor DROP Description;

-- 4a. List the last names of actors, as well as how many actors have that last name.
select last_name, count(*) 
from actor
group by last_name;


-- 4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors
select last_name, count(*) 
from actor
group by last_name
having count(*) > 1;

-- 4c. The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS. Write a query to fix the record.
update actor
set first_name = 'HARPO'
where last_name = 'WILLIAMS' and first_name = 'GROUCHO';

-- 4d. Perhaps we were too hasty in changing GROUCHO to HARPO. It turns out that GROUCHO was the correct name after all! In a single query, if the first name of the actor is currently HARPO, change it to GROUCHO.
update actor
set first_name = 'GROUCHO'
where last_name = 'WILLIAMS' and first_name = 'HARPO';


-- 5a. You cannot locate the schema of the address table. Which query would you use to re-create it?
describe address;

SHOW CREATE TABLE address;

-- Hint: https://dev.mysql.com/doc/refman/5.7/en/show-create-table.html

-- 6a. Use JOIN to display the first and last names, as well as the address, of each staff member. Use the tables staff and address:
select * from staff;
select * from address;
select * from payment;

select s.first_name, s.last_name, a.address, a.city_id, a.postal_code
from staff s, address a
where s.address_id = a.address_id;

-- 6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment.
select s.staff_id, s.first_name, s.last_name, sum(p.amount) as "Total Amt Rung"
from staff s, payment p
where s.staff_id = p.staff_id
and p.payment_date between '2005-08-01' and '2005-08-31'
group by s.staff_id, s.first_name, s.last_name
order by 1;

-- 6c. List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join.
select * from film_actor;
select * from film;

select f.title, count(a.actor_id)
from film_actor a, film f
where a.film_id = f.film_id
group by f.title;

-- 6d. How many copies of the film Hunchback Impossible exist in the inventory system?
select * from inventory;

select count(i.film_id)
from inventory i, film f
where i.film_id = f.film_id
and f.title = 'Hunchback Impossible';

-- 6e. Using the tables payment and customer and the JOIN command, list the total paid by each customer. List the customers alphabetically by last name:
select * from payment;
select * from customer;

select c.first_name, c.last_name, sum(p.amount) as 'Total Amount Paid'
from customer c, payment p
where c.customer_id = p.customer_id
group by c.first_name, c.last_name
order by 2;

-- 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, films starting with the letters K and Q have also soared in popularity. Use subqueries to display the titles of movies starting with the letters K and Q whose language is English.
select * from language; 
select f.title
from film f, language l
where f.language_id = l.language_id
and l.name = 'English'
and f.title like 'K%' or f.title like 'Q%';

-- 7b. Use subqueries to display all actors who appear in the film Alone Trip.
select a.first_name, a.last_name
from actor a, film f, film_actor fa
where a.actor_id = fa.actor_id
and f.film_id = fa.film_id
and f.title = 'Alone Trip';

-- 7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. Use joins to retrieve this information.
select * from city;
select c.first_name, c.last_name, c.email
from customer c, address a, country co, city ci
where a.address_id = c.address_id
and a.city_id = ci.city_id
and ci.country_id = co.country_id
and co.country = 'Canada';

-- 7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.
select title 
from film 
where rating in ('G','PG','PG-13');

-- 7e. Display the most frequently rented movies in descending order.
select * from rental;
select * from inventory;

select f.title, count(*)
from film f, rental r, inventory i
where r.inventory_id = i.inventory_id
and i.film_id = f.film_id
group by f.title 
order by 2 desc; 

-- 7f. Write a query to display how much business, in dollars, each store brought in.
select * from store;
select s.store_id, sum(p.amount)
from store s, payment p
where s.manager_staff_id = p.staff_id
group by s.store_id;

-- 7g. Write a query to display for each store its store ID, city, and country.
select s.store_id,  c.city, co.country
from store s, city c, country co, address a
where s.address_id = a.address_id
and a.city_id = c.city_id
and c.country_id = co.country_id;

-- 7h. List the top five genres in gross revenue in descending order. (Hint: you may need to use the following tables: category, film_category, inventory, payment, and rental.)
select * from film_category;
select * from category;

select * from 
(select  ROW_NUMBER() OVER (
 ORDER BY sum(p.amount) desc
 ) row_num, c.name, sum(p.amount) as "Gross Revenue"
from category c, payment p, film_category fc, inventory i, rental r
where c.category_id = fc.category_id
and fc.film_id = i.film_id
and i.inventory_id = r.inventory_id
and r.rental_id = p.rental_id
group by c.name) a
where a.row_num < 6;


-- 8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view.
Create view Executive_Data AS
select * from 
(select  ROW_NUMBER() OVER (
 ORDER BY sum(p.amount) desc
) row_num, c.name, SUM(p.amount) as "Gross Revenue"
from category c, payment p, film_category fc, inventory i, rental r
where c.category_id = fc.category_id
and fc.film_id = i.film_id
and i.inventory_id = r.inventory_id
and r.rental_id = p.rental_id
group by c.name) a
where a.row_num < 6;

-- 8b. How would you display the view that you created in 8a?
select * from Executive_Data;

-- 8c. You find that you no longer need the view top_five_genres. Write a query to delete it.
Drop View Executive_Data;