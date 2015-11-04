--
-- PostgreSQL database dump
--

-- Dumped from database version 9.4.0
-- Dumped by pg_dump version 9.4.0
-- Started on 2015-11-03 23:13:44 ALMT

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

DROP DATABASE brainfights;
--
-- TOC entry 2404 (class 1262 OID 66328)
-- Name: brainfights; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE brainfights WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'C' LC_CTYPE = 'C';


ALTER DATABASE brainfights OWNER TO postgres;

\connect brainfights

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- TOC entry 5 (class 2615 OID 2200)
-- Name: public; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA public;


ALTER SCHEMA public OWNER TO postgres;

--
-- TOC entry 2405 (class 0 OID 0)
-- Dependencies: 5
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA public IS 'standard public schema';


--
-- TOC entry 195 (class 3079 OID 12123)
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- TOC entry 2407 (class 0 OID 0)
-- Dependencies: 195
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- TOC entry 172 (class 1259 OID 66329)
-- Name: admin_user; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE admin_user (
    id bigint NOT NULL,
    created_date timestamp without time zone,
    deleted boolean DEFAULT false NOT NULL,
    modified_date timestamp without time zone,
    enabled boolean DEFAULT true NOT NULL,
    login character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    password character varying(255) NOT NULL,
    role character varying(255) NOT NULL
);


ALTER TABLE admin_user OWNER TO postgres;

--
-- TOC entry 182 (class 1259 OID 66456)
-- Name: admin_user_sequence; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE admin_user_sequence
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE admin_user_sequence OWNER TO postgres;

--
-- TOC entry 173 (class 1259 OID 66339)
-- Name: answer; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE answer (
    id bigint NOT NULL,
    created_date timestamp without time zone,
    deleted boolean DEFAULT false NOT NULL,
    modified_date timestamp without time zone,
    correct boolean DEFAULT false NOT NULL,
    name character varying(100) NOT NULL,
    question_id bigint
);


ALTER TABLE answer OWNER TO postgres;

--
-- TOC entry 183 (class 1259 OID 66458)
-- Name: answer_sequence; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE answer_sequence
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE answer_sequence OWNER TO postgres;

--
-- TOC entry 174 (class 1259 OID 66346)
-- Name: category; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE category (
    id bigint NOT NULL,
    created_date timestamp without time zone,
    deleted boolean DEFAULT false NOT NULL,
    modified_date timestamp without time zone,
    color character varying(50),
    image_url character varying(255),
    name character varying(255) NOT NULL
);


ALTER TABLE category OWNER TO postgres;

--
-- TOC entry 184 (class 1259 OID 66460)
-- Name: category_sequence; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE category_sequence
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE category_sequence OWNER TO postgres;

--
-- TOC entry 180 (class 1259 OID 66386)
-- Name: department; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE department (
    id bigint NOT NULL,
    created_date timestamp without time zone,
    deleted boolean DEFAULT false NOT NULL,
    modified_date timestamp without time zone,
    name character varying(255) NOT NULL,
    scrore integer NOT NULL,
    usercount integer NOT NULL,
    parent_id bigint
);


ALTER TABLE department OWNER TO postgres;

--
-- TOC entry 190 (class 1259 OID 66472)
-- Name: department_sequence; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE department_sequence
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE department_sequence OWNER TO postgres;

--
-- TOC entry 175 (class 1259 OID 66355)
-- Name: game; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE game (
    id bigint NOT NULL,
    created_date timestamp without time zone,
    deleted boolean DEFAULT false NOT NULL,
    modified_date timestamp without time zone,
    game_finished_date timestamp without time zone,
    game_started_date timestamp without time zone,
    invitation_accepted_date timestamp without time zone,
    invitation_sent_date timestamp without time zone,
    status character varying(255) NOT NULL
);


ALTER TABLE game OWNER TO postgres;

--
-- TOC entry 176 (class 1259 OID 66361)
-- Name: game_round; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE game_round (
    id bigint NOT NULL,
    created_date timestamp without time zone,
    deleted boolean DEFAULT false NOT NULL,
    modified_date timestamp without time zone,
    status character varying(255) NOT NULL,
    category_id bigint,
    game_id bigint
);


ALTER TABLE game_round OWNER TO postgres;

--
-- TOC entry 177 (class 1259 OID 66367)
-- Name: game_round_question; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE game_round_question (
    id bigint NOT NULL,
    created_date timestamp without time zone,
    deleted boolean DEFAULT false NOT NULL,
    modified_date timestamp without time zone,
    gameround_id bigint,
    question_id bigint
);


ALTER TABLE game_round_question OWNER TO postgres;

--
-- TOC entry 178 (class 1259 OID 66373)
-- Name: game_round_question_answer; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE game_round_question_answer (
    id bigint NOT NULL,
    created_date timestamp without time zone,
    deleted boolean DEFAULT false NOT NULL,
    modified_date timestamp without time zone,
    is_correct_answer boolean DEFAULT false NOT NULL,
    answer_id bigint,
    gameroundquestion_id bigint,
    gamer_id bigint
);


ALTER TABLE game_round_question_answer OWNER TO postgres;

--
-- TOC entry 185 (class 1259 OID 66462)
-- Name: game_round_question_answer_sequence; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE game_round_question_answer_sequence
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE game_round_question_answer_sequence OWNER TO postgres;

--
-- TOC entry 186 (class 1259 OID 66464)
-- Name: game_round_question_sequence; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE game_round_question_sequence
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE game_round_question_sequence OWNER TO postgres;

--
-- TOC entry 187 (class 1259 OID 66466)
-- Name: game_round_sequence; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE game_round_sequence
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE game_round_sequence OWNER TO postgres;

--
-- TOC entry 188 (class 1259 OID 66468)
-- Name: game_sequence; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE game_sequence
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE game_sequence OWNER TO postgres;

--
-- TOC entry 179 (class 1259 OID 66380)
-- Name: gamer; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE gamer (
    id bigint NOT NULL,
    created_date timestamp without time zone,
    deleted boolean DEFAULT false NOT NULL,
    modified_date timestamp without time zone,
    correct_answer_count integer,
    last_update_status_date timestamp without time zone,
    score integer NOT NULL,
    status character varying(255) NOT NULL,
    game_id bigint,
    user_id bigint,
    game_initiator boolean DEFAULT false NOT NULL,
    oponent_id bigint
);


ALTER TABLE gamer OWNER TO postgres;

--
-- TOC entry 189 (class 1259 OID 66470)
-- Name: gamer_sequence; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE gamer_sequence
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE gamer_sequence OWNER TO postgres;

--
-- TOC entry 181 (class 1259 OID 66392)
-- Name: question; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE question (
    id bigint NOT NULL,
    created_date timestamp without time zone,
    deleted boolean DEFAULT false NOT NULL,
    modified_date timestamp without time zone,
    image_url character varying(255),
    text character varying(255) NOT NULL,
    type character varying(255) NOT NULL,
    category_id bigint
);


ALTER TABLE question OWNER TO postgres;

--
-- TOC entry 191 (class 1259 OID 66474)
-- Name: question_sequence; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE question_sequence
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE question_sequence OWNER TO postgres;

--
-- TOC entry 192 (class 1259 OID 66476)
-- Name: user_sequence; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE user_sequence
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE user_sequence OWNER TO postgres;

--
-- TOC entry 193 (class 1259 OID 66479)
-- Name: users; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE users (
    id bigint NOT NULL,
    created_date timestamp without time zone,
    deleted boolean DEFAULT false NOT NULL,
    modified_date timestamp without time zone,
    app_version character varying(50),
    device_os_version character varying(50),
    device_push_key character varying(255),
    device_type character varying(50),
    login character varying(50),
    name character varying(255) NOT NULL,
    password character varying(50),
    "position" character varying(255),
    score integer NOT NULL,
    auth_token character varying(50),
    device_push_token character varying(255),
    drawngames integer,
    email character varying(50),
    last_activity_time timestamp without time zone NOT NULL,
    loosinggames integer,
    totalgames integer,
    wongames integer,
    department_id bigint
);


