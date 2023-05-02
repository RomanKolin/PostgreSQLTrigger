CREATE FUNCTION aplusbequalsc() RETURNS TRIGGER LANGUAGE 'plpgsql' AS
$$
BEGIN
	NEW.c = NEW.a + NEW.b;
	RETURN NEW;
END
$$;
CREATE TRIGGER aplusbequalscbeforeinsertupdate BEFORE INSERT OR UPDATE ON firsttable FOR EACH ROW EXECUTE PROCEDURE aplusbequalsc();
