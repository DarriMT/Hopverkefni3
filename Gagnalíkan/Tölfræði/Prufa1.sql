-- Fjöldi seldra eininga eftir dag
SELECT DATE, SUM(unitsSold) AS totalUnitsSold
FROM [H10].[factSales]
GROUP BY DATE
ORDER BY DATE;

-- Fjöldi seldra eininga eftir viku
SELECT YEAR(DATE) AS year, DATEPART(ISO_WEEK, DATE) AS week, SUM(unitsSold) AS totalUnitsSold
FROM [H10].[factSales]
GROUP BY YEAR(DATE), DATEPART(ISO_WEEK, DATE)
ORDER BY year, week;

-- Fjöldi seldra eininga eftir mánuð
SELECT YEAR(DATE) AS year, MONTH(DATE) AS month, SUM(unitsSold) AS totalUnitsSold
FROM [H10].[factSales]
GROUP BY YEAR(DATE), MONTH(DATE)
ORDER BY year, month;


-- Fjöldi seldra eininga eftir ári
SELECT YEAR(DATE) AS year, SUM(unitsSold) AS totalUnitsSold
FROM [H10].[factSales]
GROUP BY YEAR(DATE)
ORDER BY year;
