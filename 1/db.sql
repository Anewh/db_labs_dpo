-- Table: public.user

-- DROP TABLE IF EXISTS public."user";

CREATE TABLE IF NOT EXISTS public."user"
(
    id integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1 ),
    username character varying(255) COLLATE pg_catalog."default" NOT NULL,
    mail character varying(255) COLLATE pg_catalog."default" NOT NULL,
    password character varying(255) COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT user_pkey PRIMARY KEY (id)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public."user"
    OWNER to postgres;

-- Table: public.post

-- DROP TABLE IF EXISTS public.post;

CREATE TABLE IF NOT EXISTS public.post
(
    id integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1 ),
    name character varying(255) COLLATE pg_catalog."default" NOT NULL,
    views_count bigint NOT NULL DEFAULT 0,
    content text COLLATE pg_catalog."default" NOT NULL,
    user_id integer NOT NULL,
    CONSTRAINT post_pkey PRIMARY KEY (id),
    CONSTRAINT user_id FOREIGN KEY (user_id)
        REFERENCES public."user" (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.post
    OWNER to postgres;

-- Table: public.comment

-- DROP TABLE IF EXISTS public.comment;

CREATE TABLE IF NOT EXISTS public.comment
(
    id integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1 ),
    content text COLLATE pg_catalog."default" NOT NULL,
    date time without time zone NOT NULL,
    user_id integer,
    post_id integer NOT NULL,
    CONSTRAINT comment_pkey PRIMARY KEY (id),
    CONSTRAINT post_id FOREIGN KEY (post_id)
        REFERENCES public.post (id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
        NOT VALID,
    CONSTRAINT user_id FOREIGN KEY (user_id)
        REFERENCES public."user" (id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE NO ACTION
        NOT VALID
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.comment
    OWNER to postgres;

-- Table: public.reaction

-- DROP TABLE IF EXISTS public.reaction;

CREATE TABLE IF NOT EXISTS public.reaction
(
    id integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1 ),
    type character varying(255) COLLATE pg_catalog."default" NOT NULL,
    post_id integer NOT NULL,
    user_id integer,
    CONSTRAINT reaction_pkey PRIMARY KEY (id),
    CONSTRAINT post_id FOREIGN KEY (post_id)
        REFERENCES public.post (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE
        NOT VALID,
    CONSTRAINT user_id FOREIGN KEY (user_id)
        REFERENCES public."user" (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.reaction
    OWNER to postgres;


