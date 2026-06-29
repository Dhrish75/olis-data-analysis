/*select * from product_category_name_translation*/
SELECT
  COUNT(DISTINCT oi.order_id) AS orders,
  round(sum(oi.price)) as total_value,
  pt.product_category_name_english
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
join product_category_name_translation pt on p.product_category_name = pt.product_category_name
group by pt.product_category_name_english
order by total_value desc


/*Add RANK() to compare revenue rank vs review rank*/
SELECT
  t.product_category_name_english AS category,
  COUNT(DISTINCT oi.order_id) AS orders,
  ROUND(SUM(oi.price)::NUMERIC, 2) AS revenue,
  ROUND(AVG(r.review_score)::NUMERIC, 2) AS avg_review,
  RANK() OVER (ORDER BY SUM(oi.price) DESC) AS revenue_rank,
  RANK() OVER (ORDER BY AVG(r.review_score) DESC) AS review_rank
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
JOIN product_category_name_translation t ON p.product_category_name = t.product_category_name
JOIN order_reviews r ON oi.order_id = r.order_id
GROUP BY t.product_category_name_english
HAVING COUNT(DISTINCT oi.order_id) > 50
ORDER BY revenue DESC
LIMIT 20;