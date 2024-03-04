-- 1. Skref eitt bæta við profit í factSales töfluna
-- Búum til sér dálk fyrir hagnað í factSales töflunni
ALTER TABLE [H10].[factSales]
ADD [profit] [decimal](10,2);




-- 2. Skref tvö reikna og bæta við hagnað í factSales töfluna
-- Reiknum út hagnað og uppfærum dálkinn og ef það er ekki hægt að reikna út hagnað þá setjum við hann sem NULL
-- t.d. ef varan er ekki til eins og vara nr. 35+, NULL í price eða cost eða ef price eða cost eru neikvæðar tölur
UPDATE [H10].[factSales]
SET [profit] = CASE
	WHEN p.[cost] IS NOT NULL AND p.[price] IS NOT NULL AND p.[cost] >= 0 AND p.[price] >= 0 THEN
		CASE
			WHEN p.[price] - p.[cost] >= 0 THEN (p.[price] - p.[cost]) * s.[unitsSold]
			ELSE NULL
		END
	ELSE NULL
END
FROM [H10].[factSales] s
JOIN [H10].[dimProduct] p
ON s.[productId] = p.[id];






-- 3. Skref 3 nota ErrorLog töfluna til þess að eyða vesena röðum úr factSales töflunni
DELETE FROM [H10].[factSales]
FROM [H10].[factSales] s
WHERE EXISTS (
    SELECT 1
    FROM ErrorLog el
    WHERE el.TableName = 'dimProduct_stg' 
    AND (el.ErrorValue = 'NULL' OR el.ErrorValue = 'Negative Value')
    AND el.TableRowId = s.productId
);
