
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

select Project.pname, Project.budget
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
