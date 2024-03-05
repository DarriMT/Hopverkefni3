DROP PROCEDURE IF EXISTS [H10].[dimCalendar_postprocess];
GO
CREATE PROCEDURE [H10].[dimCalendar_postprocess]
@BatchId INT
AS
BEGIN
    -- Delete rows from staging table that have been successfully published
    DELETE FROM [H10].[dimCalendar_stg]
    WHERE [rowBatchKey] = @BatchId;

    -- If necessary, add additional post-processing steps here

    -- Return 1 to indicate success
    SELECT 1 AS ReturnValue;
END;
GO
