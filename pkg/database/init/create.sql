drop table if exists pharmacy_managers;
drop table if exists admins;

create table pharmacy_managers (
    id serial primary key not null,
    username character varying(50) not null,
    name character varying(50) not null,
    password character varying(100) not null,
    phone character varying(12) not null,
    created_at timestamp without time zone not null default now()
);



create table admins (
    id serial primary key not null,
    username character varying(50) not null,
    name character varying(50) not null,
    password character varying(100) not null,
    phone character varying(12) not null,
    created_at timestamp without time zone not null default now()
);
