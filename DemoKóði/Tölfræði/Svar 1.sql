-- Fjöldi seldra eininga eftir ári fyrir ákveðna búð
SELECT YEAR(f.date) AS year, s.name AS storeName, p.productName, SUM(f.unitsSold) AS totalUnitsSold
FROM [H10].[factSales] f
INNER JOIN [H10].[dimStores] s ON f.storeId = s.id
INNER JOIN [H10].[dimProduct] p ON f.productId = p.id
WHERE s.name = 'Maven Toys Aguascalientes 1' AND YEAR(f.date) = 2021
GROUP BY YEAR(f.date), s.name, p.productName
ORDER BY year, storeName, productName;


-- Fjöldi seldra eininga eftir ákveðnum degi fyrir ákveðna búð
SELECT CAST(f.date AS DATE) AS day, s.name AS storeName, p.productName, SUM(f.unitsSold) AS totalUnitsSold
FROM [H10].[factSales] f
INNER JOIN [H10].[dimStores] s ON f.storeId = s.id
INNER JOIN [H10].[dimProduct] p ON f.productId = p.id
WHERE s.name = 'Maven Toys Aguascalientes 1' AND CAST(f.date AS DATE) = '2021-01-02'
GROUP BY CAST(f.date AS DATE), s.name, p.productName
ORDER BY day, storeName, productName;

-- Fjöldi seldra eininga eftir viku fyrir ákveðna búð og vöru
SELECT DATEPART(ISO_WEEK, f.date) AS week, s.name AS storeName, p.productName, SUM(f.unitsSold) AS totalUnitsSold
FROM [H10].[factSales] f
INNER JOIN [H10].[dimStores] s ON f.storeId = s.id
INNER JOIN [H10].[dimProduct] p ON f.productId = p.id
WHERE s.name = 'Maven Toys Aguascalientes 1' AND p.productName = 'Nerf Gun'
GROUP BY DATEPART(ISO_WEEK, f.date), s.name, p.productName
ORDER BY week, storeName, productName;

-- Fjöldi seldra eininga eftir mánuði fyrir ákveðna búð og vöru
SELECT MONTH(f.date) AS month, s.name AS storeName, p.productName, SUM(f.unitsSold) AS totalUnitsSold
FROM [H10].[factSales] f
INNER JOIN [H10].[dimStores] s ON f.storeId = s.id
INNER JOIN [H10].[dimProduct] p ON f.productId = p.id
WHERE s.name = 'Maven Toys Aguascalientes 1' AND p.productName = 'Nerf Gun'
GROUP BY MONTH(f.date), s.name, p.productName
ORDER BY month, storeName, productName;
