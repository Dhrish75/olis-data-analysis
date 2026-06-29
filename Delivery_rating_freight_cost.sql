/* Deliveries and freight cost affecting the rating*/
SELECT
  CASE
    WHEN o.order_delivered_customer_date::TIMESTAMP <= o.order_estimated_delivery_date::TIMESTAMP 
      THEN 'On-time'
    WHEN o.order_delivered_customer_date::TIMESTAMP <= o.order_estimated_delivery_date::TIMESTAMP + INTERVAL '3 days' 
      THEN 'Slightly Late (1-3d)'
    WHEN o.order_delivered_customer_date::TIMESTAMP <= o.order_estimated_delivery_date::TIMESTAMP + INTERVAL '7 days' 
      THEN 'Late (4-7d)'
    ELSE 'Very Late (7d+)'
  END AS delivery_bucket,
  COUNT(*) AS orders,
  ROUND(AVG(r.review_score)::NUMERIC, 2) AS avg_review
FROM orders o
JOIN order_reviews r USING (order_id)
WHERE o.order_status = 'delivered'
  AND o.order_delivered_customer_date IS NOT NULL
GROUP BY 1
ORDER BY avg_review DESC;