ALTER TABLE users OWNER TO postgres;

--
-- TOC entry 194 (class 1259 OID 66550)
-- Name: users_friends; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE users_friends (
    user_id bigint NOT NULL,
    friend_id bigint NOT NULL
);


ALTER TABLE users_friends OWNER TO postgres;

--
-- TOC entry 2377 (class 0 OID 66329)
-- Dependencies: 172
-- Data for Name: admin_user; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 2408 (class 0 OID 0)
-- Dependencies: 182
-- Name: admin_user_sequence; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('admin_user_sequence', 1, false);


--
-- TOC entry 2378 (class 0 OID 66339)
-- Dependencies: 173
-- Data for Name: answer; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO answer (id, created_date, deleted, modified_date, correct, name, question_id) VALUES (2, NULL, false, NULL, false, 'B', 1);
INSERT INTO answer (id, created_date, deleted, modified_date, correct, name, question_id) VALUES (3, NULL, false, NULL, false, 'C', 1);
INSERT INTO answer (id, created_date, deleted, modified_date, correct, name, question_id) VALUES (4, NULL, false, NULL, false, 'D', 1);
INSERT INTO answer (id, created_date, deleted, modified_date, correct, name, question_id) VALUES (6, NULL, false, NULL, false, 'B', 2);
INSERT INTO answer (id, created_date, deleted, modified_date, correct, name, question_id) VALUES (7, NULL, false, NULL, false, 'C', 2);
INSERT INTO answer (id, created_date, deleted, modified_date, correct, name, question_id) VALUES (8, NULL, false, NULL, false, 'D', 2);
INSERT INTO answer (id, created_date, deleted, modified_date, correct, name, question_id) VALUES (10, NULL, false, NULL, false, 'B', 3);
INSERT INTO answer (id, created_date, deleted, modified_date, correct, name, question_id) VALUES (11, NULL, false, NULL, false, 'C', 3);
INSERT INTO answer (id, created_date, deleted, modified_date, correct, name, question_id) VALUES (12, NULL, false, NULL, false, 'D', 3);
INSERT INTO answer (id, created_date, deleted, modified_date, correct, name, question_id) VALUES (14, NULL, false, NULL, false, 'B', 4);
INSERT INTO answer (id, created_date, deleted, modified_date, correct, name, question_id) VALUES (15, NULL, false, NULL, false, 'C', 4);
INSERT INTO answer (id, created_date, deleted, modified_date, correct, name, question_id) VALUES (16, NULL, false, NULL, false, 'D', 4);
INSERT INTO answer (id, created_date, deleted, modified_date, correct, name, question_id) VALUES (18, NULL, false, NULL, false, 'B', 5);
INSERT INTO answer (id, created_date, deleted, modified_date, correct, name, question_id) VALUES (19, NULL, false, NULL, false, 'C', 5);
INSERT INTO answer (id, created_date, deleted, modified_date, correct, name, question_id) VALUES (20, NULL, false, NULL, false, 'D', 5);
INSERT INTO answer (id, created_date, deleted, modified_date, correct, name, question_id) VALUES (22, NULL, false, NULL, false, 'B', 6);
INSERT INTO answer (id, created_date, deleted, modified_date, correct, name, question_id) VALUES (23, NULL, false, NULL, false, 'C', 6);
INSERT INTO answer (id, created_date, deleted, modified_date, correct, name, question_id) VALUES (24, NULL, false, NULL, false, 'D', 6);
INSERT INTO answer (id, created_date, deleted, modified_date, correct, name, question_id) VALUES (26, NULL, false, NULL, false, 'B', 7);
INSERT INTO answer (id, created_date, deleted, modified_date, correct, name, question_id) VALUES (27, NULL, false, NULL, false, 'C', 7);
INSERT INTO answer (id, created_date, deleted, modified_date, correct, name, question_id) VALUES (28, NULL, false, NULL, false, 'D', 7);
INSERT INTO answer (id, created_date, deleted, modified_date, correct, name, question_id) VALUES (30, NULL, false, NULL, false, 'B', 8);
INSERT INTO answer (id, created_date, deleted, modified_date, correct, name, question_id) VALUES (31, NULL, false, NULL, false, 'C', 8);
INSERT INTO answer (id, created_date, deleted, modified_date, correct, name, question_id) VALUES (32, NULL, false, NULL, false, 'D', 8);
INSERT INTO answer (id, created_date, deleted, modified_date, correct, name, question_id) VALUES (34, NULL, false, NULL, false, 'B', 9);
INSERT INTO answer (id, created_date, deleted, modified_date, correct, name, question_id) VALUES (35, NULL, false, NULL, false, 'C', 9);
INSERT INTO answer (id, created_date, deleted, modified_date, correct, name, question_id) VALUES (36, NULL, false, NULL, false, 'D', 9);
INSERT INTO answer (id, created_date, deleted, modified_date, correct, name, question_id) VALUES (39, NULL, false, NULL, false, 'C', 10);
INSERT INTO answer (id, created_date, deleted, modified_date, correct, name, question_id) VALUES (38, NULL, false, NULL, false, 'B', 10);
INSERT INTO answer (id, created_date, deleted, modified_date, correct, name, question_id) VALUES (40, NULL, false, NULL, false, 'D', 10);
INSERT INTO answer (id, created_date, deleted, modified_date, correct, name, question_id) VALUES (42, NULL, false, NULL, false, 'B', 11);
INSERT INTO answer (id, created_date, deleted, modified_date, correct, name, question_id) VALUES (43, NULL, false, NULL, false, 'C', 11);
INSERT INTO answer (id, created_date, deleted, modified_date, correct, name, question_id) VALUES (44, NULL, false, NULL, false, 'D', 11);
INSERT INTO answer (id, created_date, deleted, modified_date, correct, name, question_id) VALUES (46, NULL, false, NULL, false, 'B', 12);
INSERT INTO answer (id, created_date, deleted, modified_date, correct, name, question_id) VALUES (47, NULL, false, NULL, false, 'C', 12);
INSERT INTO answer (id, created_date, deleted, modified_date, correct, name, question_id) VALUES (48, NULL, false, NULL, false, 'D', 12);
INSERT INTO answer (id, created_date, deleted, modified_date, correct, name, question_id) VALUES (50, NULL, false, NULL, false, 'B', 13);
INSERT INTO answer (id, created_date, deleted, modified_date, correct, name, question_id) VALUES (51, NULL, false, NULL, false, 'C', 13);
INSERT INTO answer (id, created_date, deleted, modified_date, correct, name, question_id) VALUES (52, NULL, false, NULL, false, 'D', 13);
INSERT INTO answer (id, created_date, deleted, modified_date, correct, name, question_id) VALUES (54, NULL, false, NULL, false, 'B', 14);
INSERT INTO answer (id, created_date, deleted, modified_date, correct, name, question_id) VALUES (55, NULL, false, NULL, false, 'C', 14);
INSERT INTO answer (id, created_date, deleted, modified_date, correct, name, question_id) VALUES (56, NULL, false, NULL, false, 'D', 14);
INSERT INTO answer (id, created_date, deleted, modified_date, correct, name, question_id) VALUES (58, NULL, false, NULL, false, 'B', 15);
INSERT INTO answer (id, created_date, deleted, modified_date, correct, name, question_id) VALUES (59, NULL, false, NULL, false, 'C', 15);
INSERT INTO answer (id, created_date, deleted, modified_date, correct, name, question_id) VALUES (60, NULL, false, NULL, false, 'D', 15);
INSERT INTO answer (id, created_date, deleted, modified_date, correct, name, question_id) VALUES (62, NULL, false, NULL, false, 'B', 16);
INSERT INTO answer (id, created_date, deleted, modified_date, correct, name, question_id) VALUES (63, NULL, false, NULL, false, 'C', 16);
INSERT INTO answer (id, created_date, deleted, modified_date, correct, name, question_id) VALUES (64, NULL, false, NULL, false, 'D', 16);
INSERT INTO answer (id, created_date, deleted, modified_date, correct, name, question_id) VALUES (66, NULL, false, NULL, false, 'B', 17);
INSERT INTO answer (id, created_date, deleted, modified_date, correct, name, question_id) VALUES (67, NULL, false, NULL, false, 'C', 17);
INSERT INTO answer (id, created_date, deleted, modified_date, correct, name, question_id) VALUES (68, NULL, false, NULL, false, 'D', 17);
INSERT INTO answer (id, created_date, deleted, modified_date, correct, name, question_id) VALUES (70, NULL, false, NULL, false, 'B', 18);
INSERT INTO answer (id, created_date, deleted, modified_date, correct, name, question_id) VALUES (71, NULL, false, NULL, false, 'C', 18);
INSERT INTO answer (id, created_date, deleted, modified_date, correct, name, question_id) VALUES (72, NULL, false, NULL, false, 'D', 18);
INSERT INTO answer (id, created_date, deleted, modified_date, correct, name, question_id) VALUES (74, NULL, false, NULL, false, 'B', 19);
INSERT INTO answer (id, created_date, deleted, modified_date, correct, name, question_id) VALUES (75, NULL, false, NULL, false, 'C', 19);
INSERT INTO answer (id, created_date, deleted, modified_date, correct, name, question_id) VALUES (76, NULL, false, NULL, false, 'D', 19);
INSERT INTO answer (id, created_date, deleted, modified_date, correct, name, question_id) VALUES (79, NULL, false, NULL, false, 'C', 20);
INSERT INTO answer (id, created_date, deleted, modified_date, correct, name, question_id) VALUES (78, NULL, false, NULL, false, 'B', 20);
INSERT INTO answer (id, created_date, deleted, modified_date, correct, name, question_id) VALUES (80, NULL, false, NULL, false, 'D', 20);
INSERT INTO answer (id, created_date, deleted, modified_date, correct, name, question_id) VALUES (82, NULL, false, NULL, false, 'B', 21);
INSERT INTO answer (id, created_date, deleted, modified_date, correct, name, question_id) VALUES (83, NULL, false, NULL, false, 'C', 21);
INSERT INTO answer (id, created_date, deleted, modified_date, correct, name, question_id) VALUES (84, NULL, false, NULL, false, 'D', 21);
INSERT INTO answer (id, created_date, deleted, modified_date, correct, name, question_id) VALUES (86, NULL, false, NULL, false, 'B', 22);
INSERT INTO answer (id, created_date, deleted, modified_date, correct, name, question_id) VALUES (87, NULL, false, NULL, false, 'C', 22);
INSERT INTO answer (id, created_date, deleted, modified_date, correct, name, question_id) VALUES (88, NULL, false, NULL, false, 'D', 22);
INSERT INTO answer (id, created_date, deleted, modified_date, correct, name, question_id) VALUES (90, NULL, false, NULL, false, 'B', 23);
INSERT INTO answer (id, created_date, deleted, modified_date, correct, name, question_id) VALUES (91, NULL, false, NULL, false, 'C', 23);
INSERT INTO answer (id, created_date, deleted, modified_date, correct, name, question_id) VALUES (92, NULL, false, NULL, false, 'D', 23);
INSERT INTO answer (id, created_date, deleted, modified_date, correct, name, question_id) VALUES (94, NULL, false, NULL, false, 'B', 24);
INSERT INTO answer (id, created_date, deleted, modified_date, correct, name, question_id) VALUES (95, NULL, false, NULL, false, 'C', 24);
INSERT INTO answer (id, created_date, deleted, modified_date, correct, name, question_id) VALUES (96, NULL, false, NULL, false, 'D', 24);
INSERT INTO answer (id, created_date, deleted, modified_date, correct, name, question_id) VALUES (98, NULL, false, NULL, false, 'B', 25);
INSERT INTO answer (id, created_date, deleted, modified_date, correct, name, question_id) VALUES (99, NULL, false, NULL, false, 'C', 25);
INSERT INTO answer (id, created_date, deleted, modified_date, correct, name, question_id) VALUES (100, NULL, false, NULL, false, 'D', 25);
INSERT INTO answer (id, created_date, deleted, modified_date, correct, name, question_id) VALUES (102, NULL, false, NULL, false, 'B', 26);
INSERT INTO answer (id, created_date, deleted, modified_date, correct, name, question_id) VALUES (103, NULL, false, NULL, false, 'C', 26);
INSERT INTO answer (id, created_date, deleted, modified_date, correct, name, question_id) VALUES (104, NULL, false, NULL, false, 'D', 26);
INSERT INTO answer (id, created_date, deleted, modified_date, correct, name, question_id) VALUES (106, NULL, false, NULL, false, 'B', 27);
INSERT INTO answer (id, created_date, deleted, modified_date, correct, name, question_id) VALUES (107, NULL, false, NULL, false, 'C', 27);
INSERT INTO answer (id, created_date, deleted, modified_date, correct, name, question_id) VALUES (108, NULL, false, NULL, false, 'D', 27);
INSERT INTO answer (id, created_date, deleted, modified_date, correct, name, question_id) VALUES (110, NULL, false, NULL, false, 'B', 28);
INSERT INTO answer (id, created_date, deleted, modified_date, correct, name, question_id) VALUES (111, NULL, false, NULL, false, 'C', 28);
INSERT INTO answer (id, created_date, deleted, modified_date, correct, name, question_id) VALUES (112, NULL, false, NULL, false, 'D', 28);
INSERT INTO answer (id, created_date, deleted, modified_date, correct, name, question_id) VALUES (114, NULL, false, NULL, false, 'B', 29);
INSERT INTO answer (id, created_date, deleted, modified_date, correct, name, question_id) VALUES (115, NULL, false, NULL, false, 'C', 29);
INSERT INTO answer (id, created_date, deleted, modified_date, correct, name, question_id) VALUES (116, NULL, false, NULL, false, 'D', 29);
INSERT INTO answer (id, created_date, deleted, modified_date, correct, name, question_id) VALUES (118, NULL, false, NULL, false, 'B', 30);
INSERT INTO answer (id, created_date, deleted, modified_date, correct, name, question_id) VALUES (119, NULL, false, NULL, false, 'C', 30);
INSERT INTO answer (id, created_date, deleted, modified_date, correct, name, question_id) VALUES (120, NULL, false, NULL, false, 'D', 30);
INSERT INTO answer (id, created_date, deleted, modified_date, correct, name, question_id) VALUES (122, NULL, false, NULL, false, 'B', 31);
INSERT INTO answer (id, created_date, deleted, modified_date, correct, name, question_id) VALUES (123, NULL, false, NULL, false, 'C', 31);
INSERT INTO answer (id, created_date, deleted, modified_date, correct, name, question_id) VALUES (124, NULL, false, NULL, false, 'D', 31);
INSERT INTO answer (id, created_date, deleted, modified_date, correct, name, question_id) VALUES (126, NULL, false, NULL, false, 'B', 32);
INSERT INTO answer (id, created_date, deleted, modified_date, correct, name, question_id) VALUES (127, NULL, false, NULL, false, 'C', 32);
INSERT INTO answer (id, created_date, deleted, modified_date, correct, name, question_id) VALUES (128, NULL, false, NULL, false, 'D', 32);
INSERT INTO answer (id, created_date, deleted, modified_date, correct, name, question_id) VALUES (130, NULL, false, NULL, false, 'B', 33);
INSERT INTO answer (id, created_date, deleted, modified_date, correct, name, question_id) VALUES (131, NULL, false, NULL, false, 'C', 33);
INSERT INTO answer (id, created_date, deleted, modified_date, correct, name, question_id) VALUES (132, NULL, false, NULL, false, 'D', 33);
INSERT INTO answer (id, created_date, deleted, modified_date, correct, name, question_id) VALUES (134, NULL, false, NULL, false, 'B', 34);
INSERT INTO answer (id, created_date, deleted, modified_date, correct, name, question_id) VALUES (135, NULL, false, NULL, false, 'C', 34);
INSERT INTO answer (id, created_date, deleted, modified_date, correct, name, question_id) VALUES (136, NULL, false, NULL, false, 'D', 34);
INSERT INTO answer (id, created_date, deleted, modified_date, correct, name, question_id) VALUES (138, NULL, false, NULL, false, 'B', 35);
INSERT INTO answer (id, created_date, deleted, modified_date, correct, name, question_id) VALUES (139, NULL, false, NULL, false, 'C', 35);
INSERT INTO answer (id, created_date, deleted, modified_date, correct, name, question_id) VALUES (140, NULL, false, NULL, false, 'D', 35);
INSERT INTO answer (id, created_date, deleted, modified_date, correct, name, question_id) VALUES (142, NULL, false, NULL, false, 'B', 36);
INSERT INTO answer (id, created_date, deleted, modified_date, correct, name, question_id) VALUES (143, NULL, false, NULL, false, 'C', 36);
INSERT INTO answer (id, created_date, deleted, modified_date, correct, name, question_id) VALUES (145, NULL, false, NULL, false, 'B', 37);
INSERT INTO answer (id, created_date, deleted, modified_date, correct, name, question_id) VALUES (146, NULL, false, NULL, false, 'C', 37);
INSERT INTO answer (id, created_date, deleted, modified_date, correct, name, question_id) VALUES (147, NULL, false, NULL, false, 'D', 37);
INSERT INTO answer (id, created_date, deleted, modified_date, correct, name, question_id) VALUES (149, NULL, false, NULL, false, 'B', 38);
INSERT INTO answer (id, created_date, deleted, modified_date, correct, name, question_id) VALUES (150, NULL, false, NULL, false, 'C', 38);
INSERT INTO answer (id, created_date, deleted, modified_date, correct, name, question_id) VALUES (151, NULL, false, NULL, false, 'D', 38);
INSERT INTO answer (id, created_date, deleted, modified_date, correct, name, question_id) VALUES (1, NULL, false, NULL, true, 'A', 1);
INSERT INTO answer (id, created_date, deleted, modified_date, correct, name, question_id) VALUES (5, NULL, false, NULL, true, 'A', 2);
INSERT INTO answer (id, created_date, deleted, modified_date, correct, name, question_id) VALUES (9, NULL, false, NULL, true, 'A', 3);
INSERT INTO answer (id, created_date, deleted, modified_date, correct, name, question_id) VALUES (13, NULL, false, NULL, true, 'A', 4);
INSERT INTO answer (id, created_date, deleted, modified_date, correct, name, question_id) VALUES (17, NULL, false, NULL, true, 'A', 5);
INSERT INTO answer (id, created_date, deleted, modified_date, correct, name, question_id) VALUES (21, NULL, false, NULL, true, 'A', 6);
INSERT INTO answer (id, created_date, deleted, modified_date, correct, name, question_id) VALUES (25, NULL, false, NULL, true, 'A', 7);
INSERT INTO answer (id, created_date, deleted, modified_date, correct, name, question_id) VALUES (29, NULL, false, NULL, true, 'A', 8);
INSERT INTO answer (id, created_date, deleted, modified_date, correct, name, question_id) VALUES (33, NULL, false, NULL, true, 'A', 9);
INSERT INTO answer (id, created_date, deleted, modified_date, correct, name, question_id) VALUES (37, NULL, false, NULL, true, 'A', 10);
INSERT INTO answer (id, created_date, deleted, modified_date, correct, name, question_id) VALUES (41, NULL, false, NULL, true, 'A', 11);
INSERT INTO answer (id, created_date, deleted, modified_date, correct, name, question_id) VALUES (45, NULL, false, NULL, true, 'A', 12);
INSERT INTO answer (id, created_date, deleted, modified_date, correct, name, question_id) VALUES (49, NULL, false, NULL, true, 'A', 13);
INSERT INTO answer (id, created_date, deleted, modified_date, correct, name, question_id) VALUES (53, NULL, false, NULL, true, 'A', 14);
INSERT INTO answer (id, created_date, deleted, modified_date, correct, name, question_id) VALUES (57, NULL, false, NULL, true, 'A', 15);
INSERT INTO answer (id, created_date, deleted, modified_date, correct, name, question_id) VALUES (61, NULL, false, NULL, true, 'A', 16);
INSERT INTO answer (id, created_date, deleted, modified_date, correct, name, question_id) VALUES (65, NULL, false, NULL, true, 'A', 17);
INSERT INTO answer (id, created_date, deleted, modified_date, correct, name, question_id) VALUES (69, NULL, false, NULL, true, 'A', 18);
INSERT INTO answer (id, created_date, deleted, modified_date, correct, name, question_id) VALUES (73, NULL, false, NULL, true, 'A', 19);
INSERT INTO answer (id, created_date, deleted, modified_date, correct, name, question_id) VALUES (77, NULL, false, NULL, true, 'A', 20);
INSERT INTO answer (id, created_date, deleted, modified_date, correct, name, question_id) VALUES (81, NULL, false, NULL, true, 'A', 21);
INSERT INTO answer (id, created_date, deleted, modified_date, correct, name, question_id) VALUES (85, NULL, false, NULL, true, 'A', 22);
INSERT INTO answer (id, created_date, deleted, modified_date, correct, name, question_id) VALUES (89, NULL, false, NULL, true, 'A', 23);
INSERT INTO answer (id, created_date, deleted, modified_date, correct, name, question_id) VALUES (93, NULL, false, NULL, true, 'A', 24);
INSERT INTO answer (id, created_date, deleted, modified_date, correct, name, question_id) VALUES (97, NULL, false, NULL, true, 'A', 25);
INSERT INTO answer (id, created_date, deleted, modified_date, correct, name, question_id) VALUES (101, NULL, false, NULL, true, 'A', 26);
INSERT INTO answer (id, created_date, deleted, modified_date, correct, name, question_id) VALUES (105, NULL, false, NULL, true, 'A', 27);
INSERT INTO answer (id, created_date, deleted, modified_date, correct, name, question_id) VALUES (109, NULL, false, NULL, true, 'A', 28);
INSERT INTO answer (id, created_date, deleted, modified_date, correct, name, question_id) VALUES (113, NULL, false, NULL, true, 'A', 29);
INSERT INTO answer (id, created_date, deleted, modified_date, correct, name, question_id) VALUES (117, NULL, false, NULL, true, 'A', 30);
INSERT INTO answer (id, created_date, deleted, modified_date, correct, name, question_id) VALUES (121, NULL, false, NULL, true, 'A', 31);
INSERT INTO answer (id, created_date, deleted, modified_date, correct, name, question_id) VALUES (125, NULL, false, NULL, true, 'A', 32);
INSERT INTO answer (id, created_date, deleted, modified_date, correct, name, question_id) VALUES (129, NULL, false, NULL, true, 'A', 33);
INSERT INTO answer (id, created_date, deleted, modified_date, correct, name, question_id) VALUES (133, NULL, false, NULL, true, 'A', 34);
INSERT INTO answer (id, created_date, deleted, modified_date, correct, name, question_id) VALUES (137, NULL, false, NULL, true, 'A', 35);
INSERT INTO answer (id, created_date, deleted, modified_date, correct, name, question_id) VALUES (141, NULL, false, NULL, true, 'A', 36);
INSERT INTO answer (id, created_date, deleted, modified_date, correct, name, question_id) VALUES (144, NULL, false, NULL, true, 'A', 37);
INSERT INTO answer (id, created_date, deleted, modified_date, correct, name, question_id) VALUES (148, NULL, false, NULL, true, 'A', 38);


