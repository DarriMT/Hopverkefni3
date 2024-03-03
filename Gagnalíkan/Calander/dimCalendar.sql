-- Gamla

-- DROP TABLE if exists [H10].[dimCalendar]
-- go
-- CREATE TABLE [H10].[dimCalendar]
-- (
-- [id] [int] identity(1,1) not null
-- , [rowKey] [nvarchar](200) not null
-- , [date] [datetime] not null
-- , [year] [nvarchar] (4) not null
-- , [monthNo] int not null
-- , [monthName] [nvarchar](12) not null
-- , [YYYY-MM] [nvarchar](7) not null
-- , [week] int not null
-- , [yearWeek] [nvarchar](200) not null
-- -- CTRL
-- , [rowBatchKey] [int] not null
-- , [rowCreated] [datetime] not null default getutcdate()
-- , [rowModified] [datetime] not null default getutcdate()
-- , CONSTRAINT [pk_dimCalendar] PRIMARY KEY CLUSTERED ([id])
-- );
-- go
-- create unique index UIX_dimCalendar_rowKey on [H10].[dimCalendar] ([rowKey]);
-- go


-- Nýja 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [h10].[dimCalendar](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[calanderDate] [date] NOT NULL, -- endurskýrt því date er datatype
	[year] [nvarchar](4) NOT NULL,  
	[monthNo] [nvarchar](2) NOT NULL,
	[monthName] [nvarchar](12) NOT NULL,
	[YYYY-MM] [nvarchar](7) NOT NULL,
	[week] [nvarchar](2) NOT NULL,
	[yearWeek] [nvarchar](7) NOT NULL,
	[rowBatchKey] [int] NOT NULL,
	[rowCreated] [datetime] NOT NULL,
	[rowModified] [datetime] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [h10].[dimCalendar] ADD  CONSTRAINT [pk_dimCalendar] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE UNIQUE NONCLUSTERED INDEX [UIX_dimCalendar_date] ON [h10].[dimCalendar]
(
	[calanderDate] ASC -- betra að nota date dálkinn í UIX (hann gerir það líka þannig)
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [h10].[dimCalendar] ADD  DEFAULT (getutcdate()) FOR [rowCreated]
GO
ALTER TABLE [h10].[dimCalendar] ADD  DEFAULT (getutcdate()) FOR [rowModified]
GO
