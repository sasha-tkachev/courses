-- qd4
select Department.did, Department.dname
from Budget natural join Department
-- '20/11/2019' is the current date as per the forum discussion
where Budget.byear >= (date_part('year', current_date) - 5 )
group by Department.did, Budget.did
having ( sum(Budget.budget) < 2500000);
