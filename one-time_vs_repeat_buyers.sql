/* One time and Repeat Buyers */
with cus_orders as (
select c.customer_unique_id, count(o.order_id) as no_of_orders
from customers_dataset c
join orders o on c.customer_id = o.customer_id
where order_status = 'delivered'
group by c.customer_unique_id 
order by no_of_orders desc
)   

select
case
when no_of_orders = 1 then 'one-time'
else 'repeat'
end as segment, 
count(customer_unique_id) as customers
from cus_orders
group by segment


/*Add revenue per segment*/
WITH customer_orders AS (
  SELECT
    c.customer_unique_id,
    COUNT(o.order_id) AS order_count,
    ROUND(SUM(p.payment_value)::NUMERIC, 2) AS total_spent
  FROM customers_dataset c
  JOIN orders o ON c.customer_id = o.customer_id
  JOIN order_payments p ON o.order_id = p.order_id
  WHERE o.order_status = 'delivered'
  GROUP BY c.customer_unique_id
)
SELECT
  CASE
    WHEN order_count = 1 THEN 'One-time'
    ELSE 'Repeat'
  END AS segment,
  COUNT(*) AS customers,
  ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS customer_pct,
  ROUND(SUM(total_spent)::NUMERIC, 2) AS total_revenue,
  ROUND(100.0 * SUM(total_spent) / SUM(SUM(total_spent)) OVER (), 2) AS revenue_pct
FROM customer_orders
GROUP BY 1;