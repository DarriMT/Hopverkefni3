DROP PROCEDURE IF EXISTS [H10].[dimCalendar_publish];
GO
CREATE PROCEDURE [H10].[dimCalendar_publish]
@BatchId INT
AS
BEGIN
    -- Check for data quality before processing
    IF EXISTS (
        SELECT 1
        FROM [H10].[dimCalendar_stg]
        WHERE [rowBatchKey] = @BatchId
              AND ([date] IS NULL OR [year] IS NULL OR [monthNo] IS NULL OR [monthName] IS NULL OR [YYYY-MM] IS NULL OR [week] IS NULL OR [yearWeek] IS NULL)
    )
    BEGIN
    INSERT INTO ErrorLog (TableRowId, TableName, ColumnName, ErrorValue)
    SELECT
        src.[id] AS TableRowId,
        'dimCalendar_stg' AS TableName,
    CASE
        WHEN src.[year] != DATENAME ( yyyy , src.[date] ) THEN "year"
        WHEN src.[monthNo] != DATENAME ( MM , src.[date] ) THEN 'monthNo'
        WHEN src.[monthName] != DATENAME ( month , src.[date] ) THEN 'monthName'
        WHEN src.[YYYY-MM] != FORMAT(src.[date], 'YYYY-MM') THEN 'YYYY-MM'
        WHEN src.[week] != DATEPART(iso_week, src.[date]) THEN 'week'
        WHEN src.[yearWeek] != FORMAT(src.[date], 'yyyy-' + convert(varchar(2), DATEPART(iso_week, src.[date]))) THEN 'yearWeek'
    END AS ColumnName,
        CASE
        WHEN src.[year] != DATENAME ( yyyy , src.[date] ) THEN "year"
        WHEN src.[monthNo] != DATENAME ( MM , src.[date] ) THEN 'monthNo'
        WHEN src.[monthName] != DATENAME ( month , src.[date] ) THEN 'monthName'
        WHEN src.[YYYY-MM] != FORMAT(src.[date], 'yyyy-MM') THEN 'YYYY-MM'
        WHEN src.[week] != DATEPART(iso_week, src.[date]) THEN 'week'
        WHEN src.[yearWeek] != FORMAT(src.[date], 'yyyy-' + Convert(varchar(2),DATEPART(iso_week, src.[date]))) THEN 'yearWeek'
        END AS ErrorValue
    FROM [H10].[dimCalendar_stg] src
    WHERE src.[rowBatchKey] = @BatchId
        AND ([date] IS NULL OR [year] IS NULL OR [monthNo] IS NULL OR [monthName] IS NULL OR [YYYY-MM] IS NULL OR [week] IS NULL OR [yearWeek] IS NULL)
    Return 0;
    END;

-- Proceed with the data manipulation (MERGE) if data quality checks pass
    MERGE INTO [H10].[dimCalendar] TRG
    USING [H10].[dimCalendar_stg] SRC
    ON SRC.id = TRG.id
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
        INSERT ([date], [year], [monthNo], [monthName], [YYYY-MM], [week], [yearWeek], [rowBatchKey])
        VALUES ( src.[date], src.[year], src.[monthNo], src.[monthName], src.[YYYY-MM], src.[week], src.[yearWeek], src.[rowBatchKey]);
    -- Return 1 to indicate success
    SELECT 0 AS ReturnValue;
    -- SELECT 1 AS ReturnValue;
END;
GO
