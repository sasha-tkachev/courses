Create table Employee
( 
	eid integer primary key,
 	ename char(30),
 	salary integer check(salary >= 0),
	did integer,
	classification integer check(classification > 0 and classification <= 10)
)