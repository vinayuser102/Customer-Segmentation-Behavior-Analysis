-- customer_overview
-- purpose: Aggregate orderlevel data into customer level behavior metrics

select customer_id,
count(*) as total_orders,
sum(order_value_inr) as total_revenue,
round(avg(order_value_inr),2) as avg_order_value,
round(sum(case when refund_requested = 'Yes' then 1 else 0 end )*1.0/count(*),2) as refund_rate,
round(avg(service_rating),2) as avg_servive_rating,
sum(case when delivery_delay ='Yes' then 1 else 0 end)as delayed_orders
from orders
group by customer_id;