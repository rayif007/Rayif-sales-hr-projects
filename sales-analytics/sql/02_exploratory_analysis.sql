-- =====================================================
-- 02_exploratory_analysis.sql
-- Olist Sales Analytics - Exploratory SQL Analysis
-- Database: olist_sales
-- =====================================================

USE olist_sales;

-- =====================================================
-- 1. SANITY CHECKS AND TABLE OVERVIEW
-- =====================================================

-- 1.1 Row counts for all core tables
SELECT 'orders' AS table_name, COUNT(*) AS row_count FROM orders
UNION ALL SELECT 'customers', COUNT(*) FROM customers
UNION ALL SELECT 'order_items', COUNT(*) FROM order_items
UNION ALL SELECT 'products', COUNT(*) FROM products
UNION ALL SELECT 'payments', COUNT(*) FROM payments
UNION ALL SELECT 'reviews', COUNT(*) FROM reviews
UNION ALL SELECT 'geolocation', COUNT(*) FROM geolocation
UNION ALL SELECT 'sellers', COUNT(*) FROM sellers
UNION ALL SELECT 'product_category_name_translation', COUNT(*) FROM product_category_name_translation;

-- 1.2 Sample rows from each table (for manual inspection)
SELECT * FROM orders LIMIT 10;
SELECT * FROM customers LIMIT 10;
SELECT * FROM order_items LIMIT 10;
SELECT * FROM products LIMIT 10;
SELECT * FROM payments LIMIT 10;
SELECT * FROM reviews LIMIT 10;
SELECT * FROM geolocation LIMIT 10;
SELECT * FROM sellers LIMIT 10;
SELECT * FROM product_category_name_translation LIMIT 10;

-- 1.3 Basic null checks on key fields

-- Orders: check nulls in core columns
SELECT 
    SUM(order_id IS NULL) AS null_order_id,
    SUM(customer_id IS NULL) AS null_customer_id,
    SUM(order_status IS NULL) AS null_order_status,
    SUM(order_purchase_timestamp IS NULL) AS null_purchase_ts
FROM orders;

-- Customers: check nulls in ids
SELECT
    SUM(customer_id IS NULL) AS null_customer_id,
    SUM(customer_unique_id IS NULL) AS null_unique_id
FROM customers;

-- Order items: check nulls in main keys
SELECT
    SUM(order_id IS NULL) AS null_order_id,
    SUM(product_id IS NULL) AS null_product_id,
    SUM(seller_id IS NULL) AS null_seller_id
FROM order_items;

-- =====================================================
-- 2. TIME SERIES ANALYSIS (ORDERS AND REVENUE OVER TIME)
-- =====================================================

-- 2.1 Monthly order volume
SELECT
    DATE_FORMAT(order_purchase_timestamp, '%Y-%m') AS month,
    COUNT(*) AS total_orders
FROM orders
GROUP BY month
ORDER BY month;

-- 2.2 Daily order volume (optional, for more granular charts)
SELECT
    DATE(order_purchase_timestamp) AS order_date,
    COUNT(*) AS total_orders
FROM orders
GROUP BY order_date
ORDER BY order_date;

-- 2.3 Monthly revenue (using payments)
SELECT
    DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m') AS month,
    ROUND(SUM(p.payment_value), 2) AS monthly_revenue
FROM orders o
JOIN payments p ON o.order_id = p.order_id
GROUP BY month
ORDER BY month;

-- 2.4 Monthly average order value (AOV)
SELECT
    DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m') AS month,
    ROUND(SUM(p.payment_value), 2) AS monthly_revenue,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(p.payment_value) / COUNT(DISTINCT o.order_id), 2) AS avg_order_value
FROM orders o
JOIN payments p ON o.order_id = p.order_id
GROUP BY month
ORDER BY month;

-- =====================================================
-- 3. CUSTOMER ANALYSIS
-- =====================================================

-- 3.1 Total unique customers
SELECT COUNT(DISTINCT customer_id) AS unique_customers
FROM customers;

-- 3.2 Customers by state
SELECT 
    customer_state,
    COUNT(*) AS total_customers
FROM customers
GROUP BY customer_state
ORDER BY total_customers DESC;

-- 3.3 Top 20 customer cities by volume
SELECT
    customer_city,
    COUNT(*) AS total_customers
FROM customers
GROUP BY customer_city
ORDER BY total_customers DESC
LIMIT 20;

-- =====================================================
-- 4. SELLER ANALYSIS
-- =====================================================

-- 4.1 Total sellers
SELECT COUNT(*) AS total_sellers
FROM sellers;

-- 4.2 Sellers by state
SELECT
    seller_state,
    COUNT(*) AS total_sellers
FROM sellers
GROUP BY seller_state
ORDER BY total_sellers DESC;

-- 4.3 Top 20 seller cities by count
SELECT
    seller_city,
    COUNT(*) AS total_sellers
FROM sellers
GROUP BY seller_city
ORDER BY total_sellers DESC
LIMIT 20;

-- 4.4 Top 10 sellers by revenue
SELECT 
    s.seller_id,
    ROUND(SUM(oi.price + oi.freight_value), 2) AS total_revenue,
    COUNT(*) AS items_sold
FROM sellers s
JOIN order_items oi ON s.seller_id = oi.seller_id
GROUP BY s.seller_id
ORDER BY total_revenue DESC
LIMIT 10;

-- =====================================================
-- 5. PRODUCT AND CATEGORY ANALYSIS
-- =====================================================

-- 5.1 Total products
SELECT COUNT(*) AS total_products
FROM products;

