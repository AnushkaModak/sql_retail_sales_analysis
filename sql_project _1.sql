
-- creating a table
CREATE TABLE retail_sales
(
    transactions_id INT PRIMARY KEY,
    sale_date DATE,	
    sale_time TIME,
    customer_id INT,	
    gender VARCHAR(10),
    age INT,
    category VARCHAR(35),
    quantity INT,
    price_per_unit FLOAT,	
    cogs FLOAT,
    total_sale FLOAT
);

select * from retail_sales;

select count(*) from retail_sales;

--data cleaning
select * from retail_sales
where
transactions_id is null
	or
sale_date is null
	or
sale_time  is null
	or
customer_id is null
	or
gender is null
	or
category is null
	or
quantity is null
	or
price_per_unit is null 
	or
cogs is null
	or
total_sale is null
;

delete from retail_sales
where
transactions_id is null
	or
sale_date is null
	or
sale_time  is null
	or
customer_id is null
	or
gender is null
	or
category is null
	or
quantity is null
	or
price_per_unit is null 
	or
cogs is null
	or
total_sale is null
;

update retail_sales
set age = (select avg(age) from retail_sales where age is not null)
where age is null;

--data exploration

--How many total transactions and unique customers are in the dataset?
select 
	count(transactions_id) as total_transaction, 
	count(distinct customer_id) as total_customers
	from retail_sales;

--What is the total revenue, average sale value, and highest single sale recorded?

select sum(quantity*price_per_unit) as total_revenue,
	avg(total_sale) as average_sale,
	max(total_sale) as highest_single_sale 
from retail_sales;

--What does the distribution of customer ages look like? (young vs. middle-aged vs. older customers)
select 
case 
when age between 19 and 30 then 'young adults'
when age between 31 and 51 then 'middle aged'
else 'senior citizens'
end as age_group,
count(*) as customer_count,
sum(total_sale) as total_spent
	from retail_sales
group by age_group
order by age_group;


--Which age group (e.g., 20s, 30s, 40s) spends the most overall?
select 
case 
when age between 19 and 30 then 'young adults'
when age between 31 and 51 then 'middle aged'
else 'senior citizens'
end as age_group,
sum(total_sale) as total_rev
	from retail_sales
group by age_group
order by total_rev desc 
	limit 1;


--How many male and female customers are there in the dataset?
select gender, count(*) 
	from retail_sales
group by gender;


--Which gender contributes more to total sales revenue?

select gender,
	sum(total_sale) as total_rev 
	from retail_sales
	group by gender
	order by total_rev desc
	limit 1;


--Do men and women in different age groups show different spending patterns?
select case 
when age between 19 and 30 then 'young adults'
when age between 31 and 51 then 'middle aged'
else 'senior citizens'
end as age_group,
gender,
sum(total_sale) as total_rev
from retail_sales
group by age_group, gender
order by age_group, gender, total_rev desc;


--Who are the top 5 highest-spending customers?
select distinct customer_id, 
	sum(total_sale) as total_rev 
	from retail_sales
	group by customer_id
	order by total_rev desc
	limit 5;


--How do monthly sales trends look — are there peak months?
select extract(year from sale_date) as years,
	extract(month from sale_date) as months, 
sum(total_sale) as total_sales
from retail_sales
group by years, months
order by years, months, total_sales desc ;


--calculate the average sale for each month. Find out best selling month in each year:

select years,
	months, 
	avg_sales 
	from 
	(select extract(year from sale_date) as years,
extract(month from sale_date) as months,
avg(total_sale) as avg_sales
	from retail_sales
	group by years, months)
order by avg_sales desc
limit 2;


-- create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)

select 
	case
when extract(hour from sale_time) < 12 then 'morning'
when extract(hour from sale_time) between 12 and 17 then 'afternoon'
else 'evening'
end as shifts,
	count(transactions_id) as no_of_orders
from retail_sales
group by shifts
order by no_of_orders desc;


--At what time of day (hours) do customers shop the most?
select
extract(hour from sale_time) as hours,
sum(total_sale) as total_rev
from retail_sales
group by hours
order by total_rev desc
limit 1;


--Which categories are the most profitable (total sales − COGS)?
select category,
	sum(total_sale-cogs) as total_profit 
from retail_sales
group by category 
order by total_profit desc
	limit 1;


--Which product categories bring in the most revenue and the highest quantity sold?
select category,
	sum(total_sale) as highest_rev
from retail_sales
group by category
	order by highest_rev desc
	limit 1;

--end







