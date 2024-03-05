DROP PROCEDURE IF EXISTS [H10].[factSales_publish];
GO
CREATE PROCEDURE [H10].[factSales_publish]
@BatchId INT
AS
BEGIN
    -- Check for data quality before processing
    -- IF EXISTS (
    --     SELECT 1
    --     FROM [H10].[factSales_stg]
    --     WHERE [rowBatchKey] = @BatchId
    --           AND ([storeId] IS NULL OR [productId] IS NULL OR [date] IS NULL 
    --           OR [receipt] IS NULL OR [unitsSold] IS NULL)
    -- )
    BEGIN
    INSERT INTO ErrorLog (TableRowId, TableName, ColumnName, ErrorValue)
    SELECT
        src.rowBatchKey AS TableRowId,
        'factSales_stg' AS TableName,
        CASE
            WHEN src.[storeId] IS NULL THEN 'storeId'
            WHEN src.[productId] IS NULL THEN 'productId'
            WHEN src.[date] IS NULL THEN 'date'
            WHEN src.[receipt] IS NULL THEN 'receipt'
            WHEN src.[unitsSold] IS NULL THEN 'unitsSold'
        END AS ColumnName,
        CASE
            WHEN src.[storeId] IS NULL THEN 'NULL'
            WHEN src.[productId] IS NULL THEN 'NULL'
            WHEN src.[date] IS NULL THEN 'NULL'
            WHEN src.[receipt] IS NULL THEN 'NULL'
            WHEN src.[unitsSold] IS NULL THEN 'NULL'
        END AS ErrorValue
    FROM [H10].[factSales_stg] src
    WHERE src.[rowBatchKey] = @BatchId
        AND ([storeId] IS NULL OR [productId] IS NULL OR [date] IS NULL 
        OR [receipt] IS NULL OR [unitsSold] IS NULL)
    END;

    -- Proceed with the data manipulation (MERGE) if data quality checks pass
    MERGE INTO [H10].[factSales] TRG
    USING [H10].[factSales_stg] SRC
    ON SRC.rowBatchKey = @BatchId
    WHEN MATCHED THEN
        UPDATE SET [storeId] = src.[storeId],
                   [productId] = src.[productId],
                   [date] = src.[date],
                   [receipt] = src.[receipt],
                   [unitsSold] = src.[unitsSold],
                   [rowBatchKey] = src.[rowBatchKey]
    WHEN NOT MATCHED THEN
        INSERT ( [storeId], [productId], [date], [rowBatchKey],
                [receipt], [unitsSold])
        VALUES (src.[storeId], src.[productId], src.[date], 
                src.[rowBatchKey], src.[receipt], src.[unitsSold]);

    -- Return 1 to indicate success
    SELECT 1 AS ReturnValue;
END;
GO
