-- Id, tableRowId, tableName, columnName, errorValue
-- 1,       3,      Product,   Price,     Null 

CREATE TABLE ErrorLog (
    Id INT PRIMARY KEY IDENTITY(1,1),
    TableRowId INT,
    TableName VARCHAR(255),
    ColumnName VARCHAR(255),
    ErrorValue VARCHAR(255),
)