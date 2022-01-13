# Data Analysis using SQL and Power Bi

> ## Using SQL:
>> ### Distinct Products Sold In Mumbai  
>> `SELECT DISTINCT product_code 
FROM transactions
WHERE market_code = 'Mark002'
AND sales_amount NOT BETWEEN -1 AND 0;`
>> 
>> ![distinct products sold in mumbai](https://user-images.githubusercontent.com/90182043/149306581-75e63001-842d-4806-843e-964859dac4c6.PNG)
> 
>> ### Total Sales For Mumbai For In 2020 and 2019  
>> `SELECT SUM(sales_amount) AS 'Total Sales'
FROM transactions
WHERE sales_amount NOT BETWEEN -1 AND 0
AND market_code = 'Mark002'
AND order_date BETWEEN '2019-01-01' AND '2020-12-31';`
>> 
>> ![total sales for mumbai for in 2020 and 2019](https://user-images.githubusercontent.com/90182043/149306703-bc06f6ec-676e-45c5-b437-4dc46fe25abf.PNG)
> 
>> ### Total Revenue In 2020  
>> `SELECT SUM(sales_amount)
FROM transactions
WHERE order_date BETWEEN '2020-01-01' AND '2020-12-31';`
>> 
>> ![total revenue in 2020](https://user-images.githubusercontent.com/90182043/149306951-88ca5625-8f2e-4b51-b36c-3e129c2c02ca.PNG)
> 
>> ### First 3 Months Revenue In 2020  
>> `SELECT SUM(sales_amount)
FROM transactions
WHERE order_date BETWEEN '2020-01-01' AND '2020-03-31';`
>> 
>> ![first 3 months revenue in 2020](https://user-images.githubusercontent.com/90182043/149307001-92fa8924-d0c0-48ed-abcb-17351187d090.PNG)
> 
>> ### Last Month Revenue For 2019  
>> `SELECT SUM(sales_amount)
FROM transactions
WHERE order_date BETWEEN '2019-12-01' AND '2019-12-31';`
>> 
>> ![last month revenue for 2019](https://user-images.githubusercontent.com/90182043/149307118-81baff0b-d036-40a1-a303-b1f6bc704b8c.PNG)
> 
>> ### Top 5 Customers By Revenue  
>> `SELECT tr.customer_code, c.custmer_name, SUM(tr.sales_amount) AS Total_Amount
FROM customers AS c
JOIN transactions AS tr
ON tr.customer_code = c.customer_code
GROUP BY tr.customer_code
ORDER BY Total_Amount DESC
LIMIT 5;`  
>> 
>> ![git_top 5 customers by revenue](https://user-images.githubusercontent.com/90182043/149303867-104cc34a-0300-4eb2-b3f0-874e1665fa47.PNG)

> 
>> ### Top 3 Sales In 2020  
>> `SELECT product_code, sales_amount
FROM transactions
WHERE sales_amount NOT BETWEEN -1 AND 0
AND order_date BETWEEN '2020-01-01' AND '2020-12-31'
ORDER BY sales_amount DESC
LIMIT 3;`
>> 
>> ![top 3 sales in 2020](https://user-images.githubusercontent.com/90182043/149307164-8bd73726-0653-49d1-8de3-4e0f7f1e5429.PNG)
> 
>> ### Bottom 3 Sales In 2020  
>> `SELECT product_code, sales_amount
FROM transactions
WHERE sales_amount NOT BETWEEN -1 AND 0
AND order_date BETWEEN '2020-01-01' AND '2020-12-31'
ORDER BY sales_amount
LIMIT 3;`
>> 
>> ![bottom 3 sales in 2020](https://user-images.githubusercontent.com/90182043/149307242-ee187da5-5253-4ea3-aa52-1acaa3307ad4.PNG)

```
check
```
