-- TO RUN: See .env
-- Query 1: List all of the users email addresses along with the total number of products they've purchased.
--   there may be users without purchases, be sure to include these.

SELECT users.email, COALESCE(SUM(sales.num_items),0) --COALESCE makes null values to zero
FROM users
LEFT JOIN sales ON users.id = sales.buyer_id --LEFT JOIN to join the users without items too
GROUP BY users.email; -- Group the items to the email

-- Query 2: What are the top three products by monetary value?
--   calculate the total value of all sales by product,
--   provide the product names and the total value of sales for each product (where possible)

SELECT products.title, ROUND(SUM(products.product_cost * COALESCE(sales.num_items, 0)), 2) AS Total_sales
FROM sales
JOIN products ON sales.product_id = products.id
GROUP BY products.title
ORDER BY Total_sales DESC
LIMIT 3;


-- Query 3: Which user was the top spender in December 2022?
--   provide their email address and phone number.

SELECT users.first_name, users.email, users.phone_number, Round(SUM(products.product_cost * sales.num_items),2) AS Total_sales_in_December_2022 -- query the details
FROM sales
JOIN users ON users.id = sales.buyer_id -- Join users and sales
JOIN products on products.id = sales.product_id -- Join products and sales
WHERE transaction_ts <= '2022-12-31' AND transaction_ts >= '2022-12-01' -- Set the date range
GROUP BY users.first_name, users.email, users.phone_number -- Group by the output
ORDER BY Total_sales_in_December_2022 DESC -- Order by the most to least of sales
LIMIT 1; -- Output only one person

\echo "ALT"

SELECT u.email, u.phone_number,
ROUND(SUM(COALESCE(s.num_items, 0) * p.product_cost), 2) AS total_spend
FROM sales s
JOIN users u ON u.id = s.buyer_id
JOIN products p ON p.id = s.product_id
WHERE s.transaction_ts >= '2022-12-01' AND s.transaction_ts <  '2023-01-01'
GROUP BY s.buyer_id, u.email, u.phone_number
ORDER BY total_spend DESC
LIMIT 1;