-- customer_action_matrix.sql
-- Purpose: Map customer value and refund risk to operational actions

SELECT
    v.customer_id,
    v.value_segment,
    r.refund_segment,
    CASE
        WHEN v.value_segment = 'High Value'
             AND r.refund_segment = 'Low Refund Risk'
            THEN 'Protect & Retain'

        WHEN v.value_segment = 'High Value'
             AND r.refund_segment = 'High Refund Risk'
            THEN 'Manage Carefully'

        WHEN v.value_segment = 'Low Value'
             AND r.refund_segment = 'High Refund Risk'
            THEN 'Deprioritize / Restrict'

        ELSE 'Standard Handling'
    END AS customer_action
FROM customer_segments v
JOIN refund_segments r
    ON v.customer_id = r.customer_id
ORDER BY customer_action;