									-- SHeta_Ibra --
					-- THIS  Query is made by SHeta_Ibrahim --






-- Calcuta Total Sales,Customer,Items sold over years
-- with the highest Sales Amount and The changes OVER TIME

Select 
	--Year(order_date) AS order_year,--
	--DATETRUNC(month,order_date) AS order_date,
	Format(order_date, 'yyyy - MMM') AS order_date ,
	SUM(sales_amount) AS Sales_Amount,
	Count(DISTINCT customer_key) AS Total_customers,
	SUM(quantity) AS Sold_Items
	from gold.fact_sales
	Where order_date is not Null
	Group by Format(order_date, 'yyyy - MMM')
	order by SUM(sales_amount);


	-- Cumulative Analsis 
	-- THE WINDOW
SELECT 
order_date,
Total_Sales,
SUM(Total_Sales) over(PARTITION BY Order_date ORDER BY Order_date) AS Acumulative_total_Sales,
AVG(AVG_Price) over(PARTITION BY Order_date ORDER BY Order_date) AS AVG_Price
FROM (
SELECT
DATETRUNC (MONTH,order_date)AS Order_date,
SUM (sales_amount) AS Total_Sales,
AVG(Price) as AVG_PRICE
FROM gold.fact_sales
WHERE order_date is not NULL
Group by  DATETRUNC (MONTH,order_date)
) t;


							--Preformace Analysis 
/*Analysisng the yearly preformance of 2 products by comparing
 both average sales prefrmance this year and the year before */
 
 WITH Yearly_product_Sales AS (
 SELECT 
 year(f.Order_date) Order_year,
 p.product_name,
 SUM (f.sales_amount ) AS Current_sales
 from gold.fact_sales f
LEFT JOIN gold.dim_products p
on p.product_key = f.product_key
where order_date is not Null
GROUP BY year(f.Order_date),   p.product_name 
)

SELECT 
Order_year,
product_name,
current_sales, 
AVG(current_sales) OVER(Partition By Product_name) AS AVG_SALES,
Current_sales - AVG(current_sales) OVER(Partition By Product_name) AS Diff_AVG,
CASE WHEN  Current_sales - AVG(current_sales) OVER(Partition By Product_name) > 0 THEN 'ABOVE AVG'
	WHEN  Current_sales - AVG(current_sales) OVER(Partition By Product_name) < 0 THEN 'BELOW AVG'
	ELSE 'AVG'
END 'AVG RATE',

-- Year over year analysis 
LAG(Current_sales) Over(Partition By Product_name Order by Order_year) AS previos_year,
Current_sales - LAG(Current_sales) Over(Partition By Product_name Order by Order_year) AS DIFF_BETWEEN_Y,

CASE WHEN  Current_sales - LAG(Current_sales) Over(Partition By Product_name Order by Order_year) > 0 THEN 'Increased Sales'
	WHEN  Current_sales - LAG(Current_sales) Over(Partition By Product_name Order by Order_year) < 0 THEN 'decreased Sales'
	ELSE 'Same'
END 'Sales RATE'

FROM Yearly_product_Sales
Order By  product_name,Order_year;


								/* Part to whole Analysis
						which category conytibutes the most overall sales */
With Category_Sales as(
SELECT
 Category,
Sum(sales_amount) as Total_sales
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
on p.product_key = f.product_key
group by Category)

Select
category,
Total_sales,
sum(Total_sales) Over() overall_salles ,
CONCAT(ROUND((cast (Total_sales as float) / sum(Total_sales) Over()) *100,2), '%')AS _percentage_of_total
from Category_Sales
ORDER BY Total_sales DESC ;




		
					/*        DATA SEGMENTATION 
			Segmenting Products into cost range and get the count of
			      how many products are there is each range */
WITH Product_Segmentaion as (
SELECT  
	product_key,
	product_name,
	cost,
CASE WHEN cost < 100 then 'low cost '
	WHEN cost between 100 and 1000 then 'medium cost'
	else 'high cost'
END COST_RANGE
FROM gold.dim_products)

SELECT 
	Cost_range,
	COUNT(product_key) AS total_product 
FROM Product_Segmentaion 
GROUP BY COST_RANGE
Order by COUNT(product_key)


/*Grouping customers based on their spending behaviour and 
find total unmber of customers by each group  */
WITH Customer_spending AS (
Select 
	C.customer_ID,
	Sum(S.sales_amount) AS total_sales,
	MIN(order_date) AS first_order,
	Max(order_date) AS latest_order,
	DATEDIFF (MONTH, MIN(order_date) , Max(order_date)  ) AS Life_span 
From gold.fact_sales S
LEFT JOIN GOLD.dim_customers C
ON S.customer_key = C.customer_key
Group by C.customer_ID )

SELECT 
	Customer_Range,
	count(customer_id) as total_Customer 

FROM (
SELECT
	customer_id,
CASE WHEN total_sales > 5000 and life_span > 12 then 'VIP CUSTOMER'
	WHEN total_sales <= 5000 and life_span > 12 then 'Regular  CUSTOMER'
	else 'New Customer'
END Customer_Range
FROM Customer_spending ) t
Group BY Customer_Range
Order by total_Customer ;








