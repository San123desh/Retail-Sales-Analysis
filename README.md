
```markdown
# Retail Sales Data Analysis

This repository contains SQL queries to analyze and extract meaningful insights from retail sales data. The queries cover various tasks such as retrieving specific transactions, calculating sales metrics, and categorizing shifts.

## Table of Contents
- [Introduction](#introduction)
- [Queries](#queries)
  - [Retrieve Clothing Transactions in November 2022](#retrieve-clothing-transactions-in-november-2022)
  - [Total Sales for Each Category](#total-sales-for-each-category)
  - [Transactions by Gender in Each Category](#transactions-by-gender-in-each-category)
  - [Average Sale for Each Month and Best Selling Month](#average-sale-for-each-month-and-best-selling-month)
  - [Top 5 Customers by Total Sales](#top-5-customers-by-total-sales)
  - [Unique Customers by Category](#unique-customers-by-category)
  - [Orders by Shift](#orders-by-shift)
- [Git Ignore](#git-ignore)

## Introduction
This project demonstrates various SQL queries used to analyze retail sales data stored in a database. The queries help in retrieving specific transactions, calculating sales metrics, categorizing sales shifts, and more.

## Queries

### Retrieve Clothing Transactions in November 2022
```sql
SELECT *
FROM retail_sales
WHERE category = 'Clothing'
  AND TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
  AND quantity > 10;
```

### Total Sales for Each Category
```sql
SELECT 
    category,
    SUM(total_sale) AS net_sale,
    COUNT(*) AS total_orders
FROM retail_sales
GROUP BY category;
```

### Transactions by Gender in Each Category
```sql
SELECT 
    category,
    gender,
    COUNT(transaction_id) AS total_trans
FROM retail_sales
GROUP BY 
    category,
    gender
ORDER BY category;
```

### Average Sale for Each Month and Best Selling Month
```sql
WITH MonthlyAverage AS (
    SELECT 
        EXTRACT(YEAR FROM sale_date) AS year,
        EXTRACT(MONTH FROM sale_date) AS month,
        ROUND(CAST(AVG(total_sale) AS numeric), 2) AS average_sale
    FROM 
        retail_sales
    GROUP BY 
        EXTRACT(YEAR FROM sale_date),
        EXTRACT(MONTH FROM sale_date)
)
SELECT 
    year,
    month,
    average_sale
FROM 
    MonthlyAverage
JOIN (
    SELECT 
        year,
        MAX(average_sale) AS max_average_sale
    FROM 
        MonthlyAverage
    GROUP BY 
        year
) AS MaxSales
ON 
    MonthlyAverage.year = MaxSales.year
    AND MonthlyAverage.average_sale = MaxSales.max_average_sale;
```

### Top 5 Customers by Total Sales
```sql
SELECT 
    customer_id,
    SUM(total_sale) AS total_sales
FROM 
    retail_sales
GROUP BY 
    customer_id
ORDER BY 
    total_sales DESC
LIMIT 5;
```

### Unique Customers by Category
```sql
SELECT 
    category,
    COUNT(DISTINCT customer_id) AS unique_customers
FROM 
    retail_sales
GROUP BY 
    category;
```

### Orders by Shift
```sql
SELECT 
    CASE
        WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END AS shift,
    COUNT(*) AS total_orders
FROM 
    retail_sales
GROUP BY 
    CASE
        WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END;
```