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
              AND ([calanderDate] IS NULL OR [year] IS NULL OR [monthNo] IS NULL OR [monthName] IS NULL OR [YYYY-MM] IS NULL OR [week] IS NULL OR [yearWeek] IS NULL)
    )
    BEGIN
    INSERT INTO ErrorLog (TableRowId, TableName, ColumnName, ErrorValue)
    SELECT
        src.[rowKey] AS TableRowId,
        'dimCalendar_stg' AS TableName,
    CASE
        WHEN src.[year] != DATENAME ( yyyy , src.[calanderDate] ) THEN "year"
        WHEN src.[monthNo] != DATENAME ( MM , src.[calanderDate] ) THEN 'monthNo'
        WHEN src.[monthName] != DATENAME ( MMMMM , src.[calanderDate] ) THEN 'monthName'
        WHEN src.[YYYY-MM] != FORMAT(src.[calanderDate], 'yyyy-MM') THEN 'YYYY-MM'
        WHEN src.[week] != DATEPART(iso_week, src.[calanderDate]) THEN 'week'
        WHEN src.[yearWeek] != FORMAT(src.[calanderDate], 'yyyy-' + DATEPART(iso_week, src.[calanderDate])) THEN 'yearWeek'
    END AS ColumnName,
        CASE
        WHEN src.[year] != DATENAME ( yyyy , src.[calanderDate] ) THEN "Wrong Format"
        WHEN src.[monthNo] != DATENAME ( MM , src.[calanderDate] ) THEN 'monthNWrong Format'
        WHEN src.[monthName] != DATENAME ( MMMMM , src.[calanderDate] ) THEN 'Wrong Format'
        WHEN src.[YYYY-MM] != FORMAT(src.[calanderDate], 'yyyy-MM') THEN 'Wrong Format'
        WHEN src.[week] != DATEPART(iso_week, src.[calanderDate]) THEN 'Wrong Format'
        WHEN src.[yearWeek] != FORMAT(src.[calanderDate], 'yyyy-' + DATEPART(iso_week, src.[calanderDate])) THEN 'Wrong Format'
        END AS ErrorValue
    FROM [H10].[dimCalendar_stg] src
    WHERE src.[rowBatchKey] = @BatchId
        AND ([calanderDate] IS NULL OR [year] IS NULL OR [monthNo] IS NULL OR [monthName] IS NULL OR [YYYY-MM] IS NULL OR [week] IS NULL OR [yearWeek] IS NULL)
    END;

    -- Proceed with the data manipulation (MERGE) if data quality checks pass
    MERGE INTO [H10].[dimCalendar] TRG
    USING [H10].[dimCalendar_stg] SRC
    ON SRC.rowKey = TRG.rowKey
    -- and src.rowBatchKey = @BatchId
    WHEN MATCHED THEN
        UPDATE SET [calanderDate] = src.[calanderDate],
                   [year] = src.[year],
                   [monthNo] = src.[monthNo],
                   [monthName] = src.[monthName],
                   [YYYY-MM] = src.[YYYY-MM],
                   [week] = src.[week],
                   [yearWeek] = src.[yearWeek],
                   [rowBatchKey] = src.[rowBatchKey],
                   [rowModified] = GETUTCDATE()
    WHEN NOT MATCHED THEN
        INSERT ([rowKey], [calanderDate], [year], [monthNo], [monthName], [YYYY-MM], [week], [yearWeek], [rowBatchKey])
        VALUES (src.[rowKey], src.[calanderDate], src.[year], src.[monthNo], src.[monthName], src.[YYYY-MM], src.[week], src.[yearWeek], src.[rowBatchKey]);
    -- Return 1 to indicate success
    SELECT 1 AS ReturnValue;
END;
GO
