

-- Create TABLE
DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales
            (
                transaction_id INT PRIMARY KEY,	
                sale_date DATE,	 
                sale_time TIME,	
                customer_id	INT,
                gender	VARCHAR(15),
                age	INT,
                category VARCHAR(15),	
                quantity	INT,
                price_per_unit FLOAT,	
                cogs	FLOAT,
                total_sale FLOAT
            );

SELECT * FROM public.retail_sales
ORDER BY transaction_id ASC LIMIT 10


select count(*) from retail_sales


select * from retail_sales
where 
sale_date is null
or
sale_time is null
or 
customer_id is null
or
gender is null
or 
category is null
or 
cogs is null
or total_sale is null;


delete from retail_sales
where
sale_date is null
or
sale_time is null
or 
customer_id is null
or
gender is null
or 
category is null
or 
cogs is null
or total_sale is null;



--Data Exploration
-- How many sales we have?
select count(*) as total_sale from retail_sales

-- How many uniuque customers we have ?
select count(distinct customer_id) as total_sale from retail_sales

select distinct category from retail_sales



-- Data Analysis & Business Key Problems & Answers

-- My Analysis & Findings
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
select *
from retail_sales
where retail_sales.sale_date = '2022-11-05';

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022
select * from retail_sales
where 
	category = 'Clothing'
	and
	to_char(sale_date, 'YYYY-MM') = '2022-11'
	and
	quantity >= 4;

--another method
select * from retail_sales
where 
	category = 'Clothing'
	and
	sale_date BETWEEN '2022-11-01' and '2022-11-30'
	and
	quantity >= 4;

--another method
SELECT 
  *
FROM retail_sales
WHERE 
    category = 'Clothing'
    AND 
    EXTRACT(YEAR FROM sale_date) = 2022
    AND 
    EXTRACT(MONTH FROM sale_date) = 11
    AND
    quantity >= 3;

-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
select
	category,
	sum(total_sale) as net_sale,
	count(*) as total_orders
from retail_sales
group by 1;

--another method using Common Table Expression(CTE)
with SalesSummary as(
select
	category,
	sum(total_sale) as net_sale,
	count(*) as total_orders
from retail_sales
group by category
)
select * from SalesSummary;


-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
select
	Round(avg(age),2) as avg_age
from retail_sales
where category = 'Beauty';


-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.

select * from retail_sales
where total_sale > 1000;

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.

select 
	gender,
	category,
	count(transaction_id) as total_transaction
from retail_sales
group by
	category,
	gender
order by category

--another method (using subquery)
select 
	category,
	gender,
	count(*) as total_transaction
from(
	select
		transaction_id,
		category,
		gender
	from retail_sales
) as subquery
group by
	category,
	gender
order by 1;

--another method (CTE)
with SalesData as(
	select
		transaction_id,
		category,
		gender
	from retail_sales
)
select
	category,
	gender,
	count(*) as total_transaction
from SalesData
group by
	category,
	gender
order by category;


-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year

-- avg sales for each month
select
	extract(year from sale_date) as year,
	extract(month from sale_date) as month,
	Round(cast(avg(total_sale) as numeric),2) as avg_sale
from
	retail_sales
group by
	extract(year from sale_date),
	extract(month from sale_date);
	
--find best selling month for each year
with MonthlyAvg as(
select
	extract(year from sale_date) as year,
	extract(month from sale_date) as month,
	Round(cast(avg(total_sale) as numeric),2) as avg_sale
from
	retail_sales
group by
	extract(year from sale_date),
	extract(month from sale_date)
)
select 
	year,
	month,
	avg_sale
from
	MonthlyAvg
where
	(year, avg_sale) in (
		select
			year,max(avg_sale)
		from
			MonthlyAvg
		group by
			year
);



-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 

select 
	customer_id,
	sum(total_sale) as total_sales
from
	retail_sales
group by
	customer_id
order by
	total_sales desc
limit 5;


-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.

select
	category,
	count(distinct customer_id) as unique_customer
from
	retail_sales
group by category

-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)


select
	case
		when extract(hour from sale_time) < 12 then 'Morning'
		when extract(hour from sale_time) between 12 and 17 then 'Afternoon'
		else 'Evening'
	end as shift,
	count(*) as total_orders
from 
	retail_sales
group by
	case
		when extract(hour from sale_time) < 12 then 'Morning'
		when extract(hour from sale_time) between 12 and 17 then 'Afternoon'
		else 'Evening'
	end;

-- union all with aggregation
SELECT 'Morning' AS shift, COUNT(*) AS total_orders
FROM retail_sales
WHERE EXTRACT(HOUR FROM sale_time) < 12
UNION ALL
SELECT 'Afternoon' AS shift, COUNT(*) AS total_orders
FROM retail_sales
WHERE EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17
UNION ALL
SELECT 'Evening' AS shift, COUNT(*) AS total_orders
FROM retail_sales
WHERE EXTRACT(HOUR FROM sale_time) > 17;

-- another method CTE
with hourly_sale as
(select *,
	case
		when extract(hour from sale_time) < 12 then 'Morning'
		when extract(hour from sale_time) between 12 and 17 then 'Afternoon'
		else 'Evening'
	end as shift
from retail_sales
)
select
	shift,
	count(*) as total_orders
from hourly_sale
group by
	shift;
			







