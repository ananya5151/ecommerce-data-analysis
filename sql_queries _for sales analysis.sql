USE retail_project;
DROP TABLE IF EXISTS retail_data;

SHOW VARIABLES LIKE 'secure_file_priv';

CREATE TABLE retail_data (
  InvoiceNo VARCHAR(20),
  StockCode VARCHAR(20),
  Description VARCHAR(255),
  Quantity INT,
  InvoiceDate VARCHAR(30),
  UnitPrice DECIMAL(10, 2),
  CustomerID VARCHAR(20),
  Country VARCHAR(50)
);


TRUNCATE TABLE retail_data;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/retail_data.csv'
INTO TABLE retail_data
CHARACTER SET latin1
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

USE retail_project;
SET SQL_SAFE_UPDATES = 0;
DELETE FROM retail_data WHERE Quantity <= 0;
DELETE FROM retail_data WHERE CustomerID IS NULL OR CustomerID = '';

SELECT
  DATE_FORMAT(STR_TO_DATE(InvoiceDate, '%m/%d/%Y %H:%i'), '%Y-%m-01') AS InvoiceMonth,
  SUM(Quantity * UnitPrice) AS TotalRevenue
FROM retail_data
GROUP BY InvoiceMonth
ORDER BY InvoiceMonth;

SELECT
  Description,
  SUM(Quantity * UnitPrice) AS TotalRevenue
FROM retail_data
GROUP BY Description
ORDER BY TotalRevenue DESC
LIMIT 10;

SELECT
  CustomerID,
  SUM(Quantity * UnitPrice) AS TotalRevenue
FROM retail_data
GROUP BY CustomerID
ORDER BY TotalRevenue DESC
LIMIT 10;

SELECT
  Country,
  SUM(Quantity * UnitPrice) AS TotalRevenue
FROM retail_data
GROUP BY Country
ORDER BY TotalRevenue DESC;