-- Create the main to hold raw transactional data
CREATE TABLE Online_Retail
(
		 InvoiceNo	     VARCHAR (20), 
	     StockCode       VARCHAR (20), 
	     Description     VARCHAR (200), 
       	 Quantity        INTEGER,
	     InvoiceDate     VARCHAR(50),
	     UnitPrice       NUMERIC(10,2),
	     CustomerID      INT,
	     Country	     VARCHAR(50)
);

--Preview data after loading (sanity check).
SELECT * FROM online_retail;


--Import data from csv. 
COPY   Online_Retail (InvoiceNo, StockCode, Description,
       Quantity, InvoiceDate, UnitPrice, CustomerID, Country)
FROM  'C:\Users\palak\Downloads\Raw data (sql project)\data CSV.csv'

DELIMITER ','
CSV HEADER ;


--Add new TIMESTAMP column for better date handling  
ALTER TABLE	 online_retail
ADD COLUMN	 invoicedate_time TIMESTAMP; 


--Convert invoice date from VARCHAR to TIMESTAMP.
UPDATE  online_retail 
SET     invoicedate_time = TO_TIMESTAMP(invoicedate, 'mm/dd/yy hh24:mi' );


--Drop the invoice date column as it's now redundant.
ALTER TABLE	 online_retail 
DROP COLUMN  invoicedate;


--Remove rows with missing customer ID (Incomplete Sales).
DELETE FROM  online_retail 
WHERE	 customerid IS NULL ;




--Find which products generated the most revenue overall.
SELECT description, SUM(quantity * unitprice) AS Total_revenue
FROM online_retail
GROUP BY description
ORDER BY total_revenue DESC ; 
--Insight: Top products can be prioritized for marketing or stock.



--See which countries contribute most to overall revenue. 
SELECT  country,description, SUM(quantity * unitprice)AS Total_revenue 
FROM    online_retail
GROUP BY  description,country
ORDER BY  total_revenue DESC
LIMIT 5 ;  

SELECT  DISTINCT country,description, 
SUM(quantity * unitprice)
OVER(PARTITION BY country,description) AS Total_revenue 
FROM   online_retail
ORDER BY  total_revenue DESC
LIMIT 5 ;

--Insight: High-Value countries could be targeted for expansion or custom offers.



--Analays sales performance by month and year to find peaks or slumps. 
SELECT EXTRACT(YEAR FROM invoicedate_time) AS years,
	   EXTRACT(MONTH FROM invoicedate_time)AS months,
	   SUM(quantity * unitprice)AS Total_monthly_revenue
FROM online_retail
GROUP BY EXTRACT(YEAR FROM invoicedate_time), EXTRACT(MONTH FROM invoicedate_time)
ORDER BY total_monthly_revenue DESC
LIMIT 5;

--Method:2
SELECT DISTINCT EXTRACT(MONTH FROM invoicedate_time)AS months,
	   EXTRACT(YEAR FROM invoicedate_time) AS years,
	   SUM(quantity * unitprice)
	   OVER(PARTITION BY EXTRACT(MONTH FROM invoicedate_time),
	   EXTRACT(YEAR FROM invoicedate_time)) AS Total_monthly_revenue
FROM online_retail	   
ORDER BY total_monthly_revenue DESC
LIMIT 5;

--Insight: Pinpoint peak sales periods for campaign planning.



--Identify products that are frequently returned (Negative Quantity)
SELECT  description ,Quantity 
FROM online_retail 
WHERE Quantity < 0 
ORDER BY quantity ASC ;
--Insight: High returns may indicate quality or listing issue.



--What time of the day sees the highest number of orders ?
SELECT COUNT(quantity) AS TOTAL_ORDERS,
	   EXTRACT(HOUR FROM invoicedate_time)AS HOURS
FROM online_retail 
GROUP BY HOURS
ORDER BY TOTAL_ORDERS DESC 
LIMIT 1 ; 
--Insight: Schedule promotions site maintenance for off-peak hours. 



--Which products are commonly bought together? Useful for bundle deals.
SELECT  o.description AS item1, r.description AS item2 ,
COUNT(O.quantity) AS frequency
FROM online_retail o
JOIN online_retail r ON o.invoiceno =  r.invoiceno  
AND o.description > R.DESCRIPTION --TO AVOID DUPLICATE PAIRS LIKE A,B AND B,A
GROUP BY item1 ,item2 ,o.invoiceno
ORDER BY frequency DESC 
LIMIT 20 ;
--Insight: Bundle these products to boost cross-sell. 