--
-- TOC entry 2409 (class 0 OID 0)
-- Dependencies: 183
-- Name: answer_sequence; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('answer_sequence', 1, false);


--
-- TOC entry 2379 (class 0 OID 66346)
-- Dependencies: 174
-- Data for Name: category; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO category (id, created_date, deleted, modified_date, color, image_url, name) VALUES (1, '2015-10-10 00:00:00', false, '2015-10-10 00:00:00', 'green', NULL, 'Власти и Деньги');
INSERT INTO category (id, created_date, deleted, modified_date, color, image_url, name) VALUES (2, '2015-10-10 00:00:00', false, '2015-10-10 00:00:00', 'red', NULL, 'Война и Насилие');
INSERT INTO category (id, created_date, deleted, modified_date, color, image_url, name) VALUES (3, '2015-10-10 00:00:00', false, '2015-10-10 00:00:00', 'orange', NULL, 'Ум и Разум');
INSERT INTO category (id, created_date, deleted, modified_date, color, image_url, name) VALUES (4, '2015-10-10 00:00:00', false, '2015-10-10 00:00:00', 'pink', NULL, 'Рогы и Копыта');
INSERT INTO category (id, created_date, deleted, modified_date, color, image_url, name) VALUES (5, '2015-10-10 00:00:00', false, '2015-10-10 00:00:00', 'black', NULL, 'Женщины');
INSERT INTO category (id, created_date, deleted, modified_date, color, image_url, name) VALUES (6, '2015-10-10 00:00:00', false, '2015-10-10 00:00:00', 'white', NULL, 'Мужчины');
INSERT INTO category (id, created_date, deleted, modified_date, color, image_url, name) VALUES (7, '2015-10-10 00:00:00', false, '2015-10-10 00:00:00', 'purple', NULL, 'Машины');
INSERT INTO category (id, created_date, deleted, modified_date, color, image_url, name) VALUES (8, '2015-10-10 00:00:00', false, '2015-10-10 00:00:00', 'blue', NULL, 'Ремонт');
INSERT INTO category (id, created_date, deleted, modified_date, color, image_url, name) VALUES (9, '2015-10-10 00:00:00', false, '2015-10-10 00:00:00', 'brown', NULL, 'Верю не верю');
INSERT INTO category (id, created_date, deleted, modified_date, color, image_url, name) VALUES (12, '2015-10-10 00:00:00', true, '2015-10-10 00:00:00', 'light-red', NULL, 'Новости');
INSERT INTO category (id, created_date, deleted, modified_date, color, image_url, name) VALUES (11, '2015-10-10 00:00:00', true, '2015-10-10 00:00:00', 'ligh-blue', NULL, 'Боровое');
INSERT INTO category (id, created_date, deleted, modified_date, color, image_url, name) VALUES (10, '2015-10-10 00:00:00', true, '2015-10-10 00:00:00', 'dark-brown', NULL, 'Недвижимость');


