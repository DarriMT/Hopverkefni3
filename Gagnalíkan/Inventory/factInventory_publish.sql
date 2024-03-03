DROP PROCEDURE IF EXISTS [H10].[factInventory_publish];
GO
CREATE PROCEDURE [H10].[factInventory_publish]
@BatchId INT
AS
BEGIN
    -- Check for data quality before processing
    IF EXISTS (
        SELECT 1
        FROM [H10].[factInventory_stg]
        WHERE [rowBatchKey] = @BatchId
              AND ([storeId] IS NULL OR [productId] IS NULL OR [inStock] IS NULL)
    )
    BEGIN
    INSERT INTO ErrorLog (TableRowId, TableName, ColumnName, ErrorValue)
    SELECT
        src.rowBatchKey AS TableRowId,
        'factInventory_stg' AS TableName,
        CASE
            WHEN src.[storeId] IS NULL THEN 'storeId'
            WHEN src.[productId] IS NULL THEN 'productId'
            WHEN src.[inStock] IS NULL THEN 'inStock'
        END AS ColumnName,
        CASE
            WHEN src.[storeId] IS NULL THEN 'NULL'
            WHEN src.[productId] IS NULL THEN 'NULL'
            WHEN src.[inStock] IS NULL THEN 'NULL'
        END AS ErrorValue
    FROM [H10].[factInventory_stg] src
    WHERE src.[rowBatchKey] = @BatchId
        AND ([storeId] IS NULL OR [productId] IS NULL OR [inStock] IS NULL)
    SELECT 0 AS ReturnValue BREAK;
    -- RETURN 0;
    END;


    -- Proceed with the data manipulation (MERGE) if data quality checks pass
    MERGE INTO [H10].[factInventory] TRG
    USING [H10].[factInventory_stg] SRC
    ON src.rowBatchKey = @BatchId
    WHEN MATCHED THEN
        UPDATE SET [storeId] = src.[storeId],
                   [productId] = src.[productId],
                   [inStock] = src.[inStock],
                   [rowBatchKey] = src.[rowBatchKey]
    WHEN NOT MATCHED THEN
        INSERT ( [storeId], [productId], [inStock], [rowBatchKey])
        VALUES ( src.[storeId], src.[productId], src.[inStock], src.[rowBatchKey]);

    -- Return 1 to indicate success
    SELECT 1 AS ReturnValue;
END;
GO
