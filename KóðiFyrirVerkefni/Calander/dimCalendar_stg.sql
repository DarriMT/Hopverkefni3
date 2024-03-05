DROP TABLE if exists [H10].[dimCalendar_stg]
go
CREATE TABLE [H10].[dimCalendar_stg]
(
[id] [int] identity(1,1) not null,
    [rowKey] [nvarchar](200) ,
	[date] [date], 
	[year] [nvarchar](4) ,  
	[monthNo] [nvarchar](2) ,
	[monthName] [nvarchar](12),
	[YYYY-MM] [nvarchar](7) ,
	[week] [nvarchar](2) 
    ,[yearWeek] [nvarchar](7)
-- CTRL
, [rowBatchKey] [int] not null
, [rowCreated] [datetime] not null default getutcdate()
, CONSTRAINT [pk_dimCalendar_stg] PRIMARY KEY CLUSTERED ([id])
);
go
create unique index UIX_dimCalendar_stg_BatchId_rowKey on [H10].[dimCalendar_stg]
([rowBatchKey],[rowKey]);
go
