DROP PROCEDURE IF EXISTS [H10].[dimProduct_postprocess];
GO
CREATE PROCEDURE [H10].[dimProduct_postprocess]
@BatchId INT
AS
BEGIN
    -- Delete rows from staging table that have been successfully published
    DELETE FROM [H10].[dimProduct_stg]
    WHERE [rowBatchKey] = @BatchId;

    -- Return 1 to indicate success
    SELECT 1 AS ReturnValue;
END;
GO
