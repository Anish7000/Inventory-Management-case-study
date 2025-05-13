Create database inventory;

use inventory;

 CREATE TABLE inventory_data (
    RegionName VARCHAR(50),
    CountryName VARCHAR(50),
    State VARCHAR(50),
    City VARCHAR(50),
    PostalCode VARCHAR(20),
    WarehouseAddress VARCHAR(255),
    WarehouseName VARCHAR(100),
    EmployeeName VARCHAR(100),
    EmployeeEmail VARCHAR(100),
    EmployeePhone BIGINT,
    EmployeeHireDate DATE,
    EmployeeJobTitle VARCHAR(100),
    CategoryName VARCHAR(100),
    ProductName VARCHAR(100),
    ProductDescription TEXT,
    ProductStandardCost DECIMAL(10,2),
    Profit DECIMAL(10,2),
    ProductListPrice DECIMAL(10,2),
    CustomerName VARCHAR(100),
    CustomerAddress VARCHAR(255),
    CustomerCreditLimit INT,
    CustomerEmail VARCHAR(100),
    CustomerPhone BIGINT,
    Status VARCHAR(20),
    OrderDate DATE,
    OrderItemQuantity INT,
    PerUnitPrice DECIMAL(10,2),
    TotalItemQuantity INT
);


-- 1. Which products generated the highest total profit?
SELECT ProductName,
       SUM(Profit) AS TotalProfit
FROM inventory_data
GROUP BY ProductName
ORDER BY TotalProfit DESC
LIMIT 10;

-- 2. Monthly trend of total sales (Total Revenue = PerUnitPrice × OrderItemQuantity):
SELECT DATE_FORMAT(OrderDate, '%Y-%m') AS Month,
       SUM(PerUnitPrice * OrderItemQuantity) AS MonthlyRevenue
FROM inventory_data
GROUP BY Month
ORDER BY Month;

-- 3. Top product categories by average profit per item:
SELECT CategoryName,
       AVG(Profit / NULLIF(OrderItemQuantity, 0)) AS AvgProfitPerItem
FROM inventory_data
GROUP BY CategoryName
ORDER BY AvgProfitPerItem DESC
LIMIT 10;

-- 4. Which employees handled the most total order quantity?
SELECT EmployeeName,
       SUM(OrderItemQuantity) AS TotalItemsHandled
FROM inventory_data
GROUP BY EmployeeName
ORDER BY TotalItemsHandled DESC
LIMIT 10;

-- 5. Which cities have the highest number of orders shipped?
SELECT City,
       COUNT(*) AS TotalShippedOrders
FROM inventory_data
WHERE Status = 'Shipped'
GROUP BY City
ORDER BY TotalShippedOrders DESC
LIMIT 10;

-- 6. Cancelled orders by product and region
SELECT ProductName,
       RegionName,
       COUNT(*) AS CancelledOrders
FROM inventory_data
WHERE Status = 'Canceled'
GROUP BY ProductName, RegionName
ORDER BY CancelledOrders DESC
LIMIT 10;

-- 7. List customers who made multiple orders (repeat customers):
SELECT CustomerName,
       COUNT(*) AS OrderCount
FROM inventory_data
GROUP BY CustomerName
HAVING OrderCount > 1
ORDER BY OrderCount DESC;

-- 8. Average profit per unit sold for each product
SELECT ProductName,
       SUM(Profit) / SUM(OrderItemQuantity) AS AvgProfitPerUnit
FROM inventory_data
GROUP BY ProductName
ORDER BY AvgProfitPerUnit DESC;

-- 9. Determine the year-over-year growth in total sales:
SELECT YEAR(OrderDate) AS Year,
       SUM(PerUnitPrice * OrderItemQuantity) AS TotalSales
FROM inventory_data
GROUP BY YEAR(OrderDate)
ORDER BY Year;

-- 10. Identify products where the standard cost is higher than the selling price (potential loss):
SELECT ProductName,
       ProductStandardCost,
       PerUnitPrice
FROM inventory_data
WHERE ProductStandardCost > PerUnitPrice;
