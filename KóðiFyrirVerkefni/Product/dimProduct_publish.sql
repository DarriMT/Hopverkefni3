DROP PROCEDURE IF EXISTS [H10].[dimProduct_publish];
GO
CREATE PROCEDURE [H10].[dimProduct_publish]
@BatchId INT
AS
BEGIN
    INSERT INTO ErrorLog (TableRowId, TableName, ColumnName, ErrorValue)
    SELECT 
        src.[rowKey] AS TableRowId,
        'dimProduct_stg' AS TableName,
        CASE
            WHEN src.[productName] IS NULL THEN 'productName'
            WHEN src.[category] IS NULL THEN 'category'
            WHEN src.[cost] IS NULL OR src.[cost] < 0 THEN 'cost'
            WHEN src.[price] IS NULL OR src.[price] < 0 THEN 'price'
        END AS ColumnName,
        CASE
            WHEN src.[productName] IS NULL THEN 'NULL'
            WHEN src.[category] IS NULL THEN 'NULL'
            WHEN src.[cost] IS NULL THEN 'NULL'
            WHEN src.[cost] < 0 THEN 'Negative Value'
            WHEN src.[price] IS NULL THEN 'NULL'
            WHEN src.[price] < 0 THEN 'Negative Value'
        END AS ErrorValue
    FROM [H10].[dimProduct_stg] src
    WHERE src.[rowBatchKey] = @BatchId
      AND (src.[productName] IS NULL OR 
           src.[category] IS NULL OR 
           src.[cost] IS NULL OR 
           src.[cost] < 0 OR 
           src.[price] IS NULL OR 
           src.[price] < 0);

    -- Delete rows from staging table
    DELETE FROM [H10].[dimProduct_stg]
    WHERE [rowBatchKey] = @BatchId
      AND ([productName] IS NULL OR 
           [category] IS NULL OR 
           [cost] IS NULL OR 
           [cost] < 0 OR 
           [price] IS NULL OR 
           [price] < 0);

    -- Proceed with the data manipulation (MERGE) if data quality checks pass
    MERGE INTO [H10].[dimProduct] TRG
    USING [H10].[dimProduct_stg] SRC
    ON SRC.rowKey = TRG.rowKey
    -- and src.rowBatchKey = @BatchId
    WHEN MATCHED THEN
        UPDATE SET [rowKey] = src.[rowKey],
                   [productName] = src.[productName],
                   [category] = src.[category],
                   [cost] = src.[cost],
                   [price] = src.[price],
                   [rowBatchKey] = src.[rowBatchKey],
                   [rowModified] = GETUTCDATE()
    WHEN NOT MATCHED THEN
        INSERT ([rowKey], [productName], [category],[cost], [price], [rowBatchKey])
        VALUES (src.[rowKey], src.[productName], src.[category], src.[cost], src.[price],src.[rowBatchKey]);
    -- Return 1 to indicate success
    SELECT 1 AS ReturnValue;
END;