DROP TABLE if exists [H10].[factSales]
go
CREATE TABLE [H10].[factSales]
(
[id] [int] identity(1,1) not null
, [date] [datetime] not null
, [storeId] int not null
, [productId] int not null
, [receipt] [nvarchar](200)
, [unitsSold] int
-- CTRL
, [rowBatchKey] [int] not null
, [rowCreated] [datetime] not null default getutcdate()
-- , [rowModified] [datetime] not null default getutcdate()
, CONSTRAINT [pk_factSales] PRIMARY KEY CLUSTERED ([id])
);
go
-- create unique index UIX_factSales_rowKey on [H10].[factSales] ([rowKey]);
-- go