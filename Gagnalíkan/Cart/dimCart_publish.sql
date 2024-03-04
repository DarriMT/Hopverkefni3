DROP PROCEDURE IF EXISTS [H10].[dimCart_publish];
GO
CREATE PROCEDURE [H10].[dimCart_publish]
@BatchId INT
AS
BEGIN
    -- Check for data quality before processing
    IF EXISTS (
        SELECT 1
        FROM [H10].[dimCart_stg]
        WHERE [rowBatchKey] = @BatchId
              AND ([receipt] IS NULL)
    )
    BEGIN
    INSERT INTO ErrorLog (TableRowId, TableName, ColumnName, ErrorValue)
    SELECT
        src.[rowKey] AS TableRowId,
        'dimCart_stg' AS TableName,
        CASE
            WHEN src.[receipt] IS NULL THEN 'receipt'
        END AS ColumnName,
        CASE
            WHEN src.[receipt] IS NULL THEN 'NULL'
        END AS ErrorValue
    FROM [H10].[dimCart_stg] src
    WHERE src.[rowBatchKey] = @BatchId
        AND ([receipt] IS NULL)
    END;

    -- Proceed with the data manipulation (MERGE) if data quality checks pass
    MERGE INTO [H10].[dimCart] TRG
    USING [H10].[dimCart_stg] SRC
    ON SRC.rowKey = TRG.rowKey
    -- and src.rowBatchKey = @BatchId
    WHEN MATCHED THEN
        UPDATE SET [receipt] = src.[receipt],
                   [rowBatchKey] = src.[rowBatchKey],
                   [rowModified] = GETUTCDATE()
    WHEN NOT MATCHED THEN
        INSERT ([rowKey], [receipt], [rowBatchKey])
        VALUES (src.[rowKey], src.[receipt], src.[rowBatchKey]);

    -- Return 1 to indicate success
    SELECT 1 AS ReturnValue;
END;
GO
