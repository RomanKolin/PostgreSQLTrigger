--
-- PostgreSQL database dump
--

-- Dumped from database version 14.5
-- Dumped by pg_dump version 14.5

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: aplusbequalsc(); Type: FUNCTION; Schema: public; Owner: romankolin
--

CREATE FUNCTION public.aplusbequalsc() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
NEW.c = NEW.a + NEW.b;
RETURN NEW;
END
$$;


ALTER FUNCTION public.aplusbequalsc() OWNER TO romankolin;

--
-- Name: hash(); Type: FUNCTION; Schema: public; Owner: romankolin
--

CREATE FUNCTION public.hash() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
NEW.passw=md5(NEW.passw);
RETURN NEW;
END
$$;


ALTER FUNCTION public.hash() OWNER TO romankolin;

--
-- Name: log(); Type: FUNCTION; Schema: public; Owner: romankolin
--

CREATE FUNCTION public.log() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
INSERT INTO log(event) VALUES(CONCAT('Account by ', OLD.log, ' deleted'));
RETURN OLD;
END
$$;


ALTER FUNCTION public.log() OWNER TO romankolin;

--
-- Name: logwithcondition(); Type: FUNCTION; Schema: public; Owner: romankolin
--

CREATE FUNCTION public.logwithcondition() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
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


ALTER FUNCTION public.logwithcondition() OWNER TO romankolin;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: firsttable; Type: TABLE; Schema: public; Owner: romankolin
--

CREATE TABLE public.firsttable (
    a smallint,
    b smallint,
    c smallint,
    d smallint
);


ALTER TABLE public.firsttable OWNER TO romankolin;

--
-- Name: log; Type: TABLE; Schema: public; Owner: romankolin
--

CREATE TABLE public.log (
    tim timestamp without time zone DEFAULT now(),
    event character varying(100)
);


ALTER TABLE public.log OWNER TO romankolin;

--
-- Name: userdat; Type: TABLE; Schema: public; Owner: romankolin
--

CREATE TABLE public.userdat (
    log character varying(10),
    passw character varying(50)
);


ALTER TABLE public.userdat OWNER TO romankolin;

--
-- Data for Name: firsttable; Type: TABLE DATA; Schema: public; Owner: romankolin
--

COPY public.firsttable (a, b, c, d) FROM stdin;
1	2	3	\N
3	4	7	\N
7	8	15	\N
11	12	23	\N
5	6	11	\N
9	10	19	27
13	14	27	27
17	18	\N	\N
29	30	59	\N
\.


--
-- Data for Name: log; Type: TABLE DATA; Schema: public; Owner: romankolin
--

COPY public.log (tim, event) FROM stdin;
2023-05-01 23:51:36.724033	Account by romankolin deleted
2023-05-01 23:52:02.843099	Attempt to delete admin account
\.


--
-- Data for Name: userdat; Type: TABLE DATA; Schema: public; Owner: romankolin
--

COPY public.userdat (log, passw) FROM stdin;
roman	0b3eef8504ffbc7fa4aa10677c4003a0
romankolin	IT2017year
\.


--
-- Name: log log; Type: RULE; Schema: public; Owner: romankolin
--

CREATE RULE log AS
    ON DELETE TO public.log DO INSTEAD NOTHING;


--
-- Name: firsttable aplusbequalscbeforeinsert; Type: TRIGGER; Schema: public; Owner: romankolin
--

CREATE TRIGGER aplusbequalscbeforeinsert BEFORE INSERT ON public.firsttable FOR EACH ROW EXECUTE FUNCTION public.aplusbequalsc();

ALTER TABLE public.firsttable DISABLE TRIGGER aplusbequalscbeforeinsert;


--
-- Name: firsttable aplusbequalscbeforeinsertupdate; Type: TRIGGER; Schema: public; Owner: romankolin
--

CREATE TRIGGER aplusbequalscbeforeinsertupdate BEFORE INSERT OR UPDATE ON public.firsttable FOR EACH ROW EXECUTE FUNCTION public.aplusbequalsc();

ALTER TABLE public.firsttable DISABLE TRIGGER aplusbequalscbeforeinsertupdate;


--
-- Name: firsttable aplusbequalscwithconditionalbeforeinsertupdate; Type: TRIGGER; Schema: public; Owner: romankolin
--

CREATE TRIGGER aplusbequalscwithconditionalbeforeinsertupdate BEFORE INSERT OR UPDATE ON public.firsttable FOR EACH ROW WHEN ((new.a > 27)) EXECUTE FUNCTION public.aplusbequalsc();


--
-- Name: userdat logbeforedelete; Type: TRIGGER; Schema: public; Owner: romankolin
--

CREATE TRIGGER logbeforedelete BEFORE DELETE ON public.userdat FOR EACH ROW EXECUTE FUNCTION public.log();

ALTER TABLE public.userdat DISABLE TRIGGER logbeforedelete;


--
-- Name: userdat logwithconditionbeforedelete; Type: TRIGGER; Schema: public; Owner: romankolin
--

CREATE TRIGGER logwithconditionbeforedelete BEFORE DELETE ON public.userdat FOR EACH ROW EXECUTE FUNCTION public.logwithcondition();


--
-- Name: userdat passwordtohashbeforeinsert; Type: TRIGGER; Schema: public; Owner: romankolin
--

CREATE TRIGGER passwordtohashbeforeinsert BEFORE INSERT ON public.userdat FOR EACH ROW EXECUTE FUNCTION public.hash();

ALTER TABLE public.userdat DISABLE TRIGGER passwordtohashbeforeinsert;


--
-- PostgreSQL database dump complete
--

