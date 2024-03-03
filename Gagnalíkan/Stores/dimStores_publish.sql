DROP PROCEDURE IF EXISTS [H10].[dimStores_publish];
GO
CREATE PROCEDURE [H10].[dimStores_publish]
@BatchId INT
AS
BEGIN
    -- Check for data quality before processing
    IF EXISTS (
        SELECT 1
        FROM [H10].[dimStores_stg]
        WHERE [rowBatchKey] = @BatchId
              AND ([name] IS NULL OR [city] IS NULL OR [location] IS NULL)
    )
    BEGIN
    INSERT INTO ErrorLog (TableRowId, TableName, ColumnName, ErrorValue)
    SELECT
        src.[rowKey] AS TableRowId,
        'dimStores_stg' AS TableName,
        CASE
            WHEN src.[name] IS NULL THEN 'name'
            WHEN src.[city] IS NULL THEN 'city'
            WHEN src.[location] IS NULL THEN 'location'
        END AS ColumnName,
        CASE
            WHEN src.[name] IS NULL THEN 'NULL'
            WHEN src.[city] IS NULL THEN 'NULL'
            WHEN src.[location] IS NULL THEN 'NULL'
        END AS ErrorValue
    FROM [H10].[dimStores_stg] src
    WHERE src.[rowBatchKey] = @BatchId
        AND ([name] IS NULL OR [city] IS NULL OR [location] IS NULL)
    RETURN 0;
    END;

    -- Proceed with the data manipulation (MERGE) if data quality checks pass
    MERGE INTO [H10].[dimStores] TRG
    USING [H10].[dimStores_stg] SRC
    ON SRC.rowKey = TRG.rowKey
    -- and src.rowBatchKey = @BatchId
    WHEN MATCHED THEN
        UPDATE SET [name] = src.[name],
                   [city] = src.[city],
                   [location] = src.[location],
                   [rowBatchKey] = src.[rowBatchKey],
                   [rowModified] = GETUTCDATE()
    WHEN NOT MATCHED THEN
        INSERT ([rowKey],  [name], [city], [location], [rowBatchKey])
        VALUES (src.[rowKey], src.[name], src.[city], src.[location], src.[rowBatchKey]);

    -- Return 1 to indicate success
    SELECT 1 AS ReturnValue;
END;
GO
