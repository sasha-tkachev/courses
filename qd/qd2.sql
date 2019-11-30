-- qd2
select Employee.ename, Employee.salary
from Employee natural join Department natural join Onproject
where Department.did = 1 and Onproject.pid in (
	select pid from Project where pname = 'search'
);
