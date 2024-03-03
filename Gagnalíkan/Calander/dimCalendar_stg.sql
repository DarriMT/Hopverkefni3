DROP TABLE if exists [H10].[dimCalendar_stg]
go
CREATE TABLE [H10].[dimCalendar_stg]
(
[id] [int] identity(1,1) not null
, [rowKey] [nvarchar](200) not null
, [date] [datetime]
, [year] int
, [monthNo] int
, [monthName] [nvarchar](12)
, [YYYY-MM] [nvarchar](7)
, [week] int
, [yearWeek] [nvarchar](200)
-- CTRL
, [rowBatchKey] [int] not null
, [rowCreated] [datetime] not null default getutcdate()
, CONSTRAINT [pk_dimCalendar_stg] PRIMARY KEY CLUSTERED ([id])
);
go
create unique index UIX_dimCalendar_stg_BatchId_rowKey on [H10].[dimCalendar_stg]
([rowBatchKey],[rowKey]);
go