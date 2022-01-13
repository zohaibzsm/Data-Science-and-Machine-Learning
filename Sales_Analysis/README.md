## Data Analysis using SQL and Power Bi

> ### using SQL:
>> Distinct Products Sold In Mumbai  
>> `SELECT DISTINCT product_code 
FROM transactions
WHERE market_code = 'Mark002'
AND sales_amount NOT BETWEEN -1 AND 0;`
> 
>> Total Sales For Mumbai For In 2020 and 2019  
>> `SELECT SUM(sales_amount) AS 'Total Sales'
FROM transactions
WHERE sales_amount NOT BETWEEN -1 AND 0
AND market_code = 'Mark002'
AND order_date BETWEEN '2019-01-01' AND '2020-12-31';`
> 
>> Total Revenue In 2020  
>> `SELECT SUM(sales_amount)
FROM transactions
WHERE order_date BETWEEN '2020-01-01' AND '2020-12-31';`
> 
>> First 3 Months Revenue In 2020  
>> `SELECT SUM(sales_amount)
FROM transactions
WHERE order_date BETWEEN '2020-01-01' AND '2020-03-31';`
> 
>> Last Month Revenue For 2019  
>> `SELECT SUM(sales_amount)
FROM transactions
WHERE order_date BETWEEN '2019-12-01' AND '2019-12-31';`
> 
>> Top 5 Customers By Revenue  
>> `SELECT tr.customer_code, c.custmer_name, SUM(tr.sales_amount) AS Total_Amount
FROM customers AS c
JOIN transactions AS tr
ON tr.customer_code = c.customer_code
GROUP BY tr.customer_code
ORDER BY Total_Amount DESC
LIMIT 5;`
> 
>> Top 3 Sales In 2020  
>> `SELECT product_code, sales_amount
FROM transactions
WHERE sales_amount NOT BETWEEN -1 AND 0
AND order_date BETWEEN '2020-01-01' AND '2020-12-31'
ORDER BY sales_amount DESC
LIMIT 3;`
> 
>> Bottom 3 Sales In 2020  
>> `SELECT product_code, sales_amount
FROM transactions
WHERE sales_amount NOT BETWEEN -1 AND 0
AND order_date BETWEEN '2020-01-01' AND '2020-12-31'
ORDER BY sales_amount
LIMIT 3;`

```
check
```
