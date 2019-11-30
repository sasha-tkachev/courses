DROP TABLE IF EXISTS Employee,Department,Budget,Project,Onproject;
SET datestyle TO "European";
create table Employee ( 
	eid numeric(5,0),
 	ename varchar(30),
 	salary integer check(salary > 0),
	did numeric(3,0),
	classification integer check( classification >= 1 and classification <=10),
	primary key(eid)
);

create table Department (
	did numeric(3,0),
	dname varchar(30),
	dfloor integer,
	head numeric(5,0),
	primary key(did)
);

create table Budget(
	did numeric(3,0) references Department(did),
	byear numeric(4,0),
	budget integer check(budget > 0),
	primary key(did, byear)
);

create table Project(
	pid numeric(3,0),
	pname varchar(30),
	did numeric(3,0) references Department(did),
	budget integer check(budget > 0),
	duedate date,
	primary key(pid)
);

create table Onproject(
	pid numeric(3,0) references Project(pid),
	eid numeric(5,0) references Employee(eid),
	fdate date,
	primary key(pid, eid)
);


CREATE OR REPLACE FUNCTION trigf1()
  RETURNS trigger AS
$$
	declare mdudedate date;
	BEGIN
	select duedate from Project into mdudedate where Project.pid = new.pid;
	IF mdudedate < '20/11/2019' THEN
		RETURN null;
	else
		RETURN NEW;
	end if;
	END;
$$
LANGUAGE 'plpgsql';

CREATE TRIGGER T1
  BEFORE INSERT
  ON Onproject
  FOR EACH ROW
  EXECUTE PROCEDURE trigf1();
  

insert into Employee (eid, ename, salary, did, classification)
values
	(12345, 'Maya', 15000, 1, 5),
	(23456, 'Ben', 17000, 1, 3),
	(34567, 'Dan', 11000, 2, 2),
	(45678, 'Orit', 10000, 1, 3),
	(56789, 'Eyal', 10000, 3, 5),
	(11111, 'Sasha', 10000, 1, 5),
	(22222, 'Alisa', 10000, 2, 5),
	(33333, 'Max', 10000, 3, 5);
	
insert into Department (did, dname, dfloor, head)
values (1, 'A', 3, 54321),
	(2, 'B', 3, 12345),
	(3, 'C', 4, 34567);
	
insert into Budget(did, byear, budget)
values
	(1, '2014', 250000),
	(1, '2015', 300000),
	(1, '2016', 10000),
	(1, '2017', 20000),
	(1, '2018', 250000),
	(1, '2019', 400000),
	(2, '2014', 300000),
	(2, '2015', 400000),
	(2, '2016', 1000000),
	(2, '2017', 2000000),
	(2, '2018', 50000),
	(2, '2019', 700000),
	(3, '2013', 700000),
	(3, '2014', 700000),
	(3, '2015', 700000),
	(3, '2019', 700000);
	

insert into Project (pid, pname , did, Budget, duedate)
values 
	(444, 'search',  1,  15000000, '30/8/2019'),
	(111, 'proj1' , 2 , 700000 , '15/9/2019'),
	(222, 'proj3' , 3 , 350000 ,' 1/1/2020'),
	(333, 'proj2' , 1 , 400000 , '25/10/2019'),
	(555, 'proj4' , 2 , 400000 , '25/10/2020'),
	(666, 'proj5' , 3 , 400000 , '25/10/2021'),
	(777, 'proj6' , 2 , 400000 , '25/10/2020');
	
insert into Onproject (pid, eid,fdate)
values
	(444, 23456, '15/7/2019'),
	(444, 34567, '15/7/2019'),
	(444, 45678, '10/7/2019'),
	(111, 12345, '1/7/2019'),
	(111, 56789, '1/7/2019'),
	(222, 23456, '1/7/2019'),
	(222, 34567, '2/7/2019'),
	(333, 23456, '25/6/2019')
	;
	
-- qd1
select *
from Employee 
where classification >= 1 and classification <= 3 and salary < 12000; 
-- qd2
select Employee.ename, Employee.salary
from Employee natural join Department natural join Onproject
where Department.did = 1 and Onproject.pid in (
	select pid from Project where pname = 'search'
);
-- qd3
select Department.did, Department.dname, sum(Project.budget) 
from Project natural join Department
where Project.duedate > '20/11/2019'
group by Department.did, Project.did;
-- qd4
select Department.did, Department.dname
from Budget natural join Department
where Budget.byear >= 2014
group by Department.did, Budget.did
having ( sum(Budget.budget) < 2500000);

-- qd5
with NonEmployed as (
	select avg(salary) as avgSalary from Employee where eid not in (select eid from Onproject)
), Employed as(
	select avg(salary) as avgSalary from Employee where eid  in (select eid from Onproject)
)
select abs(Employed.avgSalary - NonEmployed.avgSalary) from NonEmployed, Employed;

-- qd6

with  ValidEmployeeCount as (
	select Project.pid as pid, count(*) as empnum
	from Project natural join Onproject
	where 
		not exists(
			select * 
			from Employee natural join Onproject 
			where 
				Project.pid = Onproject.pid 
				and
				Employee.classification > 3
		)
	group by Project.pid)
select Project.pname 
from Project
where 
	Project.pid not in (
		-- Select all project ids which have some other project with more empolyees them it
		select c1.pid
		from ValidEmployeeCount as c1, ValidEmployeeCount as c2
		where c1.empnum < c2.empnum
	) 
	and 
	-- Make sure we project only projects with the correct classification level of the employees
	Project.pid in (
		select pid from ValidEmployeeCount
	);


-- qd7


with Besties as (
	select e1.eid as eid1, e2.eid as eid2
	from Employee as e1, Employee as e2
	where 
		-- We are comparing differant employees because an employee cannot be a friend with himself.
		e1.eid != e2.eid
		-- check there is no project which e1 participates in and e2 is not participating in
		and not exists(
			select *
			from Onproject as r1
			where 
				r1.eid = e1.eid 
				and 
				not exists (
					select *
					from Onproject as r2
					where r2.pid = r1.pid and r2.eid = e2.eid
				)
		)
		-- check there is no project which e2 participates in and e1 is not participating in
		and not exists(
			select *
			from Onproject as r1
			where 
				r1.eid = e2.eid 
				and 
				not exists (
					select *
					from Onproject as r2
					where r2.pid = r1.pid and r2.eid = e1.eid
				)
		)
		-- check that the first employee is actually on some project
		and exists(
			select * 
			from Onproject
			where Onproject.eid = e1.eid
		)
		-- check that the second employee is actually on some project
		and exists(
			select * 
			from Onproject
			where Onproject.eid = e2.eid
		))
select b1.eid1, b1.eid2
from Besties as b1, Besties as b2
where 
	b1.eid1 = b2.eid2 and b1.eid2 = b2.eid1 
	-- prevent reverse order duplication
	and b1.eid1 < b2.eid1;
	
select * from Onproject


