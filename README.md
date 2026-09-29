# SQL-Sales-customers-analysis-
 using sales, product, and customer data to uncover business insights. The project applies advanced SQL techniques including CTEs, window functions, aggregations, LAG(), cumulative analysis, segmentation, and year-over-year performance analysis to evaluate sales trends, customer behavior, product performance, and category contribution.


# 📊 Sales & Customer Analytics Using SQL

## 📌 Project Overview

This project focuses on analyzing sales, customer, and product data using SQL to generate meaningful business insights and demonstrate practical data analysis skills.

The analysis is built using a sales database containing fact and dimension tables, including:

- `gold.fact_sales`
- `gold.dim_products`
- `gold.dim_customers`

The project explores sales trends, customer behavior, product performance, category contribution, and customer segmentation using advanced SQL techniques.

---

## 🎯 Business Questions

The analysis answers several key business questions:

- How do total sales change over time?
- How many customers and items are involved in sales each month?
- What are the cumulative sales trends?
- How are products performing compared with their historical average?
- How have product sales changed year over year?
- Which product categories contribute the most to total sales?
- How are products distributed across different cost ranges?
- How can customers be segmented based on spending behavior and relationship duration?

---

## 🔍 Analysis Performed

### 1. 📈 Sales Trend Analysis

Analyzed monthly sales performance by calculating:

- Total Sales
- Number of Unique Customers
- Number of Items Sold

This helps identify changes in sales performance over time.

---

### 2. 📊 Cumulative Sales Analysis

Used SQL Window Functions to analyze sales trends over time and calculate cumulative metrics.

Techniques used:

- `SUM() OVER()`
- `AVG() OVER()`
- `PARTITION BY`
- `ORDER BY`

---

### 3. 📦 Product Performance Analysis

Compared yearly product sales against the product's historical average.

The analysis identifies whether yearly sales were:

- Above Average
- Below Average
- Average

It also performs **Year-over-Year (YoY) analysis** to determine whether sales:

- Increased
- Decreased
- Stayed the Same

Techniques used:

- `LAG()`
- `AVG() OVER()`
- `CASE WHEN`
- CTEs

---

### 4. 🥧 Part-to-Whole Analysis

Analyzed how much each product category contributes to overall sales.

Metrics include:

- Category Sales
- Overall Sales
- Percentage of Total Sales

This helps identify the contribution of each category to the business's total revenue.

---

### 5. 💰 Product Cost Segmentation

Products were divided into three cost ranges:

| Cost Range | Category |
|---|---|
| < 100 | Low Cost |
| 100–1000 | Medium Cost |
| > 1000 | High Cost |

The analysis then calculates the number of products within each segment.

---

### 6. 👥 Customer Segmentation

Customers were segmented according to their spending behavior and relationship duration.

The segments include:

- **VIP Customer** — High spending and long relationship
- **Regular Customer** — Lower spending but long relationship
- **New Customer** — Recent or shorter relationship

Customer lifetime was calculated using:

`DATEDIFF()`

This segmentation can help businesses better understand their customer base and support targeted marketing strategies.

---

## 🛠️ SQL Skills Demonstrated

- SQL Aggregations
- `GROUP BY`
- `JOIN`
- `LEFT JOIN`
- Common Table Expressions (CTEs)
- Window Functions
- `SUM() OVER()`
- `AVG() OVER()`
- `LAG()`
- `PARTITION BY`
- `ORDER BY`
- `CASE WHEN`
- Customer Segmentation
- Product Segmentation
- Year-over-Year Analysis
- Cumulative Analysis
- Percentage-of-Total Analysis
- Date Functions
- Data Transformation

---

## 📂 Database Structure

The project works with a dimensional sales model:

```text
gold.fact_sales
       |
       |-- product_key
       |
       |-- customer_key
       |
       ↓
gold.dim_products
       |
       ↓
gold.dim_customers