-- 5.2 Product count by raw category name
SELECT
    product_category_name,
    COUNT(*) AS total_products
FROM products
GROUP BY product_category_name
ORDER BY total_products DESC;

-- 5.3 Sample mapping of category to English name
SELECT 
    p.product_category_name,
    t.product_category_name_english
FROM products p
LEFT JOIN product_category_name_translation t
    ON p.product_category_name = t.product_category_name
LIMIT 20;

-- 5.4 Top 10 categories by revenue
SELECT 
    COALESCE(t.product_category_name_english, p.product_category_name) AS category,
    ROUND(SUM(oi.price + oi.freight_value), 2) AS total_revenue
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
LEFT JOIN product_category_name_translation t
    ON p.product_category_name = t.product_category_name
GROUP BY category
ORDER BY total_revenue DESC
LIMIT 10;

-- 5.5 Top 10 categories by items sold
SELECT 
    COALESCE(t.product_category_name_english, p.product_category_name) AS category,
    COUNT(*) AS items_sold
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
LEFT JOIN product_category_name_translation t
    ON p.product_category_name = t.product_category_name
GROUP BY category
ORDER BY items_sold DESC
LIMIT 10;

-- =====================================================
-- 6. PAYMENT AND REVENUE ANALYSIS
-- =====================================================

-- 6.1 Payment type distribution
SELECT 
    payment_type,
    COUNT(*) AS total_transactions,
    ROUND(SUM(payment_value), 2) AS total_value
FROM payments
GROUP BY payment_type
ORDER BY total_transactions DESC;

-- 6.2 Payment installments distribution
SELECT
    payment_installments,
    COUNT(*) AS total_orders
FROM payments
GROUP BY payment_installments
ORDER BY payment_installments;

-- 6.3 Total revenue
SELECT 
    ROUND(SUM(payment_value), 2) AS total_revenue
FROM payments;

-- 6.4 Revenue by customer state
SELECT
    c.customer_state,
    ROUND(SUM(p.payment_value), 2) AS total_revenue
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN payments p ON o.order_id = p.order_id
GROUP BY c.customer_state
ORDER BY total_revenue DESC;

-- =====================================================
-- 7. DELIVERY (LOGISTICS) ANALYSIS
-- =====================================================

-- 7.1 Average delivery time (purchase to customer delivery)
SELECT 
    ROUND(AVG(DATEDIFF(order_delivered_customer_date, order_purchase_timestamp)), 2) 
        AS avg_delivery_days
FROM orders
WHERE order_delivered_customer_date IS NOT NULL;

-- 7.2 Average delay vs estimated date
SELECT 
    ROUND(AVG(
        DATEDIFF(order_delivered_customer_date, order_estimated_delivery_date)
    ), 2) AS avg_delay_days
FROM orders
WHERE order_delivered_customer_date IS NOT NULL;

-- 7.3 Top 10 slowest deliveries
SELECT 
    order_id,
    DATEDIFF(order_delivered_customer_date, order_purchase_timestamp) AS delivery_days
FROM orders
WHERE order_delivered_customer_date IS NOT NULL
ORDER BY delivery_days DESC
LIMIT 10;

-- 7.4 Average delivery time by customer state
SELECT 
    c.customer_state,
    ROUND(AVG(DATEDIFF(o.order_delivered_customer_date, o.order_purchase_timestamp)), 2) 
        AS avg_delivery_days
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
WHERE o.order_delivered_customer_date IS NOT NULL
GROUP BY c.customer_state
ORDER BY avg_delivery_days DESC;

-- 7.5 On-time vs late deliveries
SELECT
    SUM(order_delivered_customer_date <= order_estimated_delivery_date) AS on_time_deliveries,
    SUM(order_delivered_customer_date > order_estimated_delivery_date) AS late_deliveries
FROM orders
WHERE order_delivered_customer_date IS NOT NULL;

-- =====================================================
-- 8. REVIEW (CUSTOMER SATISFACTION) ANALYSIS
-- =====================================================

-- 8.1 Review score distribution
SELECT 
    review_score,
    COUNT(*) AS total_reviews
FROM reviews
GROUP BY review_score
ORDER BY review_score DESC;

-- 8.2 Average review score
SELECT 
    ROUND(AVG(review_score), 2) AS avg_review_score
FROM reviews;

-- 8.3 Average review score by order status
SELECT 
    o.order_status,
    ROUND(AVG(r.review_score), 2) AS avg_review_score,
    COUNT(*) AS total_reviews
FROM reviews r
JOIN orders o ON r.order_id = o.order_id
GROUP BY o.order_status
ORDER BY avg_review_score DESC;

-- 8.4 Relationship between delivery delay and review score
SELECT 
    r.review_score,
    ROUND(AVG(DATEDIFF(o.order_delivered_customer_date, o.order_estimated_delivery_date)), 2)
        AS avg_delay_days
FROM reviews r
JOIN orders o ON r.order_id = o.order_id
WHERE o.order_delivered_customer_date IS NOT NULL
GROUP BY r.review_score
ORDER BY r.review_score DESC;

-- 8.5 Top 10 categories by average review score (with review volume)
SELECT 
    COALESCE(t.product_category_name_english, p.product_category_name) AS category,
    ROUND(AVG(r.review_score), 2) AS avg_score,
    COUNT(*) AS total_reviews
FROM reviews r
JOIN order_items oi ON r.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
LEFT JOIN product_category_name_translation t
    ON p.product_category_name = t.product_category_name
GROUP BY category
ORDER BY avg_score DESC, total_reviews DESC
LIMIT 10;

-- =====================================================
-- END OF FILE
-- =====================================================
