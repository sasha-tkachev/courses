-- qd3
select Department.did, Department.dname, sum(Project.budget) 
from Project natural join Department
where Project.duedate > current_date
group by Department.did