/*
In This Script we are going to explore different reports, create some views and 
create some Stored Procedures for the eCommerce Project
*/

/*
For the JOINS we decided to use the following nomenclature for the tables:
category		AS		pc		(for "product category"
customers		AS		c		
order_details	AS		od		
orders			AS		o		
payments		AS		m		(for "money"
products		AS		p		
suppliers		AS		s		
*/

#Selecting the Database
USE ecommerce_site;

#1 - We want to find out our most expensive item
SELECT 
    product_name, unit_price
FROM
    products
ORDER BY unit_price DESC
LIMIT 1;


#2 - We want to find out the number of customers per state ordered from highest to lowest
SELECT 
    state, COUNT(1) AS no_of_customers
FROM
    customers
GROUP BY state
ORDER BY no_of_customers DESC;


#3 - We want to find out the name, unit price, unit stock and discontinued flag 
#for the products that weren’t ordered by our customers.
SELECT 
    p.product_name,
    p.unit_price,
    p.unit_stock,
    p.discontinued_flag
FROM
    products AS p
        LEFT JOIN
    order_details AS od ON p.product_id = od.product_id
WHERE
    od.product_id IS NULL;

#4 - We want to find out the name of our top supplier in terms of total revenue.
SELECT 
    s.company_name, SUM(o.order_value) AS total_revenue
FROM
    suppliers AS s
        JOIN
    products AS p ON s.supplier_id = p.supplier_id
        JOIN
    order_details AS od ON p.product_id = od.product_id
        JOIN
    orders AS o ON od.order_id = o.order_id
GROUP BY s.company_name
ORDER BY total_revenue DESC
LIMIT 1;

#5 - We want to find out the top categories where our customers are ordering from
SELECT 
    pc.category_name, COUNT(o.order_id) AS no_of_orders
FROM
    category AS pc
        JOIN
    products AS p ON pc.category_id = p.category_id
        JOIN
    order_details AS od ON p.product_id = od.product_id
        JOIN
    orders AS o ON od.order_id = o.order_id
        JOIN
    customers AS c ON o.customer_id = c.customer_id
GROUP BY pc.category_name
ORDER BY no_of_orders DESC;

#6 - We want to find out the customer first name, order id and the average price per order 
#ranked by the most expensive average price per order.
SELECT 
    first_name,
    od.order_id,
    ROUND(AVG(unit_price), 2) AS avg_price_per_order
FROM
    order_details AS od
        JOIN
    orders AS o ON od.order_id = o.order_id
        JOIN
    customers AS c ON o.customer_id = c.customer_id
GROUP BY od.order_id
ORDER BY avg_price_per_order DESC
LIMIT 5;

#7 - Customer details who spent the most money on orders
SELECT 
    c.first_name,
    c.last_name,
    c.gender,
    c.customer_since,
    c.state,
    c.country,
    ROUND(SUM(o.order_value), 2) AS total_spent
FROM
    orders AS o
        JOIN
    customers AS c ON o.customer_id = c.customer_id
GROUP BY o.customer_id
ORDER BY total_spent DESC
LIMIT 1;

#8 - We want to find out the order id, order date, customer full name, order value, order status, 
#payment type and payment status where the order status was “Cancelled”.
SELECT 
    o.order_id,
    o.order_date,
    c.first_name,
    c.last_name,
    o.order_value,
    o.order_status,
    m.payment_type,
    m.payment_status
FROM
    orders AS o
        JOIN
    customers AS c ON o.customer_id = c.customer_id
        JOIN
    payments AS m ON o.order_id = m.order_id
WHERE
    o.order_status = 'Cancelled';

#9 - We want to find out the full name of customers and their amount of orders who made more than one order in the last two weeks.
SELECT CONCAT_WS(", ", first_name, last_name) as cust_full_name,
              COUNT(o.customer_id) as no_of_orders
FROM customers as c
JOIN orders as o
ON c.customer_id = o.customer_id
WHERE o.order_date BETWEEN (NOW() - INTERVAL 14 DAY) AND NOW()
GROUP BY cust_full_name
HAVING no_of_orders > 1;


#10 - What is the most popular category per gender and how many orders did they make from that category
(SELECT 
	c.gender AS customer_gender,
	pc.category_name AS product_category,
	COUNT(o.order_id) AS no_of_order
FROM
	category AS pc
		JOIN
	products AS p ON pc.category_id = p.category_id
		JOIN
	order_details AS od ON p.product_id = od.product_id
		JOIN
	orders AS o ON od.order_id = o.order_id
		JOIN
	customers AS c ON o.customer_id = c.customer_id
WHERE
	Gender = 'M'
GROUP BY customer_gender, product_category
ORDER BY no_of_order DESC
LIMIT 1)
UNION ALL 
(SELECT 
	c.gender AS customer_gender,
	pc.category_name AS product_category,
	COUNT(o.order_id) AS no_of_order
FROM
	category AS pc
		JOIN
	products AS p ON pc.category_id = p.category_id
		JOIN
	order_details AS od ON p.product_id = od.product_id
		JOIN
	orders AS o ON od.order_id = o.order_id
		JOIN
	customers AS c ON o.customer_id = c.customer_id
WHERE
	Gender = 'F'
GROUP BY customer_gender, product_category
ORDER BY no_of_order DESC
LIMIT 1)
UNION ALL 
(SELECT 
	c.gender AS customer_gender,
	pc.category_name AS product_category,
	COUNT(o.order_id) AS no_of_order
FROM
	category AS pc
		JOIN
	products AS p ON pc.category_id = p.category_id
		JOIN
	order_details AS od ON p.product_id = od.product_id
		JOIN
	orders AS o ON od.order_id = o.order_id
		JOIN
	customers AS c ON o.customer_id = c.customer_id
WHERE
	Gender = 'O'
GROUP BY customer_gender, product_category
ORDER BY no_of_order DESC
LIMIT 1);


#------------------------------------------------------------------------------------------------
