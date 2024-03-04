DROP PROCEDURE IF EXISTS [H10].[dimStores_postprocess];
GO
CREATE PROCEDURE [H10].[dimStores_postprocess]
@BatchId INT
AS
BEGIN
    -- Delete rows from staging table that have been successfully published
    DELETE FROM [H10].[dimStores_stg]
    WHERE [rowBatchKey] = @BatchId;

    -- Return 1 to indicate success
    SELECT 1 AS ReturnValue;
END;
GO
