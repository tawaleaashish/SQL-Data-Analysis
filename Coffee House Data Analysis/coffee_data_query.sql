-- Display all data
SELECT * FROM city;
SELECT * FROM customers;
SELECT * FROM products;
SELECT * FROM sales;

-- Number of people in each city are estimated to consume coffee, given that 25% of the population does.
SELECT city_name,ROUND((population * 0.25)/1000000,2) as coffee_consumers_in_millions,city_rank
FROM city
ORDER BY 2 DESC


-- Total revenue generated from coffee sales across all cities in the last quarter of 2023
SELECT ci.city_name,SUM(s.total) as total_revenue
FROM sales as s
JOIN customers as c
ON s.customer_id = c.customer_id
JOIN city as ci
ON ci.city_id = c.city_id
WHERE 
	EXTRACT(YEAR FROM s.sale_date)  = 2023
	AND
	EXTRACT(quarter FROM s.sale_date) = 4
GROUP BY 1
ORDER BY 2 DESC

-- Number of units of each coffee product have been sold
SELECT p.product_name,COUNT(s.product_id) as Total_orders
FROM sales as s
LEFT JOIN products as p
ON s.product_id = p.product_id
GROUP BY 1
ORDER BY 2 DESC

-- Average Sales Amount per City
SELECT ci.city_name,SUM(s.total) as total_revenue,COUNT(DISTINCT s.customer_id) as total_cust,
    ROUND(SUM(s.total)::numeric/COUNT(DISTINCT s.customer_id)::numeric,2) as avg_sale_per_cust
FROM sales as s
JOIN customers as c
ON s.customer_id = c.customer_id
JOIN city as ci
ON ci.city_id = c.city_id
GROUP BY 1
ORDER BY 2 DESC


-- return city_name, total current cx, estimated coffee consumers (25%)
WITH city_table as 
(SELECT city_name,ROUND((population * 0.25)/1000000, 2) as coffee_consumers
FROM city)
,customers_table AS
(SELECT ci.city_name,COUNT(DISTINCT c.customer_id) as unique_cust
 FROM sales as s
 JOIN customers as c
 ON c.customer_id = s.customer_id
 JOIN city as ci
 ON ci.city_id = c.city_id
 GROUP BY 1)
 
SELECT customers_table.city_name,
city_table.coffee_consumers as coffee_consumer_in_millions,customers_table.unique_cust
FROM city_table
JOIN customers_table
ON city_table.city_name = customers_table.city_name

-- Top 3 Selling Products by City
SELECT * 
FROM(SELECT ci.city_name,p.product_name,COUNT(s.sale_id) as total_orders,
	DENSE_RANK() OVER(PARTITION BY ci.city_name ORDER BY COUNT(s.sale_id) DESC) as rank
	FROM sales as s
	JOIN products as p
	ON s.product_id = p.product_id
	JOIN customers as c
	ON c.customer_id = s.customer_id
	JOIN city as ci
	ON ci.city_id = c.city_id
	GROUP BY 1, 2) as t1
WHERE rank <= 3