--
-- TOC entry 2410 (class 0 OID 0)
-- Dependencies: 184
-- Name: category_sequence; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('category_sequence', 1, false);


--
-- TOC entry 2385 (class 0 OID 66386)
-- Dependencies: 180
-- Data for Name: department; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO department (id, created_date, deleted, modified_date, name, scrore, usercount, parent_id) VALUES (5, '2015-10-10 00:00:00', false, '2015-10-10 00:00:00', 'Департамент контроля', 45, 0, 4);
INSERT INTO department (id, created_date, deleted, modified_date, name, scrore, usercount, parent_id) VALUES (7, '2015-10-10 00:00:00', false, '2015-10-10 00:00:00', 'Отел сопровождения', 45, 0, 5);
INSERT INTO department (id, created_date, deleted, modified_date, name, scrore, usercount, parent_id) VALUES (8, '2015-10-10 00:00:00', false, '2015-10-10 00:00:00', 'Отдел маразма', 45, 0, 5);
INSERT INTO department (id, created_date, deleted, modified_date, name, scrore, usercount, parent_id) VALUES (1, '2015-10-10 00:00:00', false, '2015-10-10 00:00:00', 'Головной филиал', 100, 0, NULL);
INSERT INTO department (id, created_date, deleted, modified_date, name, scrore, usercount, parent_id) VALUES (2, '2015-10-10 00:00:00', false, '2015-10-10 00:00:00', 'Департамент ИС', 30, 0, 1);
INSERT INTO department (id, created_date, deleted, modified_date, name, scrore, usercount, parent_id) VALUES (3, '2015-10-10 00:00:00', false, '2015-10-10 00:00:00', 'Отдел СУБД', 30, 0, 2);
INSERT INTO department (id, created_date, deleted, modified_date, name, scrore, usercount, parent_id) VALUES (4, '2015-10-10 00:00:00', false, '2015-10-10 00:00:00', 'Костанайский филиал', 70, 0, NULL);
INSERT INTO department (id, created_date, deleted, modified_date, name, scrore, usercount, parent_id) VALUES (6, '2015-10-10 00:00:00', false, '2015-10-10 00:00:00', 'Департамент ваты', 25, 0, 4);
INSERT INTO department (id, created_date, deleted, modified_date, name, scrore, usercount, parent_id) VALUES (9, '2015-10-10 00:00:00', false, '2015-10-10 00:00:00', 'Отдел отжима', 25, 0, 6);


