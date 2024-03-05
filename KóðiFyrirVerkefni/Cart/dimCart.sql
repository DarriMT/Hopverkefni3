DROP TABLE if exists [H10].[dimCart]
go
CREATE TABLE [H10].[dimCart]
(
[id] [int] identity(1,1) not null
, [rowKey] [nvarchar](200) not null
, [receipt] [nvarchar](50)
-- CTRL
, [rowBatchKey] [int] not null
, [rowCreated] [datetime] not null default getutcdate()
, [rowModified] [datetime] not null default getutcdate()
, CONSTRAINT [pk_dimCart] PRIMARY KEY CLUSTERED ([id])
);
go
create unique index UIX_dimCart_rowKey on [H10].[dimCart] ([rowKey]);
go