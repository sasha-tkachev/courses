CREATE OR REPLACE FUNCTION trigf1()
  RETURNS trigger AS
$$
	declare mdudedate date;
	BEGIN
	select duedate from Project into mdudedate where Project.pid = new.pid;
	IF mdudedate - new.fdate >= 30 THEN
		RETURN NEW;
	else
	raise notice E'Failed to add employee % to project %', new.eid, new.pid;
		RETURN NULL;
	end if;
	END;
$$
LANGUAGE 'plpgsql';


CREATE TRIGGER T1
  BEFORE INSERT
  ON Onproject
  FOR EACH ROW
  EXECUTE PROCEDURE trigf1();
