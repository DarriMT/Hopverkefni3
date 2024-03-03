DROP TABLE if exists [H10].[dimStores]
go
CREATE TABLE [H10].[dimStores]
(
[id] [int] identity(1,1) not null
, [rowKey] [nvarchar](200) not null
, [name] [nvarchar](200)
, [city] [nvarchar](50)
, [location] [nvarchar](50) 
-- CTRL
, [rowBatchKey] [int] not null
, [rowCreated] [datetime] not null default getutcdate() 
, [rowModified] [datetime] not null default getutcdate()
, CONSTRAINT [pk_dimStores] PRIMARY KEY CLUSTERED ([id])
);
go
create unique index UIX_dimStores_rowKey on [H10].[dimStores] ([rowKey]);
go