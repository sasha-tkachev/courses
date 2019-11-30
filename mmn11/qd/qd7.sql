-- qd7
with Besties as (
	select e1.eid as eid1, e2.eid as eid2
	from Employee as e1, Employee as e2
	where 
		-- We are comparing differant employees because an employee cannot be a friend with himself.
		e1.eid != e2.eid
		-- check there is no project which e1 participates in and e2 is not participating in
		and not exists(
			select *
			from Onproject as r1
			where 
				r1.eid = e1.eid 
				and 
				not exists (
					select *
					from Onproject as r2
					where r2.pid = r1.pid and r2.eid = e2.eid
				)
		)
		-- check there is no project which e2 participates in and e1 is not participating in
		and not exists(
			select *
			from Onproject as r1
			where 
				r1.eid = e2.eid 
				and 
				not exists (
					select *
					from Onproject as r2
					where r2.pid = r1.pid and r2.eid = e1.eid
				)
		)
		-- check that the first employee is actually on some project
		and exists(
			select * 
			from Onproject
			where Onproject.eid = e1.eid
		)
		-- check that the second employee is actually on some project
		and exists(
			select * 
			from Onproject
			where Onproject.eid = e2.eid
		))
select b1.eid1, b1.eid2
from Besties as b1, Besties as b2
where 
	b1.eid1 = b2.eid2 and b1.eid2 = b2.eid1 
	-- prevent reverse order duplication
	and b1.eid1 < b2.eid1;

