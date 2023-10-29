-- Расчет кумулятивной выручки
SELECT
    category,
    order_date,
    revenue,
    SUM(revenue) OVER(PARTITION BY category ORDER BY order_date) AS cumulative_revenue
FROM
    sales;
-- Расчет среднего чека
   SELECT
    category,
    order_date,
    revenue,
    cumulative_revenue / cumulative_orders AS average_check
FROM
    (
    SELECT
        category,
        order_date,
        revenue,
        SUM(revenue) OVER(PARTITION BY category ORDER BY order_date) AS cumulative_revenue,
        COUNT(*) OVER(PARTITION BY category ORDER BY order_date) AS cumulative_orders
    FROM
        sales
    ) AS subquery;
-- Определение даты максимального среднего чека
   SELECT
    category,
    max_avg_check_date,
    max_avg_check_value
FROM
    (
    SELECT
        category,
        order_date AS max_avg_check_date,
        average_check AS max_avg_check_value,
        RANK() OVER(PARTITION BY category ORDER BY average_check DESC) AS rank
    FROM
        (
        SELECT
            category,
            order_date,
            revenue,
            cumulative_revenue / cumulative_orders AS average_check
        FROM
            (
            SELECT
                category,
                order_date,
                revenue,
                SUM(revenue) OVER(PARTITION BY category ORDER BY order_date) AS cumulative_revenue,
                COUNT(*) OVER(PARTITION BY category ORDER BY order_date) AS cumulative_orders
            FROM
                sales
            ) AS subquery
        ) AS subquery2
    ) AS subquery3
WHERE
    rank = 1;
