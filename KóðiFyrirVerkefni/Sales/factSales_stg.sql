DROP TABLE if exists [H10].[factSales_stg]
go
CREATE TABLE [H10].[factSales_stg]
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
, CONSTRAINT [pk_factSales_stg] PRIMARY KEY CLUSTERED ([id])
);
go
-- create unique index UIX_factSales_stg_BatchId_rowKey on [H10].[factSales_stg]
-- ([rowBatchKey],[rowKey]);
-- go