DROP TABLE if exists [H10].[dimProduct]
go
CREATE TABLE [H10].[dimProduct]
(
[id] [int] identity(1,1) not null
, [rowKey] [nvarchar](200) not null
, [productName] [nvarchar](50) not null
, [category] [nvarchar](50) not null
, [cost] [decimal](10,2) not null
, [price] [decimal](10,2) not null
-- CTRL
, [rowBatchKey] [int] not null
, [rowCreated] [datetime] not null default getutcdate()
, [rowModified] [datetime] not null default getutcdate()
, CONSTRAINT [pk_dimProduct] PRIMARY KEY CLUSTERED ([id])
);
go
create unique index UIX_dimProduct_rowKey on [H10].[dimProduct] ([rowKey]);
go
