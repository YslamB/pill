drop table if exists admins;
drop table if exists pharmacy_managers;
drop table if exists product_categories;
drop table if exists bookmarks;
drop table if exists pharmacy_products;
drop table if exists products;
drop table if exists pharmacies;
drop table if exists categories;
drop table if exists producers;
drop table if exists cities;
drop table if exists devices;
drop table if exists countries;

create table countries (
    "id" serial primary key not null,
    "name" character varying(50) not null,
    "flag" character varying(50) not null,
    "status" boolean default true not null,
    "created_at" timestamp without time zone not null default now()
);

create table devices (
    "device_id" character varying(50) primary key not null,
    "active_date" timestamp without time zone not null default now()
);

create table producers (
    "id" serial primary key not null,
    "country_id" integer,
    "name" character varying(50) not null,
    "address" character varying(200),
    "description" text,
    "logo" character varying(200),
    "status" boolean default true not null,
    "created_at" timestamp without time zone not null default now(),
    CONSTRAINT producers_country_id_fk
        FOREIGN KEY ("country_id")
            REFERENCES countries("id") 
                ON UPDATE CASCADE ON DELETE set null
);

create table products (
    "id" serial primary key not null,
    "producer_id" integer,
    "name" character varying(50) not null,
    "description" text,
    "images" text[] default '{}',
    "packaging" character varying(50),
    "barcode" character varying(50),
    "strength" character varying(50),
    "dosage_type" character varying(50),
    "status" boolean default true not null,
    "created_at" timestamp without time zone not null default now(),
    CONSTRAINT products_producer_id_fk
        FOREIGN KEY ("producer_id")
            REFERENCES producers("id") 
                ON UPDATE CASCADE ON DELETE set null
);

create table categories (
    "id" serial primary key not null,
    "name" character varying(50) not null,
    "icon" character varying(50) not null,
    "status" boolean default true not null,
    "created_at" timestamp without time zone not null default now()
);

create table product_categories (
    "id" serial primary key not null,
    "product_id" integer,
    "category_id" integer,
    "created_at" timestamp without time zone not null default now(),

    CONSTRAINT product_categories_product_id_fk
        FOREIGN KEY ("product_id")
            REFERENCES products("id") 
                ON UPDATE CASCADE ON DELETE set null,

    CONSTRAINT product_categories_category_id_fk
        FOREIGN KEY ("category_id")
            REFERENCES categories("id") 
                ON UPDATE CASCADE ON DELETE set null
);

create table cities (
    "id" serial primary key not null,
    "name" character varying(50) not null,
    "status" boolean default true not null,
    "created_at" timestamp without time zone not null default now()
);


create table pharmacies (
    "id" serial primary key not null,
    "city_id" integer,
    "name" character varying(200) not null,
    "images" text[] default '{}',
    "address" character varying(200) not null,
    "phone" character varying(12) not null,
    "email" character varying(50),
    "open_time" character varying(50) not null,
    "close_time" character varying(50) not null,
    "open_status" boolean default true not null,
    "status" boolean default false not null,
    "created_at" timestamp without time zone not null default now(),
    CONSTRAINT pharmacies_city_id_fk
        FOREIGN KEY ("city_id")
            REFERENCES cities("id") 
                ON UPDATE CASCADE ON DELETE set null
);

create table pharmacy_products (
    "id" serial primary key not null,
    "pharmacy_id" integer,
    "product_id" integer,
    "price" integer not null,
    "expiration_date" date,
    "stock_count" integer,
    "cupon" boolean default false not null,
    "status" boolean default true not null,
    "created_at" timestamp without time zone not null default now(),
    CONSTRAINT pharmacy_products_pharmacy_id_fk
        FOREIGN KEY ("pharmacy_id")
            REFERENCES pharmacies("id") 
                ON UPDATE CASCADE ON DELETE set null,

    CONSTRAINT pharmacy_products_product_id_fk
        FOREIGN KEY ("product_id")
            REFERENCES products("id") 
                ON UPDATE CASCADE ON DELETE set null
);

create table bookmarks (
    "id" serial primary key not null,
    "ph_ps_id" int not null, -- pharmacy_products_id
    "device_id" character varying(50) not null,
    "created_at" timestamp without time zone default now(),
    CONSTRAINT bookmarks_ph_ps_id_fk
        FOREIGN KEY ("ph_ps_id")
            REFERENCES pharmacy_products("id")
                on update CASCADE on DELETE CASCADE,
    CONSTRAINT bookmarks_device_id_fk
        FOREIGN KEY ("device_id")
            REFERENCES devices("device_id")
                on update CASCADE on DELETE CASCADE

);

create table pharmacy_managers (
    "id" serial primary key not null,
    "pharmacy_id" integer,
    "username" character varying(50) not null,
    "name" character varying(50) not null,
    "password" character varying(100) not null,
    "phone" character varying(12) not null,
    "status" boolean default true not null,
    "created_at" timestamp without time zone not null default now(), 
    CONSTRAINT pharmacy_managers_pharmacy_id_fk
        FOREIGN KEY ("pharmacy_id")
            REFERENCES pharmacies("id") 
                ON UPDATE CASCADE ON DELETE set null
);



create table admins (
    "id" serial primary key not null,
    "username" character varying(50) not null,
    "name" character varying(50) not null,
    "password" character varying(100) not null,
    "phone" character varying(12) not null,
    "status" boolean default true not null,
    "created_at" timestamp without time zone not null default now()
);

