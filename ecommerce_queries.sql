-- Q1 — Total revenue per category (Delivered only)

SELECT p.category,
       ROUND(SUM(p.price * oi.quantity * (1 - oi.discount)), 2) AS total_revenue
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
WHERE o.status = 'Delivered'
GROUP BY p.category
ORDER BY total_revenue DESC;

-- Q2 — Top 3 customers by total spend

SELECT c.customer_name, c.city,
       ROUND(SUM(p.price * oi.quantity * (1 - oi.discount)), 2) AS total_spend
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
WHERE o.status = 'Delivered'
GROUP BY c.customer_id, c.customer_name, c.city
ORDER BY total_spend DESC
LIMIT 3;

-- Q3 — Monthly revenue trend 2023

SELECT MONTH(o.order_date) AS month,
       ROUND(SUM(p.price * oi.quantity * (1 - oi.discount)), 2) AS revenue
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
WHERE o.status = 'Delivered' AND YEAR(o.order_date) = 2023
GROUP BY MONTH(o.order_date)
ORDER BY month;

-- Q4 — First order, last order, total orders per customer

SELECT c.customer_name,
       MIN(o.order_date) AS first_order,
       MAX(o.order_date) AS last_order,
       COUNT(o.order_id) AS total_orders
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name;

-- Q5 — Revenue % by category using CTE

WITH category_rev AS (
  SELECT p.category,
         ROUND(SUM(p.price * oi.quantity * (1 - oi.discount)), 2) AS revenue
  FROM orders o
  JOIN order_items oi ON o.order_id = oi.order_id
  JOIN products p ON oi.product_id = p.product_id
  WHERE o.status = 'Delivered'
  GROUP BY p.category
)
SELECT category, revenue,
       ROUND(revenue / SUM(revenue) OVER () * 100, 2) AS pct_share
FROM category_rev
ORDER BY revenue DESC;

-- Q6 — Rank products by revenue

SELECT p.product_name, p.category,
       ROUND(SUM(p.price * oi.quantity * (1 - oi.discount)), 2) AS revenue,
       RANK() OVER (ORDER BY SUM(p.price * oi.quantity * (1 - oi.discount)) DESC) AS rnk
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
WHERE o.status = 'Delivered'
GROUP BY p.product_id, p.product_name, p.category;

-- Q7 — Customers with more than 1 Delivered order

SELECT c.customer_name, COUNT(o.order_id) AS delivered_orders
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
WHERE o.status = 'Delivered'
GROUP BY c.customer_id, c.customer_name
HAVING COUNT(o.order_id) > 1;

-- Q8 — Month-over-month revenue change using LAG

WITH monthly AS (
  SELECT MONTH(o.order_date) AS month,
         ROUND(SUM(p.price * oi.quantity * (1 - oi.discount)), 2) AS revenue
  FROM orders o
  JOIN order_items oi ON o.order_id = oi.order_id
  JOIN products p ON oi.product_id = p.product_id
  WHERE o.status = 'Delivered' AND YEAR(o.order_date) = 2023
  GROUP BY MONTH(o.order_date)
)
SELECT month, revenue,
       LAG(revenue, 1) OVER (ORDER BY month) AS prev_month_revenue,
       ROUND(revenue - LAG(revenue, 1) OVER (ORDER BY month), 2) AS mom_change
FROM monthly;

-- Q9 — Order value tiers using CASE WHEN

WITH order_totals AS (
  SELECT o.order_id, c.customer_name,
         ROUND(SUM(p.price * oi.quantity * (1 - oi.discount)), 2) AS order_value
  FROM orders o
  JOIN customers c ON o.customer_id = c.customer_id
  JOIN order_items oi ON o.order_id = oi.order_id
  JOIN products p ON oi.product_id = p.product_id
  WHERE o.status = 'Delivered'
  GROUP BY o.order_id, c.customer_name
)
SELECT order_id, customer_name, order_value,
       CASE
         WHEN order_value > 5000 THEN 'High Value'
         WHEN order_value BETWEEN 2000 AND 5000 THEN 'Medium Value'
         ELSE 'Low Value'
       END AS value_tier
FROM order_totals;

-- Q10 — Running total of revenue by order date

WITH order_rev AS (
  SELECT o.order_id, o.order_date,
         ROUND(SUM(p.price * oi.quantity * (1 - oi.discount)), 2) AS order_revenue
  FROM orders o
  JOIN order_items oi ON o.order_id = oi.order_id
  JOIN products p ON oi.product_id = p.product_id
  WHERE o.status = 'Delivered'
  GROUP BY o.order_id, o.order_date
)
SELECT order_id, order_date, order_revenue,
       ROUND(SUM(order_revenue) OVER (ORDER BY order_date), 2) AS running_total
FROM order_rev;