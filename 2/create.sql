CREATE TYPE public.my_enum AS ENUM ('first_value', 'second_value', 'third_value');

CREATE TYPE public.my_type AS
(
    example_int integer,
    example_int_array integer[]
);
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE TABLE IF NOT EXISTS public.types_table (
    bigint_field bigint NOT NULL,
    smallint_field smallint NOT NULL,
    numeric_field numeric NOT NULL,
    double_field double precision NOT NULL,

    boolean_field boolean NOT NULL,

    varchar_field character varying(32) COLLATE pg_catalog."default" NOT NULL,
    char_field character(32) COLLATE pg_catalog."default" NOT NULL,
    text_field text COLLATE pg_catalog."default" NOT NULL,

    date_field date NOT NULL,
    time_timezone_field time WITH time zone NOT NULL,
    time_field time without time zone NOT NULL,
    
    enum_field my_enum NOT NULL,
    array_field integer [] NOT NULL,

    xml_field xml NOT NULL,
    json_field json NOT NULL,
    
    composite_field my_type NOT NULL,

    money_field money NOT NULL,
    byte_field bytea NOT NULL,
    
    point_field point NOT NULL,
    line_field line NOT NULL,
    varbit_field bit varying(32) NOT NULL,
    
    uuid_field uuid NOT NULL DEFAULT uuid_generate_v4()
);
