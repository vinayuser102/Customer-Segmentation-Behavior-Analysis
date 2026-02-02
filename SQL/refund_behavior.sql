-- refund_behavior.sql
-- Purpose: Segment cusmtomers into refund risk groups based on historical refund behavior 

WITH customer_refunds AS (
    SELECT
        customer_id,
        COUNT(*) AS total_orders,
        SUM(CASE WHEN refund_requested = 'Yes' THEN 1 ELSE 0 END) AS refund_orders,
        ROUND(
            SUM(CASE WHEN refund_requested = 'Yes' THEN 1 ELSE 0 END) * 1.0
            / COUNT(*),
            2
        ) AS refund_rate
    FROM orders
    GROUP BY customer_id
),
refund_segments AS (
    SELECT
        customer_id,
        total_orders,
        refund_orders,
        refund_rate,
        NTILE(3) OVER (ORDER BY refund_rate DESC) AS refund_bucket
    FROM customer_refunds
)
SELECT
    customer_id,
    total_orders,
    refund_orders,
    refund_rate,
    CASE
        WHEN refund_bucket = 1 THEN 'High Refund Risk'
        WHEN refund_bucket = 2 THEN 'Medium Refund Risk'
        ELSE 'Low Refund Risk'
    END AS refund_segment
FROM refund_segments
ORDER BY refund_rate DESC;