--
-- TOC entry 2411 (class 0 OID 0)
-- Dependencies: 190
-- Name: department_sequence; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('department_sequence', 1, false);


--
-- TOC entry 2380 (class 0 OID 66355)
-- Dependencies: 175
-- Data for Name: game; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO game (id, created_date, deleted, modified_date, game_finished_date, game_started_date, invitation_accepted_date, invitation_sent_date, status) VALUES (18, '2015-11-01 20:13:11.403', false, '2015-11-01 20:13:11.403', NULL, NULL, NULL, '2015-11-01 20:13:11.403', 'FINISHED');
INSERT INTO game (id, created_date, deleted, modified_date, game_finished_date, game_started_date, invitation_accepted_date, invitation_sent_date, status) VALUES (19, '2015-11-01 20:13:21.274', false, '2015-11-01 20:13:21.274', NULL, NULL, NULL, '2015-11-01 20:13:21.274', 'FINISHED');
INSERT INTO game (id, created_date, deleted, modified_date, game_finished_date, game_started_date, invitation_accepted_date, invitation_sent_date, status) VALUES (21, '2015-11-01 21:02:41.194', false, '2015-11-01 21:02:41.194', NULL, NULL, NULL, '2015-11-01 21:02:41.194', 'WAITING');
INSERT INTO game (id, created_date, deleted, modified_date, game_finished_date, game_started_date, invitation_accepted_date, invitation_sent_date, status) VALUES (22, '2015-11-01 21:03:20.888', false, '2015-11-01 21:03:20.888', NULL, NULL, NULL, '2015-11-01 21:03:20.888', 'WAITING');
INSERT INTO game (id, created_date, deleted, modified_date, game_finished_date, game_started_date, invitation_accepted_date, invitation_sent_date, status) VALUES (20, '2015-11-01 21:02:36.575', false, '2015-11-01 21:02:36.575', NULL, NULL, '2015-11-01 23:00:59.861', '2015-11-01 21:02:36.575', 'STARTED');


--
-- TOC entry 2381 (class 0 OID 66361)
-- Dependencies: 176
-- Data for Name: game_round; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO game_round (id, created_date, deleted, modified_date, status, category_id, game_id) VALUES (5, '2015-11-01 23:15:17.128', false, '2015-11-01 23:15:17.128', 'WAITING_ANSWER', 1, 20);


--
-- TOC entry 2382 (class 0 OID 66367)
-- Dependencies: 177
-- Data for Name: game_round_question; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO game_round_question (id, created_date, deleted, modified_date, gameround_id, question_id) VALUES (5, '2015-11-01 23:15:17.136', false, '2015-11-01 23:15:17.136', 5, 9);
INSERT INTO game_round_question (id, created_date, deleted, modified_date, gameround_id, question_id) VALUES (6, '2015-11-01 23:15:17.139', false, '2015-11-01 23:15:17.139', 5, 1);
INSERT INTO game_round_question (id, created_date, deleted, modified_date, gameround_id, question_id) VALUES (7, '2015-11-01 23:15:17.143', false, '2015-11-01 23:15:17.143', 5, 3);


