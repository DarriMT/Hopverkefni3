DROP TABLE if exists [H10].[dimCart_stg]
go
CREATE TABLE [H10].[dimCart_stg]
(
[id] [int] identity(1,1) not null
, [rowKey] [nvarchar](200) not null
, [receipt] [nvarchar](200)
-- CTRL
, [rowBatchKey] [int] not null
, [rowCreated] [datetime] not null default getutcdate()
, CONSTRAINT [pk_dimCart_stg] PRIMARY KEY CLUSTERED ([id])
);
go
create unique index UIX_dimCart_stg_BatchId_rowKey on [H10].[dimCart_stg]
([rowBatchKey],[rowKey]);
go