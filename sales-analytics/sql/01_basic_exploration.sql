-- ========================================
-- DAY 3: BASIC SQL EXPLORATION (OLIST SALES)
-- Database: olist_sales
-- Author: Rayif
-- ========================================

USE olist_sales;

-- ========================================
-- 1. CHECK TABLE COUNTS
-- ========================================

SELECT 'orders' AS table_name, COUNT(*) AS row_count FROM orders
UNION ALL
SELECT 'customers', COUNT(*) FROM customers
UNION ALL
SELECT 'order_items', COUNT(*) FROM order_items
UNION ALL
SELECT 'products', COUNT(*) FROM products
UNION ALL
SELECT 'payments', COUNT(*) FROM payments
UNION ALL
SELECT 'reviews', COUNT(*) FROM reviews
UNION ALL
SELECT 'geolocation', COUNT(*) FROM geolocation
UNION ALL
SELECT 'sellers', COUNT(*) FROM sellers
UNION ALL
SELECT 'product_category_name_translation', COUNT(*) FROM product_category_name_translation;

-- ========================================
-- 2. SAMPLE ROWS FROM EACH TABLE
-- ========================================

SELECT * FROM orders LIMIT 10;
SELECT * FROM customers LIMIT 10;
SELECT * FROM order_items LIMIT 10;
SELECT * FROM products LIMIT 10;
SELECT * FROM payments LIMIT 10;
SELECT * FROM reviews LIMIT 10;
SELECT * FROM geolocation LIMIT 10;
SELECT * FROM sellers LIMIT 10;
SELECT * FROM product_category_name_translation LIMIT 10;

-- ========================================
-- 3. CHECK FOR NULLS IN KEY COLUMNS
-- ========================================

-- Orders
SELECT 
  SUM(order_id IS NULL) AS null_order_id,
  SUM(customer_id IS NULL) AS null_customer_id,
  SUM(order_status IS NULL) AS null_order_status
FROM orders;

-- Customers
SELECT
  SUM(customer_id IS NULL) AS null_customer_id,
  SUM(customer_unique_id IS NULL) AS null_unique_id
FROM customers;

-- Order Items
SELECT
  SUM(order_id IS NULL) AS null_order_id,
  SUM(product_id IS NULL) AS null_product_id
FROM order_items;

-- ========================================
-- 4. BASIC METRICS
-- ========================================

-- Total orders
SELECT COUNT(*) AS total_orders FROM orders;

-- Total customers
SELECT COUNT(*) AS total_customers FROM customers;

-- Total products
SELECT COUNT(*) AS total_products FROM products;

-- Total sellers
SELECT COUNT(*) AS total_sellers FROM sellers;

-- Total revenue (from payments)
SELECT ROUND(SUM(payment_value), 2) AS total_revenue
FROM payments;

-- ========================================
-- 5. ORDER STATUS BREAKDOWN
-- ========================================

SELECT 
  order_status,
  COUNT(*) AS total
FROM orders
GROUP BY order_status
ORDER BY total DESC;

-- ========================================
-- 6. TOP 10 MOST SOLD PRODUCTS
-- ========================================

SELECT 
  product_id,
  COUNT(*) AS total_items_sold
FROM order_items
GROUP BY product_id
ORDER BY total_items_sold DESC
LIMIT 10;

-- ========================================
-- 7. PAYMENT TYPE DISTRIBUTION
-- ========================================

SELECT 
  payment_type,
  COUNT(*) AS total
FROM payments
GROUP BY payment_type
ORDER BY total DESC;

-- ========================================
-- END OF FILE
-- ========================================