--
-- TOC entry 2383 (class 0 OID 66373)
-- Dependencies: 178
-- Data for Name: game_round_question_answer; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 2412 (class 0 OID 0)
-- Dependencies: 185
-- Name: game_round_question_answer_sequence; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('game_round_question_answer_sequence', 1, false);


--
-- TOC entry 2413 (class 0 OID 0)
-- Dependencies: 186
-- Name: game_round_question_sequence; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('game_round_question_sequence', 7, true);


--
-- TOC entry 2414 (class 0 OID 0)
-- Dependencies: 187
-- Name: game_round_sequence; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('game_round_sequence', 5, true);


--
-- TOC entry 2415 (class 0 OID 0)
-- Dependencies: 188
-- Name: game_sequence; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('game_sequence', 22, true);


--
-- TOC entry 2384 (class 0 OID 66380)
-- Dependencies: 179
-- Data for Name: gamer; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO gamer (id, created_date, deleted, modified_date, correct_answer_count, last_update_status_date, score, status, game_id, user_id, game_initiator, oponent_id) VALUES (31, '2015-11-01 20:13:11.413', false, '2015-11-01 20:13:11.413', 0, '2015-11-01 20:13:11.413', 0, 'LOOSER', 18, 2, false, 30);
INSERT INTO gamer (id, created_date, deleted, modified_date, correct_answer_count, last_update_status_date, score, status, game_id, user_id, game_initiator, oponent_id) VALUES (30, '2015-11-01 20:13:11.407', false, '2015-11-01 20:13:11.407', 0, '2015-11-01 20:13:11.407', 0, 'WINNER', 18, 1, true, 31);
INSERT INTO gamer (id, created_date, deleted, modified_date, correct_answer_count, last_update_status_date, score, status, game_id, user_id, game_initiator, oponent_id) VALUES (32, '2015-11-01 20:13:21.279', false, '2015-11-01 20:13:21.279', 0, '2015-11-01 20:13:21.279', 0, 'DRAW', 19, 1, true, 33);
INSERT INTO gamer (id, created_date, deleted, modified_date, correct_answer_count, last_update_status_date, score, status, game_id, user_id, game_initiator, oponent_id) VALUES (33, '2015-11-01 20:13:21.283', false, '2015-11-01 20:13:21.283', 0, '2015-11-01 20:13:21.283', 0, 'DRAW', 19, 3, false, 32);
INSERT INTO gamer (id, created_date, deleted, modified_date, correct_answer_count, last_update_status_date, score, status, game_id, user_id, game_initiator, oponent_id) VALUES (34, '2015-11-01 21:02:36.579', false, '2015-11-01 21:02:36.579', 0, '2015-11-01 23:00:59.867', 0, 'WAITING_OPONENT', 20, 1, true, 35);
INSERT INTO gamer (id, created_date, deleted, modified_date, correct_answer_count, last_update_status_date, score, status, game_id, user_id, game_initiator, oponent_id) VALUES (35, '2015-11-01 21:02:36.584', false, '2015-11-01 21:02:36.584', 0, '2015-11-01 23:00:59.871', 0, 'WAITING_ANSWERS', 20, 2, false, 34);
INSERT INTO gamer (id, created_date, deleted, modified_date, correct_answer_count, last_update_status_date, score, status, game_id, user_id, game_initiator, oponent_id) VALUES (36, '2015-11-01 21:02:41.197', false, '2015-11-01 21:02:41.197', 0, '2015-11-01 21:02:41.197', 0, 'WAITING_OPONENT_DECISION', 21, 3, true, 37);
INSERT INTO gamer (id, created_date, deleted, modified_date, correct_answer_count, last_update_status_date, score, status, game_id, user_id, game_initiator, oponent_id) VALUES (37, '2015-11-01 21:02:41.2', false, '2015-11-01 21:02:41.2', 0, '2015-11-01 21:02:41.2', 0, 'WAITING_OWN_DECISION', 21, 2, false, 36);
INSERT INTO gamer (id, created_date, deleted, modified_date, correct_answer_count, last_update_status_date, score, status, game_id, user_id, game_initiator, oponent_id) VALUES (38, '2015-11-01 21:03:20.891', false, '2015-11-01 21:03:20.891', 0, '2015-11-01 21:03:20.891', 0, 'WAITING_OPONENT_DECISION', 22, 3, true, 39);
INSERT INTO gamer (id, created_date, deleted, modified_date, correct_answer_count, last_update_status_date, score, status, game_id, user_id, game_initiator, oponent_id) VALUES (39, '2015-11-01 21:03:20.894', false, '2015-11-01 21:03:20.894', 0, '2015-11-01 21:03:20.894', 0, 'WAITING_OWN_DECISION', 22, 1, false, 38);


--
-- TOC entry 2416 (class 0 OID 0)
-- Dependencies: 189
-- Name: gamer_sequence; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('gamer_sequence', 39, true);


