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