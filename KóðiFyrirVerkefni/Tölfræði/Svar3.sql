-- 1. 
-- Meðal velta fyrir hverja körfu
SELECT
    receipt AS receipt,
    ROUND(AVG(profit), 2) AS AverageProfit
FROM
    factSales
GROUP BY
    receipt;





-- 2. 
-- Meðal upphæð körfu

-- Step 1: Find all the unique receipts
SELECT DISTINCT receipt
INTO #UniqueReceipts
FROM factSales;

-- Step 2: Find all the products and units sold for each receipt
SELECT 
    fs.receipt,
    fs.productId,
    fs.unitsSold,
    dp.price
INTO #ReceiptDetails
FROM 
    factSales fs
INNER JOIN 
    dimProduct dp ON fs.productId = dp.id
WHERE 
    dp.price > 0; -- Skip null or negative prices

-- Step 3: Sum the total price for each receipt from the products table
SELECT 
    rd.receipt,
    SUM(rd.unitsSold * rd.price) AS totalPrice
INTO #ReceiptTotalPrice
FROM 
    #ReceiptDetails rd
GROUP BY 
    rd.receipt;

-- Step 4: Calculate average cart amount for each receipt
SELECT 
    r.receipt,
    AVG(r.totalPrice) AS averageCartAmount
FROM 
    #ReceiptTotalPrice r
GROUP BY 
    r.receipt;

-- Drop temporary tables
DROP TABLE #UniqueReceipts;
DROP TABLE #ReceiptDetails;
DROP TABLE #ReceiptTotalPrice;





-- 3.
-- Meðal fjölda keyptra hluta per körfu
-- Step 1: Find all the unique receipts


SELECT DISTINCT receipt
INTO #UniqueReceipts
FROM factSales;

-- Step 2: Count the number of items sold for each receipt
SELECT 
    fs.receipt,
    COUNT(*) AS itemCount
INTO #ReceiptItemCount
FROM 
    factSales fs
GROUP BY 
    fs.receipt;

-- Step 3: Calculate average number of items per cart for each receipt
SELECT 
    ri.receipt,
    AVG(ri.itemCount) AS averageItemsPerCart
FROM 
    #ReceiptItemCount ri
GROUP BY 
    ri.receipt;

-- Drop temporary tables
DROP TABLE #UniqueReceipts;
DROP TABLE #ReceiptItemCount;
