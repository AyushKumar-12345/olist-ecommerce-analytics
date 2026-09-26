-- =====================================================================
-- OLIST BRAZILIAN E-COMMERCE ENTERPRISE MARKETPLACE ANALYTICS
-- Author: Ayush Kumar
-- =====================================================================

CREATE DATABASE IF NOT EXISTS olist_marketplace;
USE olist_marketplace;

-- 1. EXECUTIVE MARKETPLACE GMV & BASKET ECONOMICS
SELECT 
    COUNT(DISTINCT o.order_id) AS total_orders,
    COUNT(DISTINCT o.customer_id) AS unique_purchasers,
    CONCAT('R$ ', FORMAT(ROUND(SUM(oi.price), 2), 2)) AS gross_merchandise_value,
    CONCAT('R$ ', FORMAT(ROUND(SUM(oi.freight_value), 2), 2)) AS aggregate_freight_fees,
    CONCAT('R$ ', FORMAT(ROUND(AVG(oi.price), 2), 2)) AS mean_item_price,
    CONCAT('R$ ', FORMAT(ROUND(SUM(oi.price) / COUNT(DISTINCT o.order_id), 2), 2)) AS average_order_value
FROM cleaned_orders o
JOIN cleaned_order_items oi ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered';

-- 2. LOGISTICS SLA & TRANSIT LATENCY PERFORMANCE BY REGION
SELECT 
    c.customer_state,
    COUNT(DISTINCT o.order_id) AS order_volume,
    ROUND(AVG(DATEDIFF(o.order_delivered_customer_date, o.order_purchase_timestamp)), 1) AS avg_delivery_days,
    ROUND(AVG(DATEDIFF(o.order_estimated_delivery_date, o.order_delivered_customer_date)), 1) AS sla_buffer_days,
    ROUND(SUM(CASE WHEN o.order_delivered_customer_date > o.order_estimated_delivery_date THEN 1 ELSE 0 END) * 100.0 / COUNT(o.order_id), 2) AS delayed_delivery_rate_pct,
    ROUND(AVG(oi.freight_value), 2) AS mean_freight_cost
FROM cleaned_orders o
JOIN cleaned_customers c ON o.customer_id = c.customer_id
JOIN cleaned_order_items oi ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
  AND o.order_delivered_customer_date IS NOT NULL
GROUP BY c.customer_state
HAVING COUNT(DISTINCT o.order_id) >= 100
ORDER BY avg_delivery_days DESC;

-- 3. PARETO SELLER REVENUE CONCENTRATION & REPUTATION
WITH SellerSummary AS (
    SELECT 
        s.seller_id,
        s.seller_state,
        COUNT(DISTINCT oi.order_id) AS total_orders,
        SUM(oi.price) AS total_revenue,
        AVG(r.review_score) AS mean_rating,
        ROW_NUMBER() OVER (ORDER BY SUM(oi.price) DESC) AS revenue_rank,
        COUNT(*) OVER () AS total_sellers,
        SUM(SUM(oi.price)) OVER () AS global_revenue
    FROM cleaned_sellers s
    JOIN cleaned_order_items oi ON s.seller_id = oi.seller_id
    JOIN cleaned_orders o ON oi.order_id = o.order_id
    LEFT JOIN cleaned_reviews r ON o.order_id = r.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY s.seller_id, s.seller_state
)
SELECT 
    seller_id,
    seller_state,
    total_orders,
    CONCAT('R$ ', FORMAT(ROUND(total_revenue, 2), 2)) AS seller_gmv,
    ROUND(mean_rating, 2) AS seller_csat,
    ROUND((revenue_rank * 100.0 / total_sellers), 2) AS percentile_bracket,
    ROUND((SUM(total_revenue) OVER (ORDER BY revenue_rank) * 100.0 / global_revenue), 2) AS cumulative_gmv_share
FROM SellerSummary
WHERE revenue_rank <= 25;

-- 4. PAYMENT TYPE SPLIT & INSTALLMENT PENETRATION
SELECT 
    p.payment_type,
    COUNT(DISTINCT p.order_id) AS transaction_count,
    ROUND(COUNT(DISTINCT p.order_id) * 100.0 / SUM(COUNT(DISTINCT p.order_id)) OVER (), 2) AS payment_share_pct,
    CONCAT('R$ ', FORMAT(ROUND(SUM(p.payment_value), 2), 2)) AS total_processed_value,
    ROUND(AVG(p.payment_installments), 1) AS mean_installments
FROM cleaned_payments p
GROUP BY p.payment_type
ORDER BY SUM(p.payment_value) DESC;
