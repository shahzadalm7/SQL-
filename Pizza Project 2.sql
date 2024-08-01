CREATE DATABASE pizzahut;
use pizzahut;

CREATE TABLE pizzas(
pizza_id varchar(50) not null primary key,
pizza_type_id text not null,
size text not null,
price Decimal(10,2)
);

CREATE TABLE pizza_types(
pizza_type_id varchar(50) not null primary key,
name varchar(50) not null,
category varchar(50) not null,
ingredients varchar(80)
);

CREATE TABLE orders (
order_id int not null primary key,
order_date date not null,
order_time time not null);

CREATE TABLE order_details(
order_details_id int not null primary key,
order_id int not null,
pizza_id text not null,
quantity int not null
);

SELECT* FROM pizzas;
SELECT* FROM pizza_types;
SELECT* FROM orders;
SELECT* FROM order_details; 
  
  
 -- LET US SOLVE FEW BUSINESS QUESTIONS On Pizzhut......
   
   
-- 1. Retrieve the total number of orders placed.
SELECT COUNT(order_id) as Total_order FROM orders;

-- 2. Calculate the total revenue generated from pizza sales.
SELECT SUM(order_details.quantity * pizzas.price) as Total_Revenue
from order_details 
 Inner join pizzas 
on  order_details.pizza_id = pizzas.pizza_id;


-- 3. Identify the highest-priced pizza.
SELECT pizza_types.name , pizzas.price
From pizza_types
Join pizzas
on pizza_types.pizza_type_id = pizzas.pizza_type_id
order by pizzas.price desc                     -- hightest priced pizza in descending order 
limit 2;                                        -- top 2 show 


-- 4. Identify the most common pizza size ordered.
SELECT pizzas.size ,count(order_details.order_details_id) as order_count
from pizzas 
join order_details 
on pizzas.pizza_id = order_details.pizza_id
group by pizzas.size 
order by order_count desc;


-- 5. List the top 5 most ordered pizza types along with their quantities.
select pizzas.pizza_type_id as pizza_type, 
count(order_details.quantity) as count_qunatity
from pizzas 
join order_details
on pizzas.pizza_id = order_details.pizza_id
Group by pizzas.pizza_type_id
limit 5 ;


-- 6.Join the necessary tables to find the total quantity of each pizza category ordered.
select pizza_types.category ,
sum(order_details.quantity) as Total_quantity
from pizza_types
join pizzas
on pizza_types.pizza_type_id = pizzas.pizza_type_id
    join order_details
    on order_details.pizza_id = pizzas.pizza_id
group by  pizza_types.category;

-- 7 Determine the distribution of orders by hour of the day.
SELECT hour(order_time), count(order_id) FROM orders   -- hour() function use for order_time 
Group by hour(order_time) ;

-- 8 Join relevant tables to find the category-wise distribution of pizzas.
SELECT category , count(name) from pizza_types
group by category;

-- 9 Group the orders by date and calculate the average number of pizzas ordered per day.

select                        -- use sub_query in select .
     round(avg(quantity),0)     -- round_off avg quantity at 0 decimal places
     from
          (SELECT orders.order_date as order_per_day , 
          count(order_details.quantity) as quantity
          from orders
          join order_details
          on orders.order_id = order_details.order_id
          group by orders.order_date) as order_quantity ;
                        -- avg num of pizzas ordered per days 138 

-- 10 Determine the top 3 most ordered pizza types based on revenue.
SELECT 
    pizza_types.name,
    SUM(order_details.quantity * pizzas.price) AS Revenue
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.name
ORDER BY revenue DESC
LIMIT 3;


 -- Advanced types :

-- 11 Determine the top 3 most ordered pizza types based on revenue for each pizza category.
SELECT name , Revenue 
FROM
(SELECT category ,name , Revenue,
Rank() over (partition by category order by Revenue desc) as rn

 FROM
     (select pizza_types.category , pizza_types.name , 
      sum(order_details.quantity * pizzas.price) as Revenue 

      from pizza_types
      join pizzas
       on pizza_types.pizza_type_id= pizzas.pizza_type_id
     join order_details
      on order_details.pizza_id= pizzas.pizza_id
     group by pizza_types.category , pizza_types.name
       order by revenue desc) as a) as b
where rn <=3;



SELECT* FROM pizzas;
SELECT* FROM pizza_types;
SELECT* FROM orders;
SELECT* FROM order_details; 