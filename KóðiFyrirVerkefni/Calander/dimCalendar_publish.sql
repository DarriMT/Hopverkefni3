DROP PROCEDURE IF EXISTS [H10].[dimCalendar_publish];
GO
CREATE PROCEDURE [H10].[dimCalendar_publish]
@BatchId INT
AS
BEGIN
    -- Check for data quality before processing
    -- IF EXISTS (
    --     SELECT 1
    --     FROM [H10].[dimCalendar_stg]
    --     WHERE [rowBatchKey] = @BatchId
    --           AND ([date] IS NULL OR [year] IS NULL OR [monthNo] IS NULL OR [monthName] IS NULL OR [YYYY-MM] IS NULL OR [week] IS NULL OR [yearWeek] IS NULL)
    -- )
    BEGIN
    INSERT INTO ErrorLog (TableRowId, TableName, ColumnName, ErrorValue)
    SELECT
        src.[rowKey] AS TableRowId,
        'dimCalendar_stg' AS TableName,
        CASE
            WHEN src.[date] IS NULL THEN 'date'
            WHEN src.[year] IS NULL THEN 'year'
            WHEN src.[monthNo] IS NULL THEN 'monthNo'
            WHEN src.[monthName] IS NULL THEN 'monthName'
            WHEN src.[YYYY-MM] IS NULL THEN 'YYYY-MM'
            WHEN src.[week] IS NULL THEN 'week'
            WHEN src.[yearWeek] IS NULL THEN 'yearWeek'
        END AS ColumnName,
        CASE
            WHEN src.[date] IS NULL THEN 'NULL'
            WHEN src.[year] IS NULL THEN 'NULL'
            WHEN src.[monthNo] IS NULL THEN 'NULL'
            WHEN src.[monthName] IS NULL THEN 'NULL'
            WHEN src.[YYYY-MM] IS NULL THEN 'NULL'
            WHEN src.[week] IS NULL THEN 'NULL'
            WHEN src.[yearWeek] IS NULL THEN 'NULL'
        END AS ErrorValue
    FROM [H10].[dimCalendar_stg] src
    WHERE src.[rowBatchKey] = @BatchId
        AND ([date] IS NULL OR [year] IS NULL OR [monthNo] IS NULL OR [monthName] IS NULL OR [YYYY-MM] IS NULL OR [week] IS NULL OR [yearWeek] IS NULL)
    END;

    -- Proceed with the data manipulation (MERGE) if data quality checks pass
    MERGE INTO [H10].[dimCalendar] TRG
    USING [H10].[dimCalendar_stg] SRC
    ON SRC.rowKey = TRG.rowKey
    -- and src.rowBatchKey = @BatchId
    WHEN MATCHED THEN
        UPDATE SET [date] = src.[date],
                   [year] = src.[year],
                   [monthNo] = src.[monthNo],
                   [monthName] = src.[monthName],
                   [YYYY-MM] = src.[YYYY-MM],
                   [week] = src.[week],
                   [yearWeek] = src.[yearWeek],
                   [rowBatchKey] = src.[rowBatchKey],
                   [rowModified] = GETUTCDATE()
    WHEN NOT MATCHED THEN
        INSERT ([rowKey], [date], [year], [monthNo], [monthName], [YYYY-MM], [week], [yearWeek], [rowBatchKey])
        VALUES (src.[rowKey], src.[date], src.[year], src.[monthNo], src.[monthName], src.[YYYY-MM], src.[week], src.[yearWeek], src.[rowBatchKey]);
    -- Return 1 to indicate success
    SELECT 1 AS ReturnValue;
END;
GO