--Which customers only returned items (no positive purchases) and for high amounts?
SELECT customerid, ABS(SUM(quantity*unitprice)) --ABS makes the return amount positive for clarity.
AS total_amount 
FROM online_retail 
GROUP BY customerid
HAVING SUM(CASE WHEN quantity > 0 THEN 1 ELSE 0 END)=0 --No purchases 
   AND SUM(CASE WHEN quantity < 0 THEN 1 ELSE 0 END)>0	--only returns 
ORDER BY total_amount DESC
LIMIT 10 ;
--Insight: Investigate causes, fraud or bad experiences? 



--Products selling a lot but earning little (under-priced or loss leaders) 
SELECT description, SUM(quantity) TOTAL_QUANTITY, 
				 	 SUM(quantity*unitprice) AS total_revenue 
FROM online_retail 
WHERE quantity > 0 AND unitprice > 0 
GROUP BY description 
HAVING SUM(quantity) > 5000 AND SUM(quantity*unitprice) < 10000
ORDER BY TOTAL_quantity DESC  ,TOTAL_REVENUE ASC 
LIMIT 20 ; 
--Insight: Revisit pricing for these products. 

--WINDOW FUNCTION
SELECT invoiceno,stockcode,description,quantity,unitprice,customerid,country,invoicedate_time, 
		ROW_NUMBER() OVER(PARTITION BY country ORDER BY unitprice DESC) AS popularity,
		RANK() OVER(ORDER BY unitprice DESC) AS popularity_R,
		DENSE_RANK() OVER(ORDER BY unitprice DESC) AS popularity_DR
FROM online_retail;

--Average Revenue, Minimum average revenue , Maximum average revenue of each product for every row
SELECT 
	invoiceno,
	description,
	quantity*unitprice AS revenue,
	AVG(quantity*unitprice)
	OVER (PARTITION BY description)AS AVG_revenue,
	
	MIN(quantity*unitprice)
	OVER(PARTITION BY description) AS min_avg_revenue,
	
	MAX(quantity*unitprice)
	OVER(PARTITION BY description) AS max_avg_revenue,

	RANK()
	OVER(ORDER BY quantity*unitprice DESC) AS overall_rank,

	RANK()
	OVER(PARTITION BY description 
	ORDER BY quantity*unitprice DESC) AS description_rank
FROM
	online_retail
ORDER BY overall_rank DESC, description_rank;


-- Window function CTE
WITH CTE_retail AS (
SELECT invoiceno, customerid,country,
quantity*unitprice AS Revenue,

COUNT(Description)
OVER(PARTITION BY country) AS total_description,

AVG(quantity * unitprice)
OVER(PARTITION BY country) AS avg_revenue
FROM 
	online_retail
WHERE quantity*unitprice > 100000 
)
SELECT country,revenue,total_description,avg_revenue 
FROM 
	cte_retail

	
/* How many customers made repeat purchases within 90 days, 
and what is the repeat purchase rate? */

WITH initial_orders AS (SELECT 
				customerid, MIN(invoicedate_time) AS initial_order_date 
				FROM online_retail 
				GROUP BY customerid),

repeat_orders AS (
			SELECT o.customerid FROM online_retail o 
			JOIN initial_orders i  
			ON o.customerid = i.customerid
			WHERE i.initial_order_date < o.invoicedate_time AND 
		    o.invoicedate_time <= i.initial_order_date + INTERVAL '90 Days'
			GROUP BY  o.customerid
			)

SELECT 
	  (SELECT COUNT(DISTINCT(customerid)) FROM repeat_orders)::float /
	  (SELECT COUNT(DISTINCT(customerid)) FROM initial_orders)*100 AS repeat_purchases_percentrate; 


-- Which products have the highest return rates (10% or more returns, with at least 100 units sold)?

WITH sold_products AS (
						SELECT description ,
						SUM(CASE 
							WHEN quantity > 0 THEN quantity ELSE 0 END) AS units_sold,
				ABS(SUM(CASE
							WHEN quantity < 0 THEN quantity ELSE 0 END))AS units_returned
				FROM online_retail
				GROUP BY description ),
returned_rate AS (
					SELECT description,
					units_sold,
					units_returned, 
					CASE 
						WHEN units_sold > 0 
						THEN ROUND(units_returned ::NUMERIC/units_sold * 100,2) 
						ELSE 0 END AS returned_rate 
					FROM sold_products 
				)
SELECT description,
		units_sold,
		units_returned,
		returned_rate ::TEXT || '%' AS returned_rate
FROM returned_rate
WHERE units_sold >= 100 AND
returned_rate >= 10 
ORDER BY returned_rate DESC 
LIMIT 10
									
		
					
			


/*
Conclusion: 
- SQL analysis revealed actionable trends in sales, returns and customer behaviour.
- Business could focus on bestsellers, address issues with high-return products and optimize promotions for peak hours.
- Future work: Connect this data to Power BI for dashboards or apply machine learning for demand prediction.
*/
