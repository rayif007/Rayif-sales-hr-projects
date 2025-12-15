CREATE DATABASE sales_analytics;
USE sales_analytics;

CREATE DATABASE olist_sales;
USE olist_sales;
DROP DATABASE sales_analytics;



-- 1. ORDERS
CREATE TABLE orders (
    order_id                      VARCHAR(50) PRIMARY KEY,
    customer_id                   VARCHAR(50),
    order_status                  VARCHAR(20),
    order_purchase_timestamp      DATETIME,
    order_approved_at             DATETIME NULL,
    order_delivered_carrier_date  DATETIME NULL,
    order_delivered_customer_date DATETIME NULL,
    order_estimated_delivery_date DATETIME
);

-- 2. CUSTOMERS
CREATE TABLE customers (
    customer_id              VARCHAR(50) PRIMARY KEY,
    customer_unique_id       VARCHAR(50),
    customer_zip_code_prefix INT,
    customer_city            VARCHAR(100),
    customer_state           VARCHAR(5)
);

-- 3. ORDER_ITEMS
CREATE TABLE order_items (
    order_id            VARCHAR(50),
    order_item_id       INT,
    product_id          VARCHAR(50),
    seller_id           VARCHAR(50),
    shipping_limit_date DATETIME,
    price               DECIMAL(10,2),
    freight_value       DECIMAL(10,2),
    PRIMARY KEY (order_id, order_item_id)
);

-- 4. PRODUCTS
CREATE TABLE products (
    product_id                 VARCHAR(50) PRIMARY KEY,
    product_category_name      VARCHAR(100),
    product_name_lenght        INT,
    product_description_lenght INT,
    product_photos_qty         INT,
    product_weight_g           INT,
    product_length_cm          INT,
    product_height_cm          INT,
    product_width_cm           INT
);

-- 5. PAYMENTS
CREATE TABLE payments (
    order_id            VARCHAR(50),
    payment_sequential  INT,
    payment_type        VARCHAR(50),
    payment_installments INT,
    payment_value       DECIMAL(10,2)
);

-- 6. REVIEWS
CREATE TABLE reviews (
    review_id              VARCHAR(50) PRIMARY KEY,
    order_id               VARCHAR(50),
    review_score           INT,
    review_comment_title   TEXT,
    review_comment_message TEXT,
    review_creation_date   DATETIME,
    review_answer_timestamp DATETIME
);

-- 7. GEOLOCATION
CREATE TABLE geolocation (
    geolocation_zip_code_prefix INT,
    geolocation_lat             DECIMAL(10,6),
    geolocation_lng             DECIMAL(10,6),
    geolocation_city            VARCHAR(100),
    geolocation_state           VARCHAR(5)
);

-- 8. SELLERS
CREATE TABLE sellers (
    seller_id              VARCHAR(50) PRIMARY KEY,
    seller_zip_code_prefix INT,
    seller_city            VARCHAR(100),
    seller_state           VARCHAR(5)
);

-- 9. PRODUCT CATEGORY TRANSLATION
CREATE TABLE product_category_name_translation (
    product_category_name        VARCHAR(100) PRIMARY KEY,
    product_category_name_english VARCHAR(100)
);

USE olist_sales;

USE olist_sales;

-- verifying csv imports

SELECT COUNT(*) FROM product_category_name_translation;
SELECT * FROM product_category_name_translation LIMIT 5;

SELECT COUNT(*) FROM sellers;
SELECT * FROM sellers LIMIT 5;

USE olist_sales;

-- 1. ORDERS
CREATE TABLE IF NOT EXISTS orders (
    order_id                      VARCHAR(50) PRIMARY KEY,
    customer_id                   VARCHAR(50),
    order_status                  VARCHAR(20),
    order_purchase_timestamp      DATETIME,
    order_approved_at             DATETIME NULL,
    order_delivered_carrier_date  DATETIME NULL,
    order_delivered_customer_date DATETIME NULL,
    order_estimated_delivery_date DATETIME
);

-- 2. CUSTOMERS
CREATE TABLE IF NOT EXISTS customers (
    customer_id              VARCHAR(50) PRIMARY KEY,
    customer_unique_id       VARCHAR(50),
    customer_zip_code_prefix INT,
    customer_city            VARCHAR(100),
    customer_state           VARCHAR(5)
);

-- 3. ORDER_ITEMS
CREATE TABLE IF NOT EXISTS order_items (
    order_id            VARCHAR(50),
    order_item_id       INT,
    product_id          VARCHAR(50),
    seller_id           VARCHAR(50),
    shipping_limit_date DATETIME,
    price               DECIMAL(10,2),
    freight_value       DECIMAL(10,2),
    PRIMARY KEY (order_id, order_item_id)
);

-- 4. PRODUCTS
CREATE TABLE IF NOT EXISTS products (
    product_id                 VARCHAR(50) PRIMARY KEY,
    product_category_name      VARCHAR(100),
    product_name_lenght        INT,
    product_description_lenght INT,
    product_photos_qty         INT,
    product_weight_g           INT,
    product_length_cm          INT,
    product_height_cm          INT,
    product_width_cm           INT
);

