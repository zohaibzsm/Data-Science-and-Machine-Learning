USE sales;
SELECT *
FROM customers;

-- Total distinct products sold in mumbai
SELECT COUNT(DISTINCT product_code)
FROM transactions
WHERE market_code = 'Mark002'
AND sales_amount NOT BETWEEN -1 AND 0;

-- Distinct products sold in mumbai
SELECT DISTINCT product_code 
FROM transactions
WHERE market_code = 'Mark002'
AND sales_amount NOT BETWEEN -1 AND 0;

-- total sales for mumbai for in 2020 and 2019
SELECT SUM(sales_amount) AS 'Total Sales'
FROM transactions
WHERE sales_amount NOT BETWEEN -1 AND 0
AND order_date BETWEEN '2019-01-01' AND '2020-12-31';
-- SELECT SUM(336452114+142235559)
-- 336452114 IN 2019
-- 142235559 IN 2020

-- total revenue in 2020
SELECT SUM(sales_amount)
FROM transactions
WHERE order_date BETWEEN '2020-01-01' AND '2020-12-31';

-- first 3 months revenue in 2020
SELECT SUM(sales_amount)
FROM transactions
WHERE order_date BETWEEN '2020-01-01' AND '2020-03-31';

-- last month revenue for 2019
SELECT SUM(sales_amount)
FROM transactions
WHERE order_date BETWEEN '2019-12-01' AND '2019-12-31';

-- top 3 sales in 2020
SELECT product_code, sales_amount
FROM transactions
WHERE sales_amount NOT BETWEEN -1 AND 0
AND order_date BETWEEN '2020-01-01' AND '2020-12-31'
ORDER BY sales_amount DESC
LIMIT 3;

-- bottom 3 sales in 2020
SELECT product_code, sales_amount
FROM transactions
WHERE sales_amount NOT BETWEEN -1 AND 0
AND order_date BETWEEN '2020-01-01' AND '2020-12-31'
ORDER BY sales_amount
LIMIT 3;

-- top 5 customers by revenue
SELECT tr.customer_code, c.custmer_name, SUM(tr.sales_amount) AS Total_Amount
FROM customers AS c
JOIN transactions AS tr
ON tr.customer_code = c.customer_code
GROUP BY tr.customer_code
ORDER BY Total_Amount DESC;

-- top 5 products by revenue
SELECT tr.product_code, SUM(tr.sales_amount) AS Total_Amount
FROM products AS p
JOIN transactions AS tr
ON p.product_code = tr.product_code
GROUP BY tr.product_code
ORDER BY Total_Amount DESC;

