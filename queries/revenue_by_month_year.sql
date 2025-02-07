-- TODO: This query will return a table with the revenue by month and year. It
-- will have different columns: month_no, with the month numbers going from 01
-- to 12; month, with the 3 first letters of each month (e.g. Jan, Feb);
-- Year2016, with the revenue per month of 2016 (0.00 if it doesn't exist);
-- Year2017, with the revenue per month of 2017 (0.00 if it doesn't exist) and
-- Year2018, with the revenue per month of 2018 (0.00 if it doesn't exist).
WITH
  delivered_orders as (
    select
    oor.order_id,
    oor.order_delivered_customer_date
    from olist_orders oor
    where oor.order_delivered_customer_date is not null
    and oor.order_status = 'delivered'
  ),
  
  order_payments as (
    select
    oop.order_id,
    min(oop.payment_value) AS payment_value
    from olist_order_payments oop
    group by oop.order_id
  )
  
select 
STRFTIME('%m', oo.order_delivered_customer_date) as month_no,
case STRFTIME('%m', oo.order_delivered_customer_date)
   when '01' then 'Jan'
   when '02' then 'Feb'
   when '03' then 'Mar'
   when '04' then 'Apr'
   when '05' then 'May'
   when '06' then 'Jun'
   when '07' then 'Jul'
   when '08' then 'Aug'
   when '09' then 'Sep'
   when '10' then 'Oct'
   when '11' then 'Nov'
   when '12' then 'Dec'
end as month,
SUM(case when STRFTIME('%Y', oo.order_delivered_customer_date) = '2016' then op.payment_value else 0.00 end) as Year2016,
SUM(case when STRFTIME('%Y', oo.order_delivered_customer_date) = '2017' then op.payment_value else 0.00 end) as Year2017,
SUM(case when STRFTIME('%Y', oo.order_delivered_customer_date) = '2018' then op.payment_value else 0.00 end) as Year2018
from delivered_orders oo
join order_payments op on oo.order_id = op.order_id
group by month_no
order by month_no;