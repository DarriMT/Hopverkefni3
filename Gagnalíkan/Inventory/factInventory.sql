DROP TABLE if exists [H10].[factInventory]
go
CREATE TABLE [H10].[factInventory]
(
[id] [int] identity(1,1) not null
, [storeId] int not null
, [productId] int not null
, [inStock] int
-- CTRL
, [rowBatchKey] [int] not null
, [rowCreated] [datetime] not null default getutcdate()
, CONSTRAINT [pk_factInventory] PRIMARY KEY CLUSTERED ([id])
);
go
-- create unique index UIX_factInventory_rowKey on [H10].[factInventory] ([rowKey]);
-- go