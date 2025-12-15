-- Table: public.jobs

-- DROP TABLE IF EXISTS public.jobs;

CREATE TABLE IF NOT EXISTS public.jobs
(
    id integer NOT NULL,
    deleted boolean DEFAULT false,
    type character varying COLLATE pg_catalog."default",
    by character varying COLLATE pg_catalog."default",
    created timestamp without time zone,
    title text COLLATE pg_catalog."default",
    body text COLLATE pg_catalog."default",
    dead boolean,
    parent integer DEFAULT '-1'::integer,
    url character varying COLLATE pg_catalog."default",
    score integer,
    descendants integer DEFAULT '-1'::integer,
    CONSTRAINT jobs_pkey PRIMARY KEY (id)
)

TABLESPACE pg_default;

-- Table: public.comments

-- DROP TABLE IF EXISTS public.comments;

CREATE TABLE IF NOT EXISTS public.comments
(
    id integer NOT NULL,
    deleted boolean DEFAULT false,
    type character varying COLLATE pg_catalog."default",
    by character varying COLLATE pg_catalog."default",
    created timestamp without time zone,
    title text COLLATE pg_catalog."default" DEFAULT 'null'::text,
    body text COLLATE pg_catalog."default",
    dead boolean,
    parent integer,
    url character varying COLLATE pg_catalog."default" DEFAULT 'null'::character varying,
    score integer,
    descendants integer,
    CONSTRAINT comments_pkey PRIMARY KEY (id)
)

TABLESPACE pg_default;


-- Table: public.stories

-- DROP TABLE IF EXISTS public.stories;

CREATE TABLE IF NOT EXISTS public.stories
(
    id integer NOT NULL,
    deleted boolean DEFAULT false,
    type character varying COLLATE pg_catalog."default",
    by character varying COLLATE pg_catalog."default",
    created timestamp without time zone,
    title text COLLATE pg_catalog."default",
    body text COLLATE pg_catalog."default",
    dead boolean,
    parent integer DEFAULT '-1'::integer,
    url character varying COLLATE pg_catalog."default",
    score integer,
    descendants integer,
    CONSTRAINT stories_pkey PRIMARY KEY (id)
)

TABLESPACE pg_default;


-- DROP TABLE IF EXISTS public.users;

CREATE TABLE IF NOT EXISTS public.users
(
    id character varying COLLATE pg_catalog."default" NOT NULL,
    created timestamp without time zone,
    karma integer DEFAULT '-1'::integer,
    about character varying COLLATE pg_catalog."default" DEFAULT 'null'::character varying,
    CONSTRAINT users_pkey PRIMARY KEY (id)
)

TABLESPACE pg_default;