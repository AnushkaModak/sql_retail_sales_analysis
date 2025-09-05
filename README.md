# sql_retail_sales_analysis project


## Project Overview

**Project Title**: Retail Sales Analysis  
**Level**: Beginner  to intermediate
**Database**: `sql_project_1`

This project demonstrates SQL skills and techniques typically used by data analysts to clean, explore, and analyze retail sales data. It involves setting up a retail sales database, performing exploratory data analysis (EDA), and answering business-driven questions using SQL queries.

## Objectives

1. Set up a retail sales database: Create and populate a retail sales database with transaction data.

2. Data Cleaning: Identify and remove records with missing values; impute missing ages with averages.

3. Exploratory Data Analysis (EDA): Perform descriptive analysis to understand customers and sales trends.

4. Business Analysis: Use SQL queries to answer advanced business questions and derive actionable insights.

## Project Structure

### 1. Database Setup

- **Database Creation**: The project starts by creating a database named `sql_project_1`.
- **Table Creation**: A table named `retail_sales` is created to store the sales data. The table structure includes columns for transaction ID, sale date, sale time, customer ID, gender, age, product category, quantity sold, price per unit, cost of goods sold (COGS), and total sale amount.

```sql
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
```
### 2. Data Exploration & Cleaning
1. Checked for NULL values across all columns.

2. Removed rows with missing critical fields (transaction ID, category, sales values).

3. Imputed missing age values using average age of available customers.
```sql
DELETE FROM retail_sales
WHERE transactions_id IS NULL
   OR sale_date IS NULL
   OR sale_time IS NULL
   OR customer_id IS NULL
   OR gender IS NULL
   OR category IS NULL
   OR quantity IS NULL
   OR price_per_unit IS NULL
   OR cogs IS NULL
   OR total_sale IS NULL;

UPDATE retail_sales
SET age = (SELECT AVG(age) FROM retail_sales WHERE age IS NOT NULL)
WHERE age IS NULL;
```
##Data Analysis & Findings
###Total transactions and unique customers:
```sql
SELECT 
    COUNT(transactions_id) AS total_transactions, 
    COUNT(DISTINCT customer_id) AS total_customers
FROM retail_sales;
```
###Total revenue, average sale, highest single sale:
```sql
SELECT 
    SUM(total_sale) AS total_revenue,
    AVG(total_sale) AS average_sale,
    MAX(total_sale) AS highest_single_sale
FROM retail_sales;
```
###Customer age group distribution:
```sql
SELECT 
    CASE 
        WHEN age BETWEEN 19 AND 30 THEN 'Young Adults'
        WHEN age BETWEEN 31 AND 51 THEN 'Middle Aged'
        ELSE 'Senior Citizens'
    END AS age_group,
    COUNT(*) AS customer_count,
    SUM(total_sale) AS total_spent
FROM retail_sales
GROUP BY age_group
ORDER BY age_group;
```
###Age group  spends the most overall:
```sql
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
```

###Count of male and female customers:
```sql
select gender, count(*) 
	from retail_sales
group by gender;
```
###Gender contribution to sales:
```sql
SELECT gender, SUM(total_sale) AS total_rev
FROM retail_sales
GROUP BY gender
ORDER BY total_rev DESC
limit 1;
```
###Pattern of spending depending upon gender and age:
```sql
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
```


###Top 5 highest-spending customers:
```sql
SELECT customer_id, SUM(total_sale) AS total_rev
FROM retail_sales
GROUP BY customer_id
ORDER BY total_rev DESC
LIMIT 5;
```
###Monthly sales trends:
```sql
SELECT 
    EXTRACT(YEAR FROM sale_date) AS year,
    EXTRACT(MONTH FROM sale_date) AS month,
    SUM(total_sale) AS total_sales
FROM retail_sales
GROUP BY year, month
ORDER BY year, month total_sales desc;
```
###Best-selling month each year:
```sql
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
```
###Orders by shift (Morning, Afternoon, Evening):
```sql
SELECT 
    CASE
        WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END AS shift,
    COUNT(transactions_id) AS total_orders
FROM retail_sales
GROUP BY shift
ORDER BY total_orders DESC;
```
###Busiest hours:
```sql
select
extract(hour from sale_time) as hours,
sum(total_sale) as total_rev
from retail_sales
group by hours
order by total_rev desc
limit 1;
```

###Most profitable category
```sql
select category,
	sum(total_sale-cogs) as total_profit 
from retail_sales
group by category 
order by total_profit desc
	limit 1;
```

###product categories with most revenue and the highest quantity sold:
```sql
select category,
	sum(total_sale) as highest_rev,
	max(quantity) as highest_quantity
from retail_sales
group by category
	order by highest_rev desc, highest_quantity desc
	limit 1;
```

##Findings
###summary
Total transactions: 1,997

Unique customers: 155

Each customer made about 13 purchases on average → strong repeat buying behavior

Total revenue: ₹911,720

Average order value (AOV): ~₹457

Highest single transaction: ₹2,000

###Customer Demographics & Spending

Age groups: Middle-aged spend the most (₹414,870) → ~45% of revenue

Gender: Females slightly outnumber males (1,017 vs. 980)

Spending: Females spend more overall (₹465,400)

Pattern: Middle-aged (both genders) dominate spending; females lead in every age group

###Customer Spending Trends

Top 5 customers: IDs 3, 1, 5, 2, 4 → highest spent by Customer 3 (₹38,440)

Monthly trends: Sales peak in late months (Oct–Dec 2022 & Sep–Dec 2023)

Best avg. sale months: July 2022 (₹541) & Feb 2023 (₹535)

Shopping shifts: Evening dominates (1,062 orders)

Peak hour: 7 PM (₹109,460 revenue)

###Category Performance Insights

Most Profitable Category: Clothing with ₹246,679 profit

Highest Revenue Category: Electronics with ₹313,810 revenue

Highest Quantity Sold (single transaction): Electronics (4 units)

##Report
Summary: 1,997 transactions, 155 unique customers, strong repeat buying (avg ~13 orders per customer), total revenue ₹911,720, AOV ~₹457, highest single sale ₹2,000.

Customer Demographics & Spending: Middle-aged customers drive ~45% of revenue (₹414,870); females slightly outnumber males (1,017 vs. 980) and spend more (₹465,400); females lead spending across all age groups.

Customer Spending Trends: Top spender is Customer 3 (₹38,440); peak sales in Oct–Dec 2022 & Sep–Dec 2023; best avg. sale in Jul 2022 & Feb 2023; evenings dominate (1,062 orders) with 7 PM as peak revenue hour (₹109,460).

Category Performance: Clothing is most profitable (₹246,679), Electronics leads in revenue (₹313,810) and highest single purchase quantity (4 units).


##Conclusion:
This project serves as a comprehensive introduction to SQL for data analysts, covering database setup, data cleaning, exploratory data analysis, and business-driven SQL queries. The findings from this project can help drive business decisions by understanding sales patterns, customer behavior, and product performance.







