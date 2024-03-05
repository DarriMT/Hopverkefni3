DROP TABLE if exists [H10].[factInventory_stg]
go
CREATE TABLE [H10].[factInventory_stg]
(
[id] [int] identity(1,1) not null
, [storeId] int not null
, [productId] int not null
, [inStock] int
-- CTRL
, [rowBatchKey] [int] not null
, [rowCreated] [datetime] not null default getutcdate()
, CONSTRAINT [pk_factInventory_stg] PRIMARY KEY CLUSTERED ([id])
);
go
-- create unique index UIX_factInventory_stg_BatchId_rowKey on [H10].[factInventory_stg]
-- ([rowBatchKey],[rowKey]);
-- go