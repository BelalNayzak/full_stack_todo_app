--
-- PostgreSQL database dump
--

\restrict IpvcaYNA4MHBnsjq9j7aQLPaTXqjw3B0XKweq6etAOdLKAGrkCOjZcT71ga32AH

-- Dumped from database version 18.0
-- Dumped by pg_dump version 18.0 (Homebrew)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: todo; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.todo (
    id integer CONSTRAINT "TODO_ID_not_null" NOT NULL,
    title text CONSTRAINT "TODO_TITLE_not_null" NOT NULL,
    "desc" text,
    priority text CONSTRAINT "TODO_PRIORIRT_not_null" NOT NULL,
    status text CONSTRAINT "TODO_STATUS_not_null" NOT NULL,
    user_id integer NOT NULL
);


ALTER TABLE public.todo OWNER TO postgres;

--
-- Name: TODO_ID_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."TODO_ID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."TODO_ID_seq" OWNER TO postgres;

--
-- Name: TODO_ID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."TODO_ID_seq" OWNED BY public.todo.id;


--
-- Name: user; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."user" (
    id integer CONSTRAINT "USER_ID_not_null" NOT NULL,
    name name CONSTRAINT "USER_NAME_not_null" NOT NULL,
    email text CONSTRAINT "USER_EMAIL_not_null" NOT NULL,
    password text DEFAULT 123456 NOT NULL
);


ALTER TABLE public."user" OWNER TO postgres;

--
-- Name: USER_ID_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."USER_ID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."USER_ID_seq" OWNER TO postgres;

--
-- Name: USER_ID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."USER_ID_seq" OWNED BY public."user".id;


--
-- Name: todo id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.todo ALTER COLUMN id SET DEFAULT nextval('public."TODO_ID_seq"'::regclass);


--
-- Name: user id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."user" ALTER COLUMN id SET DEFAULT nextval('public."USER_ID_seq"'::regclass);


--
-- Data for Name: todo; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.todo (id, title, "desc", priority, status, user_id) FROM stdin;
33	test 2	test 2	low	todo	35
34	test 3	test 3	medium	todo	35
32	test 11	test 11	medium	todo	35
35	test 4	test4 	medium	todo	35
36	test b 1	test b 1	medium	todo	36
\.


--
-- Data for Name: user; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."user" (id, name, email, password) FROM stdin;
22	Khaled z	khaledz@mail.com	$2a$10$VFoaRfA0iuKsuLwPN3xBtuGg9dMxw1qLHubr6UrngwmaEmM0434/a
26	Khaled zz	khaledzz@mail.com	$2a$10$sBLmDUixSlbKC/XdZ5/RIOrlOIGBfONPbCWKGa1Zk./DiIBQM.WfK
28	Hashem 2	hashem2@Hashem2.com	$2a$10$Z0yz0bM0b7Kfa6zP8X5L8.UNCovaB2dhF52f8vsGcOfPwSx41mP3K
35	bebo	bebo1@gmail.com	$2a$10$QregAZ9JvX5nJi73noHyduHLerGMD5Dha16sR06lpd6nB.B5yJAQ.
36	bebo 2	bebo2@gmail.com	$2a$10$tb/xKBY1/w.4Xpxj1mZQmuw2aonzjBNvBZJLvNaQiL6MMhvPLFp66
37	bebo 1	bebo1@bebo1.com	$2a$10$S4TO8i/A6N77vP.9ZhXs4.EwaLOAhjmUaDC7OvYQqtOj06ALH8I86
\.


--
-- Name: TODO_ID_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."TODO_ID_seq"', 36, true);


--
-- Name: USER_ID_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."USER_ID_seq"', 37, true);


--
-- Name: todo TODO_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.todo
    ADD CONSTRAINT "TODO_pkey" PRIMARY KEY (id);


--
-- Name: user USER_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT "USER_pkey" PRIMARY KEY (id);


--
-- Name: user unique_email; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT unique_email UNIQUE (email);


--
-- Name: CONSTRAINT unique_email ON "user"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON CONSTRAINT unique_email ON public."user" IS 'Can''t create 2 users with the same email';


--
-- Name: todo user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.todo
    ADD CONSTRAINT user_id_fkey FOREIGN KEY (user_id) REFERENCES public."user"(id);


--
-- PostgreSQL database dump complete
--

\unrestrict IpvcaYNA4MHBnsjq9j7aQLPaTXqjw3B0XKweq6etAOdLKAGrkCOjZcT71ga32AH

