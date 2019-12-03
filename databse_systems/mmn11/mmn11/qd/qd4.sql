-- qd4
select Department.did, Department.dname
from Budget natural join Department
where Budget.byear >= (date_part('year', current_date) - 5 )
group by Department.did
having ( sum(Budget.budget) < 2500000);
