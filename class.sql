select idpupil
from taskgrades as tg1
where not exists (
	select *
	from taskgrades as tg2
	where tg1.grade < tg2.grade
)