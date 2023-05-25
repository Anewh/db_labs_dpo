-- клиенты
CREATE TABLE public.customer (
    id integer generated by DEFAULT AS identity PRIMARY KEY,
    created_at timestamp NOT NULL DEFAULT NOW(),
    first_name varchar(128) NOT NULL,
    last_name varchar(128) NOT NULL,
    phone varchar(16) NOT NULL,
    email varchar(128)
);

-- статусы заказа
CREATE TABLE public."status" (
    id integer generated by DEFAULT AS identity PRIMARY KEY,
    name varchar(32) NOT NULL
);

-- заказы
CREATE TABLE public."order" (
    id integer generated by DEFAULT AS identity PRIMARY KEY,
    created_at timestamp NOT NULL DEFAULT NOW(),
    customer_id integer REFERENCES customer (id),
    manager_id integer,
    status_id integer REFERENCES "status"(id),
    is_paid bool NOT NULL DEFAULT false,
    total_sum numeric,
    utm_source text
);

-- история изменений полей заказа
CREATE TABLE public.order_history (
    id integer generated by DEFAULT AS identity PRIMARY KEY,
    order_id integer REFERENCES "order"(id),
    created_at timestamp NOT NULL DEFAULT NOW(),
    field_name varchar(256) NOT NULL, 
    old_value varchar(128), 
    new_value varchar(128) 
);

-- визиты клиентов на сайте
CREATE TABLE public.customer_visit (
    id integer generated by DEFAULT AS identity PRIMARY KEY,
    customer_id integer REFERENCES customer(id),
    created_at timestamp NOT NULL DEFAULT NOW(), 
    visit_length integer, 
    landing_page varchar(512) NOT NULL, 
    exit_page varchar(512), 
    utm_source varchar(128)
);

-- конкретные посещенные страницы
CREATE TABLE public.customer_visit_page (
    id integer generated by DEFAULT AS identity PRIMARY KEY,
    visit_id integer REFERENCES customer_visit(id),
    page varchar(512) NOT NULL, 
    time_on_page integer 
);