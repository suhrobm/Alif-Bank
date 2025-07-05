use [transrepository]
go


create procedure [dbo].[sp_book_office] (
											@cabinetnumber int, 
											@starttime    datetime, 
											@endtime      datetime,
											@fullname     nvarchar(100)

		) 
as
	set nocount on

    declare @occupiedby     nvarchar(100)
    declare @occupieduntil  datetime
	declare @email          nvarchar(100)
	declare @phonenumber    nvarchar(20)
	declare @cabinetid      int 
	declare @employeeid     int
	declare @emailtext      nvarchar(150)

	
		   	  
    -- checking the status of the cabinet, whether it is booked or not
    select  @occupiedby = tt.fullname
	      , @occupieduntil = t.endtime 
	from t_bookings t inner join t_employees tt on t.employeeid = tt.employeeid
	                  inner join t_cabinets ts on t.cabinetid = ts.cabinetid
    where     ts.cabinetnumber = @cabinetnumber
          and (
			   (@starttime >= starttime and @starttime < endtime) or
               (@endtime > starttime and @endtime <= endtime) or
               (starttime >= @starttime and endtime <= @endtime)
			  )

    -- in case if it is already booked
    if @occupiedby is not null
    begin

		select  @email = email 
		from t_employees t where t.fullname = @fullname

	    -- printing on output
		print 'The cabinet is occupied by ' + @occupiedby + ' until ' + convert(nvarchar, @occupieduntil)

		-- sending notification via email
        set @emailtext = 'The cabinet is occupied by ' + @occupiedby + ' until ' + convert(nvarchar, @occupieduntil)
		exec msdb.dbo.sp_send_dbmail  @profile_name = 'AlifBank',
									  @recipients = @email,
									  @subject = 'Booking Cabinet',
									  @body = @emailtext
	
	end

	-- in case when it is available then we book the cabinet
    else
    begin

	    select  @email = email 
		      , @phonenumber = phonenumber 
		      , @employeeid  = employeeid
		from t_employees t where t.fullname = @fullname

	    select  @cabinetid  = cabinetid
		from t_cabinets t where t.cabinetnumber = @cabinetnumber


        insert into t_bookings (cabinetid, employeeid, starttime, endtime) values (@cabinetid, @employeeid, @starttime, @endtime)		


        -- printing on output
        print       'Notification sent to ' + @fullname + ' at ' + @email + ' and ' + @phonenumber + 
					' for booking cabinet ' + convert(nvarchar, @cabinetnumber) + ' from ' + convert(nvarchar, @starttime) + 
					' to ' + convert(nvarchar, @endtime);

	    -- sending notification via email
        set @emailtext =  'Notification sent to ' + @fullname + ' at ' + @email + ' and ' + @phonenumber + 
						  ' for booking cabinet ' + convert(nvarchar, @cabinetnumber) + ' from ' + convert(nvarchar, @starttime) + 
						  ' to ' + convert(nvarchar, @endtime);
        exec msdb.dbo.sp_send_dbmail  @profile_name = 'AlifBank',
									  @recipients = @email,
									  @subject = 'Booking Cabinet',
									  @body = @emailtext

    end

go