--
-- TOC entry 2386 (class 0 OID 66392)
-- Dependencies: 181
-- Data for Name: question; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO question (id, created_date, deleted, modified_date, image_url, text, type, category_id) VALUES (1, '2015-10-10 00:00:00', false, '2015-10-10 00:00:00', NULL, 'Вам нравятся деньги', 'TEXT', 1);
INSERT INTO question (id, created_date, deleted, modified_date, image_url, text, type, category_id) VALUES (2, '2015-10-10 00:00:00', false, '2015-10-10 00:00:00', NULL, 'Хотите больше денеш', 'TEXT', 1);
INSERT INTO question (id, created_date, deleted, modified_date, image_url, text, type, category_id) VALUES (3, '2015-10-10 00:00:00', false, '2015-10-10 00:00:00', NULL, 'Хотите пост призедента', 'TEXT', 1);
INSERT INTO question (id, created_date, deleted, modified_date, image_url, text, type, category_id) VALUES (4, '2015-10-10 00:00:00', false, '2015-10-10 00:00:00', NULL, 'Когда началась вторая мировая война?', 'TEXT', 2);
INSERT INTO question (id, created_date, deleted, modified_date, image_url, text, type, category_id) VALUES (5, '2015-10-10 00:00:00', false, '2015-10-10 00:00:00', NULL, 'Кого нужно уничтожить в мире', 'TEXT', 2);
INSERT INTO question (id, created_date, deleted, modified_date, image_url, text, type, category_id) VALUES (6, '2015-10-10 00:00:00', false, '2015-10-10 00:00:00', NULL, 'Кто выиграет в Сирии', 'TEXT', 2);
INSERT INTO question (id, created_date, deleted, modified_date, image_url, text, type, category_id) VALUES (7, '2015-10-10 00:00:00', false, '2015-10-10 00:00:00', NULL, 'Где живут немцы?', 'TEXT', 2);
INSERT INTO question (id, created_date, deleted, modified_date, image_url, text, type, category_id) VALUES (8, '2015-10-10 00:00:00', false, '2015-10-10 00:00:00', NULL, 'На каком материке находиться Казахстан', 'TEXT', 2);
INSERT INTO question (id, created_date, deleted, modified_date, image_url, text, type, category_id) VALUES (9, '2015-10-10 00:00:00', false, '2015-10-10 00:00:00', NULL, 'Какая валюта в Казахстане?', 'TEXT', 1);
INSERT INTO question (id, created_date, deleted, modified_date, image_url, text, type, category_id) VALUES (10, '2015-10-10 00:00:00', false, '2015-10-10 00:00:00', NULL, 'Сколько мозгов у человека?', 'TEXT', 3);
INSERT INTO question (id, created_date, deleted, modified_date, image_url, text, type, category_id) VALUES (11, '2015-10-10 00:00:00', false, '2015-10-10 00:00:00', NULL, 'Разум когда нибудь победит?', 'TEXT', 3);
INSERT INTO question (id, created_date, deleted, modified_date, image_url, text, type, category_id) VALUES (12, '2015-10-10 00:00:00', false, '2015-10-10 00:00:00', NULL, 'Средний вес мозгов', 'TEXT', 3);
INSERT INTO question (id, created_date, deleted, modified_date, image_url, text, type, category_id) VALUES (13, '2014-10-10 00:00:00', false, '2015-10-10 00:00:00', NULL, 'Какой цвет серого вещества?', 'TEXT', 3);
INSERT INTO question (id, created_date, deleted, modified_date, image_url, text, type, category_id) VALUES (14, '2015-10-10 00:00:00', false, '2015-10-10 00:00:00', NULL, 'Откуда появлось выржаение "Рога и Копыта"?', 'TEXT', 4);
INSERT INTO question (id, created_date, deleted, modified_date, image_url, text, type, category_id) VALUES (15, '2015-10-10 00:00:00', false, '2015-10-10 00:00:00', NULL, 'Что лучше рога или копыта?', 'TEXT', 4);
INSERT INTO question (id, created_date, deleted, modified_date, image_url, text, type, category_id) VALUES (16, '2015-10-10 00:00:00', false, '2015-10-10 00:00:00', NULL, 'Сколько букв в этих словах?', 'TEXT', 4);
INSERT INTO question (id, created_date, deleted, modified_date, image_url, text, type, category_id) VALUES (17, '2015-10-10 00:00:00', false, '2015-10-10 00:00:00', NULL, 'Кто из этого списка обладает копытами?', 'TEXT', 4);
INSERT INTO question (id, created_date, deleted, modified_date, image_url, text, type, category_id) VALUES (18, '2015-10-10 00:00:00', false, '2015-10-10 00:00:00', NULL, 'Выберите женское имя', 'TEXT', 5);
INSERT INTO question (id, created_date, deleted, modified_date, image_url, text, type, category_id) VALUES (19, '2015-10-10 00:00:00', false, '2015-10-10 00:00:00', NULL, 'Сколько мыслей думает женщина одновременно?', 'TEXT', 5);
INSERT INTO question (id, created_date, deleted, modified_date, image_url, text, type, category_id) VALUES (20, '2015-10-10 00:00:00', false, '2015-10-10 00:00:00', NULL, 'Сколько кошек должно быть у одной женщины?', 'TEXT', 5);
INSERT INTO question (id, created_date, deleted, modified_date, image_url, text, type, category_id) VALUES (21, '2015-10-10 00:00:00', false, '2015-10-10 00:00:00', NULL, 'Каких волос не существует у женщин?', 'TEXT', 5);
INSERT INTO question (id, created_date, deleted, modified_date, image_url, text, type, category_id) VALUES (22, '2015-10-10 00:00:00', false, '2015-10-10 00:00:00', NULL, 'Что не люят мужики?', 'TEXT', 6);
INSERT INTO question (id, created_date, deleted, modified_date, image_url, text, type, category_id) VALUES (23, '2015-10-10 00:00:00', false, '2015-10-10 00:00:00', NULL, 'Какой правильный вес для мужика?', 'TEXT', 6);
INSERT INTO question (id, created_date, deleted, modified_date, image_url, text, type, category_id) VALUES (24, '2015-10-10 00:00:00', false, '2015-10-10 00:00:00', NULL, 'Кто изображен на картинке?', 'IMAGE', 6);
INSERT INTO question (id, created_date, deleted, modified_date, image_url, text, type, category_id) VALUES (25, '2015-10-10 00:00:00', false, '2015-10-10 00:00:00', NULL, 'Закончите фразу "Губит людей не пиво, xxx"?', 'TEXT', 6);
INSERT INTO question (id, created_date, deleted, modified_date, image_url, text, type, category_id) VALUES (26, '2015-10-10 00:00:00', false, '2015-10-10 00:00:00', NULL, 'Что не является мужский именем', 'TEXT', 6);
INSERT INTO question (id, created_date, deleted, modified_date, image_url, text, type, category_id) VALUES (27, '2015-10-10 00:00:00', false, '2015-10-10 00:00:00', NULL, 'Какая машина совествкая', 'TEXT', 7);
INSERT INTO question (id, created_date, deleted, modified_date, image_url, text, type, category_id) VALUES (28, '2015-10-10 00:00:00', false, '2015-10-10 00:00:00', NULL, 'Тачка баклажан?', 'TEXT', 7);
INSERT INTO question (id, created_date, deleted, modified_date, image_url, text, type, category_id) VALUES (29, '2015-10-10 00:00:00', false, '2015-10-10 00:00:00', NULL, 'В честь кого названили Mercedes', 'TEXT', 7);
INSERT INTO question (id, created_date, deleted, modified_date, image_url, text, type, category_id) VALUES (30, '2015-10-10 00:00:00', false, '2015-10-10 00:00:00', NULL, 'В какой стране производиться Geely', 'TEXT', 7);
INSERT INTO question (id, created_date, deleted, modified_date, image_url, text, type, category_id) VALUES (31, '2015-10-10 00:00:00', false, '2015-10-10 00:00:00', NULL, 'Сколько длиться ремонт', 'TEXT', 8);
INSERT INTO question (id, created_date, deleted, modified_date, image_url, text, type, category_id) VALUES (32, '2015-10-10 00:00:00', false, '2015-10-10 00:00:00', NULL, 'Кто может помочь с ремонтом?', 'TEXT', 8);
INSERT INTO question (id, created_date, deleted, modified_date, image_url, text, type, category_id) VALUES (33, '2015-10-10 00:00:00', false, '2015-10-10 00:00:00', NULL, 'Кто чаще всего помогает с ремонтом?', 'TEXT', 8);
INSERT INTO question (id, created_date, deleted, modified_date, image_url, text, type, category_id) VALUES (34, '2015-10-10 00:00:00', false, '2015-10-10 00:00:00', NULL, 'Из какой страны чаще всего бригады работников?', 'TEXT', 8);
INSERT INTO question (id, created_date, deleted, modified_date, image_url, text, type, category_id) VALUES (35, '2015-10-10 00:00:00', false, '2015-10-10 00:00:00', NULL, 'Мася весит 80 кг?', 'TEXT', 9);
INSERT INTO question (id, created_date, deleted, modified_date, image_url, text, type, category_id) VALUES (36, '2015-10-10 00:00:00', false, '2015-10-10 00:00:00', NULL, 'Сколько нужно красный помидок?', 'TEXT', 9);
INSERT INTO question (id, created_date, deleted, modified_date, image_url, text, type, category_id) VALUES (37, '2015-10-10 00:00:00', false, '2015-10-10 00:00:00', NULL, 'Какого цвета флаг Казахстана?', 'TEXT', 9);
INSERT INTO question (id, created_date, deleted, modified_date, image_url, text, type, category_id) VALUES (38, '2015-10-10 00:00:00', false, '2015-10-10 00:00:00', NULL, 'Сколько подъездов в доме министерств', 'TEXT', 9);


--
-- TOC entry 2417 (class 0 OID 0)
-- Dependencies: 191
-- Name: question_sequence; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('question_sequence', 1, false);


--
-- TOC entry 2418 (class 0 OID 0)
-- Dependencies: 192
-- Name: user_sequence; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('user_sequence', 1, false);


