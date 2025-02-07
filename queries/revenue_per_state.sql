-- TODO: This query will return a table with two columns; customer_state, and 
-- Revenue. The first one will have the letters that identify the top 10 states 
-- with most revenue and the second one the total revenue of each.
-- HINT: All orders should have a delivered status and the actual delivery date 
-- should be not null. 
select oc.customer_state, sum(oop.payment_value) as Revenue
from olist_customers oc
inner join olist_orders oo on oo.customer_id = oc.customer_id 
inner join olist_order_payments oop  on oo.order_id = oop.order_id
where oo.order_status = 'delivered'
and   oo.order_delivered_customer_date is not null
group by customer_state 
order by Revenue desc
limit 10;