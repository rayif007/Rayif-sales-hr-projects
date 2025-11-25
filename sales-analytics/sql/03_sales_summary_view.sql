CREATE OR REPLACE VIEW vw_sales_summary AS
SELECT 
    o.order_id,
    o.customer_id,
    c.customer_city,
    c.customer_state,
    o.order_status,
    o.order_purchase_timestamp,
    o.order_approved_at,
    o.order_delivered_carrier_date,
    o.order_delivered_customer_date,
    o.order_estimated_delivery_date,
    
    p.payment_type,
    p.payment_installments,
    p.payment_value,

    r.review_score,
    r.review_comment_title,
    r.review_comment_message,
    r.review_creation_date,

    oi.order_item_id,
    oi.product_id,
    oi.seller_id,
    (oi.price + oi.freight_value) AS item_total,

    prod.product_category_name,
    COALESCE(t.product_category_name_english, prod.product_category_name) AS category_english,

    s.seller_city,
    s.seller_state
FROM orders o
LEFT JOIN customers c ON o.customer_id = c.customer_id
LEFT JOIN payments p ON o.order_id = p.order_id
LEFT JOIN reviews r ON o.order_id = r.order_id
LEFT JOIN order_items oi ON o.order_id = oi.order_id
LEFT JOIN products prod ON oi.product_id = prod.product_id
LEFT JOIN product_category_name_translation t 
       ON prod.product_category_name = t.product_category_name
LEFT JOIN sellers s ON oi.seller_id = s.seller_id;

SELECT * FROM vw_sales_summary LIMIT 20;
