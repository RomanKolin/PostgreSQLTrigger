CREATE FUNCTION log() RETURNS TRIGGER LANGUAGE 'plpgsql' AS
$$
BEGIN
	INSERT INTO log(event) VALUES(CONCAT('Account by ', OLD.log, ' deleted'));
	RETURN OLD;
END
$$;
CREATE TRIGGER logbeforedelete BEFORE DELETE ON userdat FOR EACH ROW EXECUTE PROCEDURE log();
