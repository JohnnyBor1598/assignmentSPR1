-- TODO: This query will return a table with the top 10 least revenue categories 
-- in English, the number of orders and their total revenue. The first column 
-- will be Category, that will contain the top 10 least revenue categories; the 
-- second one will be Num_order, with the total amount of orders of each 
-- category; and the last one will be Revenue, with the total revenue of each 
-- catgory.
-- HINT: All orders should have a delivered status and the Category and actual 
-- delivery date should be not null.
select 
pcnt.product_category_name_english as Category,
count(distinct oo.order_id) as Num_order,
sum(oop.payment_value) as Revenue
from product_category_name_translation pcnt
inner join olist_products op on op.product_category_name = pcnt.product_category_name 
inner join olist_order_items ooi on ooi.product_id = op.product_id 
inner join olist_orders oo on oo.order_id = ooi.order_id 
inner join olist_order_payments oop on oop.order_id = oo.order_id 
where oo.order_status = 'delivered'
and op.product_category_name is not null
and pcnt.product_category_name_english is not null
and oo.order_delivered_customer_date is not null
group by pcnt.product_category_name_english
order by Revenue asc
limit 10;

