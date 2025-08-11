--Drop Table
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS orders;

--Create Table
CREATE TABLE customers(
				Customer_ID VARCHAR(20) PRIMARY KEY,
				Customer_Name VARCHAR(50),
				Segment VARCHAR(20),
				Country VARCHAR(20),
				City VARCHAR(20),
				State VARCHAR(20),
				Postal_Code INT,
				Region VARCHAR(20)
);


CREATE TABLE products(
				Product_ID VARCHAR(50) PRIMARY KEY,
				Product_Name TEXT,
				Category VARCHAR(100),
				Sub_Category VARCHAR(100)
);


CREATE TABLE orders(
				Row_ID SERIAL PRIMARY KEY,
				Order_ID VARCHAR(50),
				Order_Date DATE,
				Ship_Date DATE,
				Ship_Mode VARCHAR(50),
				Customer_ID	VARCHAR(20),
				Product_ID VARCHAR(20),
				Sales NUMERIC(10,2),
				Quantity INT,
				Discount NUMERIC(10,2),
				Profit NUMERIC(10,2),
				Order_Month INT,
				Order_Year INT,
				Order_Day_of_Week INT
);


SELECT * FROM customers;
SELECT * FROM products;
SELECT * FROM orders;



--Product And Category Analysis

--1) Top 10 best selling products by quantity
SELECT Product_Name, SUM(Quantity) AS Total_Quantity
FROM orders
JOIN products using (Product_ID)
GROUP BY Product_Name
Order BY Total_Quantity DESC
Limit 10;


--2) Most profitable product category
SELECT Category, SUM(Profit) AS Total_Profit
FROM orders
JOIN products using (Product_ID)
Group BY Category
Order By Total_Profit desc;


--3) Average discount by sub-category
SELECT Sub_Category, AVG(Discount) AS Total_Discount
FROM orders
JOIN products USING (Product_ID)
GROUP BY Sub_Category
Order BY Total_Discount DESC;


--Customer Insights

--1) Top 5 customer by total sales 
SELECT Customer_Name, SUM(Sales) AS Total_Sales
FROM orders 
JOIN customers USING (Customer_ID)
Group BY Customer_Name
Order By Total_Sales DESC
LIMIT 5;


--2) Number of Order per customer segment
SELECT Segment, COUNT(Distinct(Order_ID)) AS Total_Order
FROM orders
JOIN customers USING (Customer_ID)
Group BY Segment;


--3) Customer with negative profit
SELECT Customer_Name, SUM(Profit) AS Negative_Profit
FROM orders
JOIN customers USING (Customer_ID)
Group BY Customer_Name
-- HAVING Negative_Profit<0
Order BY Negative_Profit;


-- Geogra[hical Trends

--1) Sales by region
SELECT Region, SUM(Sales) AS Total_Sales
FROM orders
JOIN customers USING (CUstomer_ID)
Group BY Region
Order BY Total_Sales DESC;


--2) Top Cities by Total Profit
SELECT City, SUM(Profit) AS Total_Profit
FROM orders
JOIN customers USING (Customer_ID)
GROUP BY City
ORDER BY Total_Profit DESC;


--3) State with high discount(>15)
SELECT State,AVG(Discount) AS High_Discount
FROM orders
JOIN customers USING (Customer_ID)
Group BY State
-- Having AVG(High_Discount)>0.15;
Order By High_Discount DESC;


-- Time Based Trend

--1) Monthly sales over year
SELECT Order_Month, Order_Year, SUM(Sales) AS Monthly_Sales
FROM orders
GROUP BY Order_Month, Order_Year
Order BY Order_Month, Order_Year;


--2) Day Of Week with highest sale
SELECT Order_Day_of_Week, SUM(Sales) AS Highest_Sale
from orders
Group By Order_Day_of_Week
Order By Order_Day_of_Week DESC;


--3) Sales growth year over year
SELECT Order_Year, SUM(Sales) AS Yearly_Sales
FROM orders
GROUP By Order_Year
Order By Order_Year;


-- Shipping Analysis

--1) Orders ship by mode
SELECT Ship_Mode, COUNT(*) AS Number_of_Order
From orders
Group By Ship_Mode
Order By Ship_Mode;


--2) Average Shipping time in days
SELECT AVG(AGE(Ship_Date, Order_date)) AS AVG_Days
from orders;


-- Performance Metrics

--1) Profit Margin by Category
SELECT Category, Round(Sum(Profit)/SUM(Sales)*100,2) AS Profit_Margin
from orders
JOIN products USING (Product_ID)
Group By Category
Order BY Profit_Margin DESC;


--2) Loss Making order
SELECT Order_ID, Product_ID, Sales, Profit
from orders
WHERE Profit<0
Order by Profit, Sales DESC;


--3) Top 5 product with high discount
SELECT Product_Name, MAX(Discount) AS High_Discount
from orders
Join products USING (Product_ID)
Group BY Product_Name
Order By High_Discount DESC
LIMIT 5;


--4) Best Customer in each region
SELECT Customer_Name, Region, SUM(Sales) AS Best_Customer
from orders
JOIN customers USING (Customer_ID)
Group BY Customer_Name, Region
Order BY Region, Best_Customer DESC;


--5) Product Popularity Score (Quantity × Sales)
SELECT Product_Name, SUM(Quantity*Sales) AS Popularity_Score
from orders
JOIN products USING (Product_ID)
Group by Product_Name
Order by Popularity_Score DESC;


--6) Customer who bought from all category
SELECT Customer_ID, Customer_Name
    FROM customers
    WHERE Customer_ID IN (
      SELECT Customer_ID
      FROM orders
      JOIN products USING(Product_ID)
      GROUP BY Customer_ID
      HAVING COUNT(DISTINCT Category) = (
        SELECT COUNT(DISTINCT Category) FROM products
      )
    );