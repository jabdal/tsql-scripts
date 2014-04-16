USE [msdb]

CREATE procedure dbo.sp_ExecAt
(
	@desc varchar(87) = '',
	@SQL varchar(max)='insert into mytable 1',
	@DayOffset int = 0,
	@HourOffset int = 0,
	@MinuteOffset int = 1
)
AS
	declare @start_time int=(select replace(convert(varchar(8),DATEADD(hour,@HourOffset,DATEADD(minute,@MinuteOffset,getdate())),108),':',''))

	declare @DayOfWeek varchar(10)=(select datename(dw,DATEADD(day,@DayOffset,getdate())))
	if @DayOfWeek='Saturday' set @DayOffset = @DayOffset + 2
	else if @DayOfWeek='Sunday' set @DayOffset = @DayOffset + 1

	declare @start_date int=(select convert(varchar(10),dateadd(day,@DayOffset,getdate()),112))

	declare @job varchar(128)= 'JOB '+@desc+' '+cast(NEWID()as char(36))

	declare @schedule varchar(128)= 'SCHEDULE '+cast(NEWID()as char(36))
	declare @step varchar(128)= 'STEP '+cast(NEWID()as char(36))

	exec sp_add_job @job_name=@job, @delete_level=1

	exec sp_add_jobstep 
	@job_name=@job,
	@step_name=@step,
	@command = @SQL;

	exec sp_add_schedule @schedule_name=@schedule, @freq_type=1, @active_start_time=@start_time, @active_start_date=@start_date;
	exec sp_attach_schedule @job_name=@job, @schedule_name=@schedule;
	exec sp_add_jobserver @job_name=@job;
	
	return

GO


