-- Count orders by status
SELECT 
    order_status,
    COUNT(*) AS order_count
FROM olist_orders_dataset
GROUP BY order_status
ORDER BY order_count DESC;

-- Orders per month
SELECT 
    SUBSTR(order_purchase_timestamp, 1, 7) AS year_month,
    COUNT(*) AS order_count
FROM olist_orders_dataset
WHERE order_status = 'delivered'
GROUP BY year_month
ORDER BY year_month;

-- Average delivery time in days
SELECT 
    ROUND(AVG(
        JULIANDAY(order_delivered_customer_date) - 
        JULIANDAY(order_purchase_timestamp)
    ), 1) AS avg_delivery_days,
    
    ROUND(MIN(
        JULIANDAY(order_delivered_customer_date) - 
        JULIANDAY(order_purchase_timestamp)
    ), 1) AS min_delivery_days,
    
    ROUND(MAX(
        JULIANDAY(order_delivered_customer_date) - 
        JULIANDAY(order_purchase_timestamp)
    ), 1) AS max_delivery_days

FROM olist_orders_dataset
WHERE order_delivered_customer_date IS NOT NULL;

-- Average delivery time by review score
SELECT 
    r.review_score,
    COUNT(*) AS order_count,
    ROUND(AVG(
        JULIANDAY(o.order_delivered_customer_date) - 
        JULIANDAY(o.order_purchase_timestamp)
    ), 1) AS avg_delivery_days
FROM olist_orders_dataset o
JOIN olist_order_reviews_dataset r ON o.order_id = r.order_id
WHERE o.order_delivered_customer_date IS NOT NULL
GROUP BY r.review_score
ORDER BY r.review_score;
