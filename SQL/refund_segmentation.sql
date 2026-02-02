-- refund_segmentation.sql
-- Purpose: Segment customers based on refund behavior

CREATE VIEW refund_segments AS
SELECT
    customer_id,
    refund_rate,
    CASE
        WHEN refund_bucket = 1 THEN 'High Refund Risk'
        WHEN refund_bucket = 2 THEN 'Medium Refund Risk'
        ELSE 'Low Refund Risk'
    END AS refund_segment
FROM (
    SELECT
        customer_id,
        ROUND(
            SUM(CASE WHEN refund_requested = 'Yes' THEN 1 ELSE 0 END)::numeric
            / COUNT(*),
            2
        ) AS refund_rate,
        NTILE(3) OVER (
            ORDER BY
                SUM(CASE WHEN refund_requested = 'Yes' THEN 1 ELSE 0 END)::numeric
                / COUNT(*) DESC
        ) AS refund_bucket
    FROM orders
    GROUP BY customer_id
) r;