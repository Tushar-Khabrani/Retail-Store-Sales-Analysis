select sum(price * quantity) as revenue
from clean_data;
select round(avg(revenue), 2) as avg_order_value from clean_data;
select count(*) as total_orders from clean_data;
select count(distinct customer) as total_customers from clean_data;
select sum(quantity) as total_items from clean_data;
select count(*) as repeat_customers
from (select customer
from clean_data group by customer having count(order_id) > 1) t;
select 
product,
sum(revenue) as total_revenue
from clean_data group by product order by total_revenue desc;
with filled as (select coalesce(date, (select min(c2.date) from clean_data c2
where c2.date is not null and c2.order_id > c1.order_id)) as effective_date,
revenue
from clean_data c1)
select month(effective_date) as month_num ,
monthname(effective_date) as month_name, sum(revenue) as total_sales
from filled
where effective_date is not null
group by month_num, month_name order by total_sales;
with filled as (select coalesce(date, (select min(c2.date) from clean_data c2 
where c2.date is not null and c2.order_id > c1.order_id)) as effective_date,
revenue
from clean_data c1)
select date_format(effective_date, '%Y-%m') as month,
sum(revenue) as total_sales
from filled
where effective_date is not null group by month order by month asc;
select category,
sum(revenue) as total_revenue,
round(sum(revenue) * 100.0 / (select sum(revenue) from clean_data), 2) as pct_share
from clean_data
group by category order by total_revenue desc;
select 
customer,
sum(revenue) as total_spent,
count(order_id) as total_orders
from clean_data group by customer order by total_spent desc;
select payment,
count(*) as total_orders,sum(revenue) as total_revenue,
round(sum(revenue) * 100.0 / (select sum(revenue) from clean_data), 2) as pct_share
from clean_data
group by payment order by total_revenue desc;
select city,
count(*) as total_orders,sum(revenue) as total_revenue
from clean_data
group by city order by total_revenue desc;
with filled as (select coalesce(date, (select min(c2.date) from clean_data c2
where c2.date is not null and c2.order_id > c1.order_id)) as effective_date,
revenue
from clean_data c1)
select effective_date as date, 
sum(revenue) as daily_sales
from filled
where effective_date is not null
group by effective_date order by daily_sales desc;