--
-- TOC entry 2398 (class 0 OID 66479)
-- Dependencies: 193
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO users (id, created_date, deleted, modified_date, app_version, device_os_version, device_push_key, device_type, login, name, password, "position", score, auth_token, device_push_token, drawngames, email, last_activity_time, loosinggames, totalgames, wongames, department_id) VALUES (1, '2015-10-10 00:00:00', false, '2015-10-10 00:00:00', '1.0', '8.3.1', NULL, 'IOS', 'artem', 'artem demidovich', 'artem', 'Main Specialist', 10, 'artem1', NULL, 0, 'artem.demidovich@gmail.com', '2015-10-10 00:00:00', 0, 0, 0, 3);
INSERT INTO users (id, created_date, deleted, modified_date, app_version, device_os_version, device_push_key, device_type, login, name, password, "position", score, auth_token, device_push_token, drawngames, email, last_activity_time, loosinggames, totalgames, wongames, department_id) VALUES (2, '2015-10-10 00:00:00', false, '2015-10-10 00:00:00', NULL, NULL, NULL, NULL, 'alimzhan', 'alimzhan nurpeisov', 'alimzhan', 'Chief', 30, 'al1', NULL, 0, 'alimzhan@gmai.com', '2015-10-10 00:00:00', 0, 0, 0, 9);
INSERT INTO users (id, created_date, deleted, modified_date, app_version, device_os_version, device_push_key, device_type, login, name, password, "position", score, auth_token, device_push_token, drawngames, email, last_activity_time, loosinggames, totalgames, wongames, department_id) VALUES (3, '2015-10-10 00:00:00', false, '2015-10-10 00:00:00', NULL, NULL, NULL, NULL, 'denis', 'denis krylov', 'denis', 'Junior Developer', 20, 'd', NULL, 9, 'denis@aphion.kz', '2015-10-10 00:00:00', 0, 0, 0, 2);


--
-- TOC entry 2399 (class 0 OID 66550)
-- Dependencies: 194
-- Data for Name: users_friends; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO users_friends (user_id, friend_id) VALUES (1, 2);
INSERT INTO users_friends (user_id, friend_id) VALUES (1, 3);


--
-- TOC entry 2231 (class 2606 OID 66338)
-- Name: admin_user_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY admin_user
    ADD CONSTRAINT admin_user_pkey PRIMARY KEY (id);


--
-- TOC entry 2233 (class 2606 OID 66345)
-- Name: answer_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY answer
    ADD CONSTRAINT answer_pkey PRIMARY KEY (id);


--
-- TOC entry 2235 (class 2606 OID 66354)
-- Name: category_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY category
    ADD CONSTRAINT category_pkey PRIMARY KEY (id);


--
-- TOC entry 2237 (class 2606 OID 66360)
-- Name: game_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY game
    ADD CONSTRAINT game_pkey PRIMARY KEY (id);


--
-- TOC entry 2239 (class 2606 OID 66366)
-- Name: game_round_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY game_round
    ADD CONSTRAINT game_round_pkey PRIMARY KEY (id);


--
-- TOC entry 2243 (class 2606 OID 66379)
-- Name: game_round_question_answer_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY game_round_question_answer
    ADD CONSTRAINT game_round_question_answer_pkey PRIMARY KEY (id);


--
-- TOC entry 2241 (class 2606 OID 66372)
-- Name: game_round_question_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY game_round_question
    ADD CONSTRAINT game_round_question_pkey PRIMARY KEY (id);


--
-- TOC entry 2245 (class 2606 OID 66385)
-- Name: gamer_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY gamer
    ADD CONSTRAINT gamer_pkey PRIMARY KEY (id);


--
-- TOC entry 2247 (class 2606 OID 66391)
-- Name: organization_unit_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY department
    ADD CONSTRAINT organization_unit_pkey PRIMARY KEY (id);


--
-- TOC entry 2249 (class 2606 OID 66400)
-- Name: question_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY question
    ADD CONSTRAINT question_pkey PRIMARY KEY (id);


--
-- TOC entry 2251 (class 2606 OID 66487)
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- TOC entry 2267 (class 2606 OID 66558)
-- Name: fk126f65eafe2eb43; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY users_friends
    ADD CONSTRAINT fk126f65eafe2eb43 FOREIGN KEY (friend_id) REFERENCES users(id);


--
-- TOC entry 2266 (class 2606 OID 66553)
-- Name: fk126f65eec8edef6; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY users_friends
    ADD CONSTRAINT fk126f65eec8edef6 FOREIGN KEY (user_id) REFERENCES users(id);


--
-- TOC entry 2253 (class 2606 OID 66406)
-- Name: fk39c72301111439cf; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY game_round
    ADD CONSTRAINT fk39c72301111439cf FOREIGN KEY (game_id) REFERENCES game(id);


--
-- TOC entry 2254 (class 2606 OID 66411)
-- Name: fk39c723011364b30d; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY game_round
    ADD CONSTRAINT fk39c723011364b30d FOREIGN KEY (category_id) REFERENCES category(id);


--
-- TOC entry 2260 (class 2606 OID 66441)
-- Name: fk5d932c0111439cf; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY gamer
    ADD CONSTRAINT fk5d932c0111439cf FOREIGN KEY (game_id) REFERENCES game(id);


--
-- TOC entry 2262 (class 2606 OID 66573)
-- Name: fk5d932c0bcd77c7a; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY gamer
    ADD CONSTRAINT fk5d932c0bcd77c7a FOREIGN KEY (oponent_id) REFERENCES gamer(id);


--
-- TOC entry 2261 (class 2606 OID 66488)
-- Name: fk5d932c0ec8edef6; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY gamer
    ADD CONSTRAINT fk5d932c0ec8edef6 FOREIGN KEY (user_id) REFERENCES users(id);


--
-- TOC entry 2258 (class 2606 OID 66431)
-- Name: fk610a48f9117b7f05; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY game_round_question_answer
    ADD CONSTRAINT fk610a48f9117b7f05 FOREIGN KEY (gamer_id) REFERENCES gamer(id);


--
-- TOC entry 2259 (class 2606 OID 66436)
-- Name: fk610a48f94caf2345; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY game_round_question_answer
    ADD CONSTRAINT fk610a48f94caf2345 FOREIGN KEY (gameroundquestion_id) REFERENCES game_round_question(id);


--
-- TOC entry 2257 (class 2606 OID 66426)
-- Name: fk610a48f9815623cd; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY game_round_question_answer
    ADD CONSTRAINT fk610a48f9815623cd FOREIGN KEY (answer_id) REFERENCES answer(id);


--
-- TOC entry 2265 (class 2606 OID 66563)
-- Name: fk6a68e089f8f9896; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY users
    ADD CONSTRAINT fk6a68e089f8f9896 FOREIGN KEY (department_id) REFERENCES department(id);


--
-- TOC entry 2255 (class 2606 OID 66416)
-- Name: fk94c11b643bf56be5; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY game_round_question
    ADD CONSTRAINT fk94c11b643bf56be5 FOREIGN KEY (gameround_id) REFERENCES game_round(id);


--
-- TOC entry 2256 (class 2606 OID 66421)
-- Name: fk94c11b64a8b56a0d; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY game_round_question
    ADD CONSTRAINT fk94c11b64a8b56a0d FOREIGN KEY (question_id) REFERENCES question(id);


--
-- TOC entry 2252 (class 2606 OID 66401)
-- Name: fkabca3fbea8b56a0d; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY answer
    ADD CONSTRAINT fkabca3fbea8b56a0d FOREIGN KEY (question_id) REFERENCES question(id);


--
-- TOC entry 2264 (class 2606 OID 66451)
-- Name: fkba823be61364b30d; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY question
    ADD CONSTRAINT fkba823be61364b30d FOREIGN KEY (category_id) REFERENCES category(id);


--
-- TOC entry 2263 (class 2606 OID 66446)
-- Name: fkcd3fed10e5765543; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY department
    ADD CONSTRAINT fkcd3fed10e5765543 FOREIGN KEY (parent_id) REFERENCES department(id);


--
-- TOC entry 2406 (class 0 OID 0)
-- Dependencies: 5
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


-- Completed on 2015-11-03 23:13:44 ALMT

--
-- PostgreSQL database dump complete
--

