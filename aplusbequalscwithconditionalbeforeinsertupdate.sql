CREATE FUNCTION aplusbequalsc() RETURNS TRIGGER LANGUAGE 'plpgsql' AS
$$
BEGIN
	NEW.c = NEW.a + NEW.b;
	RETURN NEW;
END
$$;
CREATE TRIGGER aplusbequalscwithconditionalbeforeinsertupdate BEFORE INSERT OR UPDATE ON firsttable FOR EACH ROW WHEN (NEW.a>27) EXECUTE PROCEDURE aplusbequalsc();
