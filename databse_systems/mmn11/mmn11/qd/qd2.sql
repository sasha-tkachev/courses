-- qd2
select Employee.ename, Employee.salary
from Employee, Onproject
where 
	Onproject.eid = Employee.eid and Employee.did = 1 and Onproject.pid in (
		select pid from Project where pname = 'search'
	);
