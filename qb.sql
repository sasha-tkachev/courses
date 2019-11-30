CREATE OR REPLACE FUNCTION trigf1()
  RETURNS trigger AS
$$
	declare mdudedate date;
	BEGIN
	select DATEADD(month, -2, duedate) from Project into mdudedate where Project.pid = new.pid;
	IF  mdudedate > new.fdate THEN
		RETURN NEW;
	else
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