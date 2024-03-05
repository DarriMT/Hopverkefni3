
-- Lager upplýsingar niður á búð og vöru
SELECT 
    fi.storeId,
    ds.name AS storeName,
    fi.productId,
    dp.productName,
    SUM(fi.inStock) AS totalInStock
FROM 
    factInventory fi
JOIN 
    dimProduct dp ON fi.productId = dp.id
JOIN 
    dimStores ds ON fi.storeId = ds.id
GROUP BY 
    fi.storeId, ds.name, fi.productId, dp.productName;
