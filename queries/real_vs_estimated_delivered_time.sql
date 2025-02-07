-- TODO: This query will return a table with the differences between the real 
-- and estimated delivery times by month and year. It will have different 
-- columns: month_no, with the month numbers going from 01 to 12; month, with 
-- the 3 first letters of each month (e.g. Jan, Feb); Year2016_real_time, with 
-- the average delivery time per month of 2016 (NaN if it doesn't exist); 
-- Year2017_real_time, with the average delivery time per month of 2017 (NaN if 
-- it doesn't exist); Year2018_real_time, with the average delivery time per 
-- month of 2018 (NaN if it doesn't exist); Year2016_estimated_time, with the 
-- average estimated delivery time per month of 2016 (NaN if it doesn't exist); 
-- Year2017_estimated_time, with the average estimated delivery time per month 
-- of 2017 (NaN if it doesn't exist) and Year2018_estimated_time, with the 
-- average estimated delivery time per month of 2018 (NaN if it doesn't exist).
-- HINTS
-- 1. You can use the julianday function to convert a date to a number.
-- 2. order_status == 'delivered' AND order_delivered_customer_date IS NOT NULL
-- 3. Take distinct order_id.

WITH
  delivered_orders as (
    select
    STRFTIME('%m', oor.order_purchase_timestamp) as month_n,
    oor.order_id,
    JULIANDAY(oor.order_delivered_customer_date) - JULIANDAY(oor.order_purchase_timestamp) as real_delivery_time,
	JULIANDAY(oor.order_estimated_delivery_date) - JULIANDAY(oor.order_purchase_timestamp) as estimated_delivery_time,
	STRFTIME('%Y', oor.order_purchase_timestamp) as year,
	case STRFTIME('%m', oor.order_purchase_timestamp)
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
	end as month_n
    from olist_orders oor
    where oor.order_delivered_customer_date is not null
    and oor.order_status = 'delivered'
  )
select 
oo.month_n as month_no,
oo.month_n as month,
AVG(case when oo.year = '2016' then oo.real_delivery_time else null end) as Year2016_real_time,
AVG(case when oo.year = '2017' then oo.real_delivery_time else null end) as Year2017_real_time,
AVG(case when oo.year = '2018' then oo.real_delivery_time else null end) as Year2018_real_time,
AVG(case when oo.year = '2016' then oo.estimated_delivery_time else null end) as Year2016_estimated_time,
AVG(case when oo.year = '2017' then oo.estimated_delivery_time else null end) as Year2017_estimated_time,
AVG(case when oo.year = '2018' then oo.estimated_delivery_time else null end) as Year2018_estimated_time
from delivered_orders oo
group by month_no
order by month_no;