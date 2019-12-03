-- qd5
select abs(Employed.avgSalary - NonEmployed.avgSalary) from (
	select avg(salary) as avgSalary from Employee where eid not in (select eid from Onproject)
) as NonEmployed, (
	select avg(salary) as avgSalary from Employee where eid  in (select eid from Onproject)
) as Employed;
