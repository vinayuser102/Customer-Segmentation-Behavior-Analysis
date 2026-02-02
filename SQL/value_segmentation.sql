-- value_seggmentation.sql
-- Purpose: Segment customers into high , medium and Low value based on total revenue

with customer_revenue as (select customer_id, sum (order_value_inr) as total_revenue from orders group by customer_id),
value_segments as (select customer_id,total_revenue,ntile(3) over (order by total_revenue desc)as value_bucket from customer_revenue)
select customer_id , total_revenue,
	case 
		when value_bucket = 1 then 'High Value'
		when value_bucket =2 then 'medium Value'
		else 'Low Value'
		end as value_segment
	from value_segments
	order by total_revenue desc;