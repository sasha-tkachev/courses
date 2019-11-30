-- qd3
select Department.did, Department.dname, sum(Project.budget) 
from Project natural join Department
where Project.duedate > '20/11/2019' -- '20/11/2019' is the current date as per the forum discussion
group by Department.did, Project.did;