-- 5. PAYMENTS
CREATE TABLE IF NOT EXISTS payments (
    order_id             VARCHAR(50),
    payment_sequential   INT,
    payment_type         VARCHAR(50),
    payment_installments INT,
    payment_value        DECIMAL(10,2)
);

-- 6. REVIEWS
CREATE TABLE IF NOT EXISTS reviews (
    review_id              VARCHAR(50) PRIMARY KEY,
    order_id               VARCHAR(50),
    review_score           INT,
    review_comment_title   VARCHAR(255),
    review_comment_message TEXT,
    review_creation_date   DATETIME,
    review_answer_timestamp DATETIME
);

-- 7. GEOLOCATION
CREATE TABLE IF NOT EXISTS geolocation (
    geolocation_zip_code_prefix INT,
    geolocation_lat             DECIMAL(10,6),
    geolocation_lng             DECIMAL(10,6),
    geolocation_city            VARCHAR(100),
    geolocation_state           VARCHAR(5)
);

/* 8. SELLERS and 9. PRODUCT_CATEGORY_NAME_TRANSLATION
   already exist, so we don't recreate them here.
*/

USE olist_sales;

DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS payments;
DROP TABLE IF EXISTS reviews;
DROP TABLE IF EXISTS geolocation;
DROP TABLE IF EXISTS sellers;
DROP TABLE IF EXISTS product_category_name_translation;

USE olist_sales;

-- 1. Orders
CREATE TABLE orders (
    order_id VARCHAR(50) PRIMARY KEY,
    customer_id VARCHAR(50),
    order_status VARCHAR(50),
    order_purchase_timestamp DATETIME,
    order_approved_at DATETIME,
    order_delivered_carrier_date DATETIME,
    order_delivered_customer_date DATETIME,
    order_estimated_delivery_date DATETIME
);

-- 2. Customers
CREATE TABLE customers (
    customer_id VARCHAR(50) PRIMARY KEY,
    customer_unique_id VARCHAR(50),
    customer_zip_code_prefix INT,
    customer_city VARCHAR(100),
    customer_state VARCHAR(5)
);

-- 3. Order Items
CREATE TABLE order_items (
    order_id VARCHAR(50),
    order_item_id INT,
    product_id VARCHAR(50),
    seller_id VARCHAR(50),
    shipping_limit_date DATETIME,
    price DECIMAL(10,2),
    freight_value DECIMAL(10,2)
);

-- 4. Products
CREATE TABLE products (
    product_id VARCHAR(50) PRIMARY KEY,
    product_category_name VARCHAR(100),
    product_name_length INT,
    product_description_length INT,
    product_photos_qty INT,
    product_weight_g INT,
    product_length_cm INT,
    product_height_cm INT,
    product_width_cm INT
);

-- 5. Payments
CREATE TABLE payments (
    order_id VARCHAR(50),
    payment_sequential INT,
    payment_type VARCHAR(50),
    payment_installments INT,
    payment_value DECIMAL(10,2)
);

-- 6. Reviews
CREATE TABLE reviews (
    review_id VARCHAR(50) PRIMARY KEY,
    order_id VARCHAR(50),
    review_score INT,
    review_comment_title VARCHAR(100),
    review_comment_message TEXT,
    review_creation_date DATETIME,
    review_answer_timestamp DATETIME
);

-- 7. Geolocation
CREATE TABLE geolocation (
    geolocation_zip_code_prefix INT,
    geolocation_lat FLOAT,
    geolocation_lng FLOAT,
    geolocation_city VARCHAR(100),
    geolocation_state VARCHAR(5)
);

-- 8. Sellers
CREATE TABLE sellers (
    seller_id VARCHAR(50) PRIMARY KEY,
    seller_zip_code_prefix INT,
    seller_city VARCHAR(100),
    seller_state VARCHAR(5)
);

-- 9. Product category translation
CREATE TABLE product_category_name_translation (
    product_category_name VARCHAR(100) PRIMARY KEY,
    product_category_name_english VARCHAR(100)
);

USE olist_sales;
SHOW TABLES;

USE olist_sales;

TRUNCATE TABLE geolocation;
TRUNCATE TABLE customers;

SET GLOBAL local_infile = 1;

USE olist_sales;

USE olist_sales;
SHOW TABLES;
SHOW VARIABLES LIKE 'secure_file_priv';


SELECT COUNT(*) FROM geolocation;

USE olist_sales;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/geolocation_clean.csv'
INTO TABLE geolocation
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(
  geolocation_zip_code_prefix,
  geolocation_lat,
  geolocation_lng,
  geolocation_city,
  geolocation_state
);


USE olist_sales;
SHOW TABLES; 

SELECT 
    'orders' AS table_name, COUNT(*) AS rows_count FROM orders
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

-- Part 2

USE olist_sales;
SHOW TABLES; 

SELECT DATE FORMAT(order_purchase_timestamp, '%y %m') AS year_month,
COUNT(*) AS total_orders
FROM orders
GROUP BY year_month
ORDER BY year_month;










