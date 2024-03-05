DROP TABLE if exists [H10].[dimProduct_stg]
go
CREATE TABLE [H10].[dimProduct_stg]
(
[id] [int] identity(1,1) not null
, [rowKey] [nvarchar](200) not null
, [productName] [nvarchar](50)
, [category] [nvarchar](50)
, [cost] [decimal](10,2)
, [price] [decimal](10,2)
-- CTRL
, [rowBatchKey] [int] not null
, [rowCreated] [datetime] not null default getutcdate()
, CONSTRAINT [pk_dimProduct_stg] PRIMARY KEY CLUSTERED ([id])
);
go
create unique index UIX_dimProduct_stg_BatchId_rowKey on [H10].[dimProduct_stg]
([rowBatchKey],[rowKey]);
go