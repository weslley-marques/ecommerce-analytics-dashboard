
SELECT COUNT(DISTINCT order_id) AS total_pedidos
FROM olist_orders_dataset;

SELECT COUNT(DISTINCT customer_unique_id) AS total_clientes
FROM olist_customers_dataset;

SELECT
    SUM(price) AS receita_total
FROM olist_order_items_dataset;

SELECT
    SUM(price) / COUNT(DISTINCT order_id) AS ticket_medio
FROM olist_order_items_dataset;

SELECT
    DATE_FORMAT(order_purchase_timestamp,'%Y-%m') AS mes,
    SUM(price) AS receita
FROM olist_orders_dataset o
JOIN olist_order_items_dataset oi
ON o.order_id = oi.order_id
GROUP BY mes
ORDER BY mes;

SELECT
    p.product_category_name,
    SUM(oi.price) AS receita_total
FROM olist_order_items_dataset oi
JOIN olist_products_dataset p
ON oi.product_id = p.product_id
GROUP BY p.product_category_name
ORDER BY receita_total DESC
LIMIT 10;

SELECT
    c.customer_state,
    COUNT(DISTINCT o.order_id) AS total_pedidos,
    SUM(oi.price) AS receita_total
FROM olist_orders_dataset o
JOIN olist_customers_dataset c
ON o.customer_id = c.customer_id
JOIN olist_order_items_dataset oi
ON o.order_id = oi.order_id
GROUP BY c.customer_state
ORDER BY receita_total DESC;

SELECT
    payment_type,
    SUM(payment_value) AS total_pago
FROM olist_order_payments_dataset
GROUP BY payment_type
ORDER BY total_pago DESC;

SELECT
    AVG(DATEDIFF(order_delivered_customer_date,
                 order_purchase_timestamp)) AS tempo_medio_entrega
FROM olist_orders_dataset
WHERE order_status = 'delivered';

SELECT
    c.customer_state,
    AVG(DATEDIFF(order_delivered_customer_date,
                 order_purchase_timestamp)) AS tempo_entrega
FROM olist_orders_dataset o
JOIN olist_customers_dataset c
ON o.customer_id = c.customer_id
WHERE order_status = 'delivered'
GROUP BY c.customer_state
ORDER BY tempo_entrega DESC;

SELECT
    COUNT(*) AS pedidos_atrasados
FROM olist_orders_dataset
WHERE order_status = 'delivered'
AND order_delivered_customer_date > order_estimated_delivery_date;

SELECT
    AVG(review_score) AS media_avaliacao
FROM olist_order_reviews_dataset;

SELECT
    CASE
        WHEN o.order_delivered_customer_date >
             o.order_estimated_delivery_date
        THEN 'Atrasado'
        ELSE 'No Prazo'
    END AS status_entrega,

    AVG(r.review_score) AS media_avaliacao

FROM olist_orders_dataset o
JOIN olist_order_reviews_dataset r
ON o.order_id = r.order_id

WHERE o.order_status = 'delivered'

GROUP BY status_entrega;