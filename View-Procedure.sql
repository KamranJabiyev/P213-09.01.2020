use Cinema;

create table Halls(
	Id int primary key identity,
	Name nvarchar(50),
	Type nvarchar(50)
)

create table Seats(
	Id int primary key identity,
	Row int not null,
	Coll int not null,
	HallId int references Halls(Id)
)

create table Genres(
	Id int primary key identity,
	Name nvarchar(50)
)

create table Movies(
	Id int primary key identity,
	Name nvarchar(150),
	GenreId int references Genres(Id)
)

create table Seans(
	Id int primary key identity,
	Time datetime,
	MoveId int references Movies(Id),
	HallId int references Halls(Id),
)

create table Customers(
	Id int primary key identity,
	Name nvarchar(100),
	Surname nvarchar(100),
	Phone nvarchar(30),
	KeyCode nvarchar(20)
)

create table Tickets(
	Id int primary key identity,
	Price decimal(10,2),
	SeansId int references Seans(Id),
	CustomerId int references Customers(Id),
	SeatId int references Seats(Id)
)
create view CinemaReport AS
select Price,
	c.Name,
	Surname,
	Phone,
	KeyCode,
	Row,
	Coll,
	Time,
	h.Name 'Hall',
	Type,m.Name 'Move',
	g.Name 'Genre' 

	from Tickets t

join Customers c
on  c.Id=t.CustomerId

join Seats s
on t.SeatId=s.Id

join Seans ss
on ss.Id=t.SeansId

join Halls h
on ss.HallId=h.Id

join Movies m
on ss.MoveId=m.Id

join Genres g
on g.Id=m.GenreId

select * from CinemaReport

use P213;

create table Countries(
	Id int primary key identity,
	Name nvarchar(100)
)

create table Cities(
	Id int primary key identity,
	Name nvarchar(100),
	CountryId int references Countries(Id)
)

select Countries.Name,Count(Countries.Name) 'Cities Number' from Countries
join Cities
on Countries.Id=Cities.CountryId

Group by Countries.Name
having Count(*)>=2

create table OldStudents(
	Id int primary key identity,
	Name nvarchar(100),
	Surname nvarchar(100),
	GroupId int references Groups(Id),
	Grade int
)

use P213;

select Name,Surname from Students
--union
--union all
--except
intersect
select Name,Surname from OldStudents


create procedure usp_GetResultStudents @Grade int AS
select Name,Surname,Grade,Letter from Students
join Grades
on Students.Grade between Grades.MinGrade and Grades.MaxGrade
where Students.Grade>@Grade

create procedure usp_GetResultStudents1 @Grade int=null AS
select Name,Surname,Grade,Letter from Students
join Grades
on Students.Grade between Grades.MinGrade and Grades.MaxGrade
where Students.Grade>=isnull(@Grade,Students.Grade)



create procedure usp_GetResultStudents2 @Grade int=null,@Letter char AS
select Name,Surname,Grade,Letter from Students
join Grades
on Students.Grade between Grades.MinGrade and Grades.MaxGrade
where Students.Grade>=isnull(@Grade,Students.Grade) and Grades.Letter=@Letter

exec usp_GetResultStudents 30

exec usp_GetResultStudents1

exec usp_GetResultStudents2 30,'B'

select * from Employees

create procedure usp_SumSalary @Salary int,@Total int OUTPUT As
Select @Total=Sum(Salary) from Employees
where Salary>@Salary

declare @SumSalary int
exec usp_SumSalary @Salary=1000,@Total=@SumSalary OUTPUT

select @SumSalary