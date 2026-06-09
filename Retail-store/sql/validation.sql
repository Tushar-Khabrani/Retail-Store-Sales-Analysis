use target_data;
select*from raw_data;
select 
sum(order_id is null) as order_id_nulls,
sum(date is null) as date_nulls,
sum(product is null) as product_nulls,
sum(category is null) as category_nulls,
sum(price is null) as price_nulls,
sum(quantity is null) as quantity_nulls,
sum(customer is null) as customer_nulls,
sum(city is null) as city_nulls,
sum(payment is null) as payment_nulls
from raw_data;
select * from raw_data
where trim(order_id)= '' or trim(date) = '' or trim(product) = ''
or trim(category) = '' or trim(customer) = '' or trim(city) = '' or trim(payment) = '';
select * from raw_data
where price <= 0 or price is null ;
select * from raw_data
 where quantity <= 0 or quantity is null;
select * from raw_data
where str_to_date(date,'%Y-%m-%d') is null;
select distinct payment from raw_data;
select order_id, count(*) 
from raw_data group by order_id having count(*) > 1;
CREATE TABLE clean_data as
select
case 
when trim(order_id) = '' or order_id is null then 'UNKNOWN'
else UPPER(trim(order_id))
end as order_id,
case
when date LIKE '____-__-__'then STR_TO_DATE(date, '%Y-%m-%d')
when date LIKE '__-__-____'then STR_TO_DATE(date, '%d-%m-%Y')
when date LIKE '____/__/__'then STR_TO_DATE(date, '%Y/%m/%d')
when date LIKE '__/__/____'and cast(substr(date,1,2) as unsigned) <= 12
then STR_TO_DATE(date, '%m/%d/%Y')
when date LIKE '__/__/____' and cast(substr(date,1,2) as unsigned) > 12
then STR_TO_DATE(date, '%d/%m/%Y')
end as date,
trim(product) as product,
case trim(lower(category))
when 'electronics'then 'Electronics'
when 'electrnics'then 'Electronics'
when 'electroni cs'then 'Electronics'
when 'furniture'then 'Furniture'
when 'furnitur'then 'Furniture'
when 'sports'then 'Sports'
when 'sport'then 'Sports'
when 'sprots'then 'Sports'
when 'clothing'then 'Clothing'
when 'clothng'then 'Clothing'
when 'beauty'then 'Beauty'
when 'beauity'then 'Beauty'
when 'beuty'then 'Beauty'
when 'books'then 'Books'
when 'book'then 'Books'
when 'boks'then 'Books'
when 'grocery'then 'Grocery'
when 'grocry'then 'Grocery'
when 'groc.'then 'Grocery'
when 'toys'then 'Toys'
when 'toy'then 'Toys'
else trim(category)
end as category,
cast(price    as decimal(10,2)) as price,
cast(quantity as unsigned)      as quantity,
case 
when trim(customer) = '' or customer is null then 'Unknown Customer'
else trim(customer)
end as customer,
case 
when trim(city) = '' or city is null then 'Unknown City'
else trim(city)
end as city,
case
when payment is null or trim(payment) = ''then 'Unknown'
when lower(trim(payment)) LIKE '%cash%'then 'Cash on Delivery'
when lower(trim(payment)) LIKE '%credit%'then 'Credit Card'
when lower(trim(payment)) LIKE '%debit%'then 'Debit Card'
when lower(trim(payment)) LIKE '%net%'then 'Net Banking'
when lower(trim(payment)) LIKE '%banking%'then 'Net Banking'
when lower(trim(payment)) LIKE '%emi%'then 'EMI'
when lower(trim(payment)) LIKE '%upi%'then 'UPI'
when lower(trim(payment)) LIKE '%wallet%'then 'Wallet'
else trim(payment)
end as payment,
(cast(price as decimal(10,2)) *cast(quantity as unsigned)) as revenue
from raw_data
where cast(price    as decimal(10,2)) > 0 and cast(quantity as unsigned)  > 0 
and cast(quantity as unsigned)  <= 100 and trim(product)  <> '' and product  is not null
and trim(category) <> '' and category is not null and date is not null;   
select*from clean_data;