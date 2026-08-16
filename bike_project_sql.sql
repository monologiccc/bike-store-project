-- Анализ того, какие товары чаще всего покупают вместе

WITH pairs AS (
    SELECT a.order_id, a.product_id AS product_1, b.product_id AS product_2
    FROM order_items a
    JOIN order_items b
        ON a.order_id = b.order_id
        AND a.product_id < b.product_id
)
SELECT
    p1.product_name AS product_1,
    p2.product_name AS product_2,
    COUNT(*) AS times_bought_together
FROM pairs
JOIN products p1 ON pairs.product_1 = p1.product_id
JOIN products p2 ON pairs.product_2 = p2.product_id
GROUP BY pairs.product_1, pairs.product_2
ORDER BY times_bought_together DESC
LIMIT 10;

-- Расчет абсолютных значений выручки по месяцам и ее колебаний от месяца к месяцу

WITH monthly AS (
    SELECT
        strftime('%Y-%m', o.order_date) AS month,
        SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS revenue
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    WHERE o.order_date <= '2018-03-31'
    GROUP BY month
)
SELECT
    month,
    ROUND(revenue, 2) AS revenue,
    ROUND(SUM(revenue) OVER (ORDER BY month), 2) AS running_total,
    ROUND(
        100.0 * (revenue - LAG(revenue) OVER (ORDER BY month))
        / LAG(revenue) OVER (ORDER BY month),
    1) AS mom_growth_pct
FROM monthly
ORDER BY month;

-- Сводная таблица распределения выручки по магазинам и категориям товаров

SELECT
    s.store_name,
    ROUND(SUM(CASE WHEN c.category_name = 'Mountain Bikes'
        THEN oi.quantity * oi.list_price * (1 - oi.discount) ELSE 0 END), 0) AS mountain_bikes,
    ROUND(SUM(CASE WHEN c.category_name = 'Road Bikes'
        THEN oi.quantity * oi.list_price * (1 - oi.discount) ELSE 0 END), 0) AS road_bikes,
    ROUND(SUM(CASE WHEN c.category_name = 'Cruisers Bicycles'
        THEN oi.quantity * oi.list_price * (1 - oi.discount) ELSE 0 END), 0) AS cruisers,
    ROUND(SUM(oi.quantity * oi.list_price * (1 - oi.discount)), 0) AS total_revenue
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
JOIN categories c ON p.category_id = c.category_id
JOIN stores s ON o.store_id = s.store_id
GROUP BY s.store_name;