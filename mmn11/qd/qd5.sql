-- qd5
with NonEmployed as (
	select avg(salary) as avgSalary from Employee where eid not in (select eid from Onproject)
), Employed as(
	select avg(salary) as avgSalary from Employee where eid  in (select eid from Onproject)
)
select abs(Employed.avgSalary - NonEmployed.avgSalary) from NonEmployed, Employed;
