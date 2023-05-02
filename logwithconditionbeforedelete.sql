CREATE OR REPLACE FUNCTION logwithcondition() RETURNS TRIGGER LANGUAGE 'plpgsql' AS
$$
BEGIN
	IF OLD.log='romankolin' THEN
		INSERT INTO log(event) VALUES('Attempt to delete admin account');
		RAISE NOTICE 'You don''t have permission to delete admin account';
		RETURN NULL;
	END IF;
	INSERT INTO log(event) VALUES(CONCAT('Account by ', OLD.log, ' deleted'));
	RETURN OLD;
END
$$;
CREATE TRIGGER logwithconditionbeforedelete BEFORE DELETE ON userdat FOR EACH ROW EXECUTE PROCEDURE logwithcondition();
