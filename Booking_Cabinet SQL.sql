

/* Booking Office */

/* 

To achieve this task in T-SQL (Transact-SQL), we can follow the process below. 

1. let us create three tables such as t_users, t_offices, and t_bookings 
2. checking availability of the office by creating a store procedure;
            -- if an office is available then it allows to book an office and sends a notification about details
			-- if an office is not available (i.e. if it is already booked) then sends a notification about details 

*/


/* creating the table structure for three tables */
---------------------------------------------------

-- the t_employees is a static table, the records are predefined
create table t_employees (
							employeeid int primary key identity,
							fullname nvarchar(100),
							email nvarchar(100),
							phonenumber nvarchar(20)
					    )
					 
-- the t_cabinets is a static table, the records are predefined
create table t_cabinets (
						  cabinetid int primary key identity,
						  cabinetnumber nvarchar(50)
                       )

-- the t_bookings is a historical table, the records are being increased
create table t_bookings (
							bookingid int primary key identity,
							cabinetid int,
							employeeid int,
							starttime datetime,
							endtime datetime,
							foreign key (cabinetid) references t_cabinets(cabinetid) on update cascade,
							foreign key (employeeid) references t_employees(employeeid) on update cascade
						)
---------------------------------------------------

select * from t_employees

select * from t_cabinets

select * from t_bookings 

--delete from t_bookings


/* calling the store procedure */
---------------------------------------------------

exec transrepository.dbo.sp_book_office 101, '2023-10-15 10:00:00', '2023-10-15 11:00:00', 'Zebo Shirinova'

exec transrepository.dbo.sp_book_office 102, '2023-10-16 10:00:00', '2023-10-16 11:00:00', 'Zarina Asalova'



---------------------------------------------------








select 
        t.bookingid
	  , tc.cabinetnumber
      , te.fullname
	  , te.email
	  , te.phonenumber
	  , t.starttime
	  , t.endtime
from t_bookings t inner join t_employees te on t.employeeid = te.employeeid
                  inner join t_cabinets tc on t.cabinetid = tc.cabinetid  































/*


INSERT INTO t_employees (fullname, email, phonenumber) VALUES
('Zebo Shirinova', 'zebo@gmail.com', '123456789'),
('Zarina Asalova', 'zarina@gmail.com', '234567891'),
('Zafar Muloimzoda', 'zafar@gmail.com', '345678912'),
('Zuhur Xezakov', 'zuhur@gmail.com', '456789123'),
('Zevar Tillozoda', 'zevaro@gmail.com', '567891234')

INSERT INTO t_cabinets (cabinetnumber) VALUES
('101'),
('102'),
('103'),
('104'),
('105')



sp_configure 'show advanced', 1
go
reconfigure
go
sp_configure 'database mail xps', 1
go
reconfigure
go


*/




