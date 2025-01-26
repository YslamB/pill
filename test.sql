--  "C:\Users\Yslam\Desktop\Git\news\server\DB\table.sql"
drop database newsdb;
\c postgres;

drop role news_user;
SET client_encoding TO 'UTF-8';
SHOW client_encoding;

-- CREATE ROLE news_user LOGIN SUPERUSER PASSWORD 'remember-salam_coding';
CREATE ROLE news_user LOGIN PASSWORD 'remember-salam_25!95';



-- create database news;
CREATE DATABASE newsdb;

\c newsdb;

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

--session Table


CREATE TABLE "sessions" (

    "sid" varchar NOT NULL COLLATE "default",
    "expire" timestamp(6) NOT NULL

)
WITH (OIDS=FALSE);
ALTER TABLE "sessions" OWNER TO news_user;
ALTER TABLE "sessions" ADD CONSTRAINT "sessions_pkey" PRIMARY KEY ("sid") NOT DEFERRABLE INITIALLY IMMEDIATE;

CREATE INDEX "InDX_session_expire" ON "sessions" ("expire");
--End session table

CREATE TABLE langs (

    "slug" CHARACTER VARYING(20) PRIMARY KEY NOT NULL,
    "created_at" TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT clock_timestamp(),
    UNIQUE("slug")

);
ALTER TABLE langs OWNER TO news_user;

CREATE TABLE users(

    "id" uuid PRIMARY KEY DEFAULT uuid_generate_v4 (),
    "username" CHARACTER VARYING(50) NOT NULL,
    "f_name" CHARACTER VARYING(50) NOT NULL,
    "l_name" CHARACTER VARYING(50) NOT NULL,
    "role" CHARACTER VARYING(50) DEFAULT 'default' NOT NULL,
    "image_path" CHARACTER VARYING(200) NOT NULL,
    "phone" CHARACTER VARYING(25) DEFAULT '00000000' NOT NULL,
    "password" CHARACTER VARYING(100) NOT NULL,
    "created_at" TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT clock_timestamp(),
    UNIQUE("username")

);
CREATE INDEX users_username_indx ON users ("username");
ALTER TABLE users OWNER TO news_user;


CREATE TABLE ctgs(

    "slug" CHARACTER VARYING(150) PRIMARY KEY NOT NULL,
    "absolute_name" CHARACTER VARYING(100) NOT NULL,
    "order_by" INT DEFAULT 0 NOT NULL,
    "created_at" TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT clock_timestamp(),
    UNIQUE("absolute_name"),
    UNIQUE("slug")

);


CREATE INDEX ctgs_slug_indx ON ctgs ("slug");
ALTER TABLE ctgs OWNER TO news_user;


CREATE TABLE sub_ctgs(

    "slug" CHARACTER VARYING(150) PRIMARY KEY NOT NULL,
    "ctg_slug" CHARACTER VARYING(150) NOT NULL,
    "absolute_name" CHARACTER VARYING(150) NOT NULL,
    "order_by" INT default 0 NOT NULL,
    "created_at" TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT clock_timestamp(),
    CONSTRAINT sub_ctgs_ctg_slug_fk
        FOREIGN KEY ("ctg_slug")
            REFERENCES ctgs("slug")
                ON DELETE CASCADE ON UPDATE CASCADE,
    UNIQUE("absolute_name"),
    UNIQUE("slug","ctg_slug")

);
CREATE INDEX sub_ctgs_ctg_slug_indx ON sub_ctgs ("ctg_slug");
ALTER TABLE sub_ctgs OWNER TO news_user;

CREATE TABLE sub_ctgs_trans(

    "id" SERIAL PRIMARY KEY NOT NULL,
    "sub_ctg_slug" CHARACTER VARYING(150) NOT NULL,
    "val" CHARACTER VARYING(100) NOT NULL,
    "lang_slug" CHARACTER VARYING(20) NOT NULL,
    "created_at" TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT clock_timestamp(),
    UNIQUE("sub_ctg_slug","lang_slug"),
    CONSTRAINT sub_ctgs_trans_sub_ctg_slug_fk
        FOREIGN KEY ("sub_ctg_slug")
            REFERENCES sub_ctgs("slug")
                ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT sub_ctgs_trans_lang_slug_fk
        FOREIGN KEY ("lang_slug")
            REFERENCES langs("slug")
                ON UPDATE CASCADE ON DELETE CASCADE

);
CREATE INDEX sub_ctgs_trans_sub_ctg_slug_indx ON sub_ctgs_trans ("sub_ctg_slug");
CREATE INDEX sub_ctgs_trans_lang_slug_indx ON sub_ctgs_trans ("lang_slug");
ALTER TABLE sub_ctgs_trans OWNER TO news_user;


CREATE TABLE ctgs_trans(

    "id" SERIAL PRIMARY KEY NOT NULL,
    "ctg_slug" CHARACTER VARYING(150) NOT NULL,
    "lang_slug" CHARACTER VARYING(20) NOT NULL,
    "val" CHARACTER VARYING(150) NOT NULL,
    "created_at" TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT clock_timestamp(),
    UNIQUE("ctg_slug","lang_slug"),
    CONSTRAINT ctgs_trans_ctg_slug_fk
        FOREIGN KEY ("ctg_slug")
            REFERENCES ctgs("slug")
                ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT ctgs_trans_lang_slug_fk
        FOREIGN KEY ("lang_slug")
            REFERENCES langs("slug")
                ON UPDATE CASCADE ON DELETE CASCADE

);
CREATE INDEX ctgs_trans_ctg_slug_indx ON ctgs_trans ("ctg_slug");
CREATE INDEX ctgs_trans_lang_slug_indx ON ctgs_trans ("lang_slug");
ALTER TABLE ctgs_trans OWNER TO news_user;


-- CREATE TABLE users(

--     "id" SERIAL PRIMARY KEY NOT NULL,
--     "f_name" CHARACTER VARYING(100) NOT NULL,
--     "l_name" CHARACTER VARYING(100) NOT NULL,
--     "email" CHARACTER VARYING(200) NOT NULL,
--     "status" CHARACTER VARYING(50) NOT NULL DEFAULT 'user',
--     "phone" NUMERIC(8) NOT NULL,
--     "password" CHARACTER VARYING(200) NOT NULL,
--     "verify_code" NUMERIC(6) DEFAULT 0,
--     "repeat_count" NUMERIC(2) DEFAULT 0,
--     "created_at" TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT clock_timestamp(),
--     UNIQUE("phone"),
--     UNIQUE("email") -- son duzedildi localde alter edilmedikdir sene: 06.12.2021.01:43

-- );
-- CREATE INDEX users_email_indx ON users ("email");
-- CREATE INDEX users_phone_indx ON users ("phone");
-- ALTER TABLE users OWNER TO news_user;



CREATE TABLE news_ctgs(

    "id" SERIAL PRIMARY KEY NOT NULL,
    "ctg_slug"  CHARACTER VARYING(150),
    "sub_ctg_slug" CHARACTER VARYING(150),
    "pinned" NUMERIC(2) NOT NULL DEFAULT 0,
    UNIQUE("sub_ctg_slug"),
    UNIQUE("ctg_slug"),
    CONSTRAINT news_ctgs_ctg_slug_fk
        FOREIGN KEY ("ctg_slug")
            REFERENCES ctgs("slug")
                ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT news_ctgs_sub_ctg_slug_fk
        FOREIGN KEY ("sub_ctg_slug")
            REFERENCES sub_ctgs("slug")
                ON UPDATE CASCADE ON DELETE CASCADE

);
CREATE INDEX news_ctgs_ctg_slug_indx ON news_ctgs ("ctg_slug");
CREATE INDEX news_ctgs_sub_ctg_slug_indx ON news_ctgs ("sub_ctg_slug");
ALTER TABLE news_ctgs OWNER TO news_user;

CREATE TABLE news (

    "id" SERIAL PRIMARY KEY NOT NULL,
    "title" CHARACTER VARYING(500) NOT NULL,
    "slug" CHARACTER VARYING(550) NOT NULL,
    "owner_id" uuid,
    "category_id" INT,
    "status" CHARACTER VARYING(50) DEFAULT 'default' NOT NULL,
    "created_at" TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    UNIQUE("slug"),
    CONSTRAINT news_category_id_fk
        FOREIGN KEY ("category_id")
            REFERENCES news_ctgs("id")
                ON UPDATE CASCADE ON DELETE SET NULL

);
CREATE INDEX news_category_id_indx ON news ("category_id");
CREATE INDEX news_slug_indx ON news ("slug");
ALTER TABLE news OWNER TO news_user;

CREATE TABLE news_trans(

    "id" SERIAL PRIMARY KEY NOT NULL,
    "title" CHARACTER VARYING(300),
    "author" CHARACTER VARYING(300),
    "photo_desc" CHARACTER VARYING(300),
    "status" CHARACTER VARYING(50) DEFAULT 'default' NOT NULL,
    "desc" TEXT,
    "content" JSON DEFAULT '{"data":[]}',
    "comment" CHARACTER VARYING(550),
    "news_id" INT NOT NULL,
    "pinned" NUMERIC(2) NOT NULL DEFAULT 0,
    "view_count" NUMERIC(15) NOT NULL DEFAULT 0,
    "writer_id" uuid,
    "lang_slug" CHARACTER VARYING(150) NOT NULL,
    "created_at" TIMESTAMP WITH TIME ZONE,
    UNIQUE("news_id","lang_slug"),
    CONSTRAINT news_trans_news_id_fk
        FOREIGN KEY ("news_id")
            REFERENCES news("id")
                ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT news_trans_lang_slug_fk
        FOREIGN KEY ("lang_slug")
            REFERENCES langs("slug")
                ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT news_trans_writer_id_fk
        FOREIGN KEY ("writer_id")
            REFERENCES users("id")
                ON UPDATE CASCADE ON DELETE SET NULL

);
CREATE INDEX news_trans_news_id_indx ON news_trans ("news_id");
CREATE INDEX news_trans_lang_slug_indx ON news_trans ("lang_slug");
CREATE INDEX news_trans_writer_id_indx ON news_trans ("writer_id");
CREATE INDEX news_trans_created_at_indx ON news_trans ("created_at");
ALTER TABLE news_trans OWNER TO news_user;




CREATE TABLE news_images(

    "id" SERIAL PRIMARY KEY NOT NULL,
    "news_id" INT NOT NULL,
    "image_path" CHARACTER VARYING(200) NOT NULL,
    "created_at" TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT clock_timestamp(),
    CONSTRAINT news_images_news_id_fk
        FOREIGN KEY ("news_id")
            REFERENCES news(id)
                ON UPDATE CASCADE ON DELETE CASCADE

);
CREATE INDEX news_images_news_id_indx ON news_images ("news_id");
ALTER TABLE news_images OWNER TO news_user;


CREATE TABLE news_midl_images(

    "id" SERIAL PRIMARY KEY NOT NULL,
    "news_trans_id" INT NOT NULL,
    "image_path" CHARACTER VARYING(200) NOT NULL,
    "created_at" TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT clock_timestamp(),
    CONSTRAINT news_midl_images_news_trans_id_fk
        FOREIGN KEY ("news_trans_id")
            REFERENCES news_trans ("id")
                ON UPDATE CASCADE ON DELETE CASCADE

);
CREATE INDEX news_midl_images_news_trans_id_indx ON news_midl_images ("news_trans_id");
ALTER TABLE news_midl_images OWNER TO news_user;


CREATE TABLE news_views (

    "news_id" INT NOT NULL,
    "session_id" VARCHAR NOT NULL,
    "created_at" TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT clock_timestamp(),
    CONSTRAINT news_views_news_id_fk 
        FOREIGN KEY ("news_id")
            REFERENCES news_trans ("id")
                ON UPDATE CASCADE ON DELETE CASCADE

);

CREATE INDEX news_views_news_id_indx ON news_views ("news_id");
CREATE INDEX news_views_session_id_indx ON news_views ("session_id");
-- CREATE INDEX news_views_created_at_indx ON news_views ("created_at");
ALTER TABLE news_views OWNER TO news_user;



CREATE TABLE likes(

    "id" SERIAL PRIMARY KEY NOT NULL,
    "news_id" INT NOT NULL,
    "session_id" VARCHAR NOT NULL,
    "created_at" TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT clock_timestamp(),
    CONSTRAINT likes_news_id_fk 
        FOREIGN KEY ("news_id")
            REFERENCES news("id")
                ON UPDATE CASCADE ON DELETE CASCADE,
    UNIQUE( "news_id", "session_id")

);
CREATE INDEX likes_news_id_indx ON likes ("news_id");
ALTER TABLE likes OWNER TO news_user;



CREATE TABLE bookmarks(

    "id" SERIAL PRIMARY KEY NOT NULL,
    "news_id" INT NOT NULL,
    "user_id" INT NOT NULL,
    "created_at" TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT clock_timestamp(),
    CONSTRAINT bookmarks_user_id_fk
        FOREIGN KEY ("user_id")
            REFERENCES users("id")
                ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT bookmarks_news_id_fk 
        FOREIGN KEY ("news_id")
            REFERENCES news("id")
                ON UPDATE CASCADE ON DELETE CASCADE,
    UNIQUE( "news_id", "user_id")

);
CREATE INDEX bookmarks_news_id_indx ON bookmarks ("news_id");
CREATE INDEX bookmarks_user_id_indx ON bookmarks ("user_id");
ALTER TABLE bookmarks OWNER TO news_user;

CREATE TABLE weathers(

    "id" SERIAL PRIMARY KEY NOT NULL,
    "val" CHARACTER VARYING(50) NOT NULL,
    UNIQUE("val")

);
CREATE INDEX weathers_name_indx ON weathers ("val");
ALTER TABLE weathers OWNER TO news_user;


CREATE TABLE temperatures(

    "id" SERIAL PRIMARY KEY NOT NULL,
    "weather_id" INT NOT NULL,
    "day" CHARACTER VARYING(2) NOT NULL,
    "icon" CHARACTER VARYING(100) NOT NULL,
    "temp_c" NUMERIC(3, 1) NOT NULL,
    CONSTRAINT temperatures_weather_id_fk
        FOREIGN KEY ("weather_id")
            REFERENCES weathers("id")
                ON UPDATE CASCADE ON DELETE CASCADE,
    UNIQUE("weather_id", "day")

);
CREATE INDEX temperatures_weather_id_indx ON temperatures ("weather_id");
CREATE INDEX temperatures_day_indx ON temperatures ("day");
ALTER TABLE temperatures OWNER TO news_user;

ALTER SCHEMA public
OWNER TO news_user;


CREATE TABLE opinions(

    "id" SERIAL PRIMARY KEY NOT NULL,
    "title" CHARACTER VARYING(500),
    "author" CHARACTER VARYING(300),
    "slug" CHARACTER VARYING(550) NOT NULL,
    "status" CHARACTER VARYING(15) DEFAULT 'default' NOT NULL,
    "desc" TEXT,
    "html" TEXT,
    "user_id" uuid,
    "lang_slug" CHARACTER VARYING(20),
    "created_at" TIMESTAMP WITH TIME ZONE,
    UNIQUE("slug","lang_slug"),
    CONSTRAINT opinions_language_id_fk
        FOREIGN KEY ("lang_slug")
            REFERENCES langs("slug")
                ON UPDATE CASCADE ON DELETE SET NULL,
    CONSTRAINT opinions_user_id_fk
        FOREIGN KEY ("user_id")
            REFERENCES users("id")
                ON UPDATE CASCADE ON DELETE SET NULL

);
CREATE INDEX opinions_lang_slug_indx ON opinions ("lang_slug");
CREATE INDEX opinions_slug_indx ON opinions ("slug");
CREATE INDEX opinions_user_id_indx ON opinions ("user_id");
CREATE INDEX opinions_created_at_indx ON opinions ("created_at");
ALTER TABLE opinions OWNER TO news_user;




CREATE TABLE opinion_images(

    "id" SERIAL PRIMARY KEY NOT NULL,
    "opinion_id" INT NOT NULL,
    "image_path" CHARACTER VARYING(200) NOT NULL,
    "created_at" TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT clock_timestamp(),
    CONSTRAINT opinion_images_opinion_id_fk
        FOREIGN KEY ("opinion_id")
            REFERENCES opinions(id)
                ON UPDATE CASCADE ON DELETE CASCADE

);
CREATE INDEX opinion_images_opinion_id_indx ON opinion_images ("opinion_id");
ALTER TABLE opinion_images OWNER TO news_user;


CREATE TABLE photo_gallery(

    "id" SERIAL PRIMARY KEY NOT NULL,
    "slug" CHARACTER VARYING(500),
    "status" CHARACTER VARYING(50) DEFAULT 'default' NOT NULL,
    "created_at" TIMESTAMP WITH TIME ZONE,
    "o_created_at" TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT clock_timestamp(),
    UNIQUE("slug")

);
CREATE INDEX photo_gallery_slug_indx ON photo_gallery ("slug");
CREATE INDEX photo_gallery_created_at_indx ON photo_gallery ("created_at");
ALTER TABLE photo_gallery OWNER TO news_user;


CREATE TABLE photo_gallery_trans(

    "id" SERIAL PRIMARY KEY NOT NULL,
    "title" CHARACTER VARYING(500),
    "desc" TEXT,
    "lang_slug" CHARACTER VARYING(20) NOT NULL,
    "gallery_id" INT NOT NULL,
    "o_created_at" TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT clock_timestamp(),
    UNIQUE("gallery_id","lang_slug"),
    CONSTRAINT photo_gallery_language_id_fk
        FOREIGN KEY ("lang_slug")
            REFERENCES langs("slug")
                ON UPDATE CASCADE ON DELETE SET NULL,
    CONSTRAINT photo_gallery_trans_gallery_id_fk
        FOREIGN KEY ("gallery_id")
            REFERENCES photo_gallery("id")
                ON UPDATE CASCADE ON DELETE CASCADE

);
CREATE INDEX photo_gallery_trans_lang_slug_indx ON photo_gallery_trans ("lang_slug");
CREATE INDEX photo_gallery_trans_galley_id_indx ON photo_gallery_trans ("gallery_id");
CREATE INDEX photo_gallery_trans_o_created_at_indx ON photo_gallery_trans ("o_created_at");
ALTER TABLE photo_gallery_trans OWNER TO news_user;





CREATE TABLE gallery_images(

    "id" SERIAL PRIMARY KEY NOT NULL,
    "gallery_id" INT NOT NULL,
    "image_path" CHARACTER VARYING(200) NOT NULL,
    "created_at" TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT clock_timestamp(),
    CONSTRAINT gallery_images_gallery_id_fk
        FOREIGN KEY ("gallery_id")
            REFERENCES photo_galLery(id)
                ON UPDATE CASCADE ON DELETE CASCADE

);
CREATE INDEX gallery_images_gallery_id_indx ON gallery_images ("gallery_id");
ALTER TABLE gallery_images OWNER TO news_user;



CREATE TABLE video_gallery(

    "id" SERIAL PRIMARY KEY NOT NULL,
    "slug" CHARACTER VARYING(500),
    "image_path" CHARACTER VARYING(500),
    "status" CHARACTER VARYING(50) DEFAULT 'default' NOT NULL,
    "created_at" TIMESTAMP WITH TIME ZONE,
    "o_created_at" TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT clock_timestamp(),
    UNIQUE("slug")

);
CREATE INDEX video_gallery_slug_indx ON video_gallery ("slug");
CREATE INDEX video_gallery_created_at_indx ON video_gallery ("created_at");
ALTER TABLE video_gallery OWNER TO news_user;


CREATE TABLE video_gallery_trans(

    "id" SERIAL PRIMARY KEY NOT NULL,
    "title" CHARACTER VARYING(500),
    "desc" TEXT,
    "lang_slug" CHARACTER VARYING(20) NOT NULL,
    "gallery_id" INT NOT NULL,
    "o_created_at" TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT clock_timestamp(),
    UNIQUE("gallery_id","lang_slug"),
    CONSTRAINT video_gallery_language_id_fk
        FOREIGN KEY ("lang_slug")
            REFERENCES langs("slug")
                ON UPDATE CASCADE ON DELETE SET NULL,
    CONSTRAINT video_gallery_trans_gallery_id_fk
        FOREIGN KEY ("gallery_id")
            REFERENCES video_gallery("id")
                ON UPDATE CASCADE ON DELETE CASCADE

);
CREATE INDEX video_gallery_trans_lang_slug_indx ON video_gallery_trans ("lang_slug");
CREATE INDEX video_gallery_trans_galley_id_indx ON video_gallery_trans ("gallery_id");
CREATE INDEX video_gallery_trans_o_created_at_indx ON video_gallery_trans ("o_created_at");
ALTER TABLE video_gallery_trans OWNER TO news_user;





CREATE TABLE gallery_videos(

    "id" SERIAL PRIMARY KEY NOT NULL,
    "gallery_id" INT NOT NULL,
    "video_path" CHARACTER VARYING(200) NOT NULL,
    "created_at" TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT clock_timestamp(),
    CONSTRAINT gallery_videos_gallery_id_fk
        FOREIGN KEY ("gallery_id")
            REFERENCES video_gallery(id)
                ON UPDATE CASCADE ON DELETE CASCADE

);
CREATE INDEX gallery_videos_gallery_id_indx ON gallery_videos ("gallery_id");
ALTER TABLE gallery_videos OWNER TO news_user;



CREATE TABLE video_views (

    "video_id" INT NOT NULL,
    "session_id" VARCHAR NOT NULL,
    "created_at" TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT clock_timestamp(),
    CONSTRAINT video_views_video_id_fk 
        FOREIGN KEY ("video_id")
            REFERENCES video_gallery ("id")
                ON UPDATE CASCADE ON DELETE CASCADE

);



----------------------------- FUNCTIONS
CREATE OR REPLACE FUNCTION insert_news_view(_viewnews_id integer, uu_id character) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
    DECLARE
        n_id INT;
    BEGIN
        SELECT news_id into n_id
            FROM news_views
            WHERE 
                created_at > now() - interval '1 day'
                and session_id=$2 and news_id = $1;
        IF NOT FOUND THEN
            insert into news_views (news_id, session_id)
            values ($1, $2) returning news_id into n_id;
            
            update news_trans set 
                view_count = view_count + 1 where id =$1;
                
        END IF;

        RETURN n_id;
    END;
$_$;


ALTER FUNCTION insert_news_view(_viewnews_id integer, uu_id character) OWNER TO news_user;

------------------------------------------------------------------------------------------------
-- USERS


CREATE TABLE user_reports(

    "id" SERIAL PRIMARY KEY NOT NULL,
    "first_name" CHARACTER VARYING(50) NOT NULL,
    "last_name" CHARACTER VARYING(50) NOT NULL,
    "email" CHARACTER VARYING(100) NOT NULL,
    "thema" CHARACTER VARYING(200) NOT NULL,
    "text" TEXT NOT NULL,   
    "status" BOOLEAN NOT NULL,   
    "created_at" TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT clock_timestamp()
    
);



CREATE TABLE user_news(

    "id" SERIAL PRIMARY KEY NOT NULL,
    "first_name" CHARACTER VARYING(50) NOT NULL,
    "last_name" CHARACTER VARYING(50) NOT NULL,
    "email" CHARACTER VARYING(100) NOT NULL,
    "title" CHARACTER VARYING(200) NOT NULL,  
    "file_path" CHARACTER VARYING(200) NOT NULL,  
    "status" BOOLEAN NOT NULL,   
    "created_at" TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT clock_timestamp()
);

-- Compotition


CREATE TABLE compotitions(

    "id" SERIAL PRIMARY KEY NOT NULL,
    "status" INT NOT NULL DEFAULT 0,
    "title" CHARACTER VARYING(200) NOT NULL,
    "start_date" TIMESTAMP WITH TIME ZONE,
    "end_date" TIMESTAMP WITH TIME ZONE,
    "created_at" TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT clock_timestamp()

);
ALTER TABLE compotitions OWNER TO news_user;

"createdAt" timestamp(3) without time zone DEFAULT now() NOT NULL,

CREATE TABLE compotition_news(

    "id" SERIAL PRIMARY KEY NOT NULL,
    "compotition_id" INT NOT NULL,
    "title" CHARACTER VARYING(300),
    "slug" CHARACTER VARYING(300),
    "author" CHARACTER VARYING(300),
    "photo_desc" CHARACTER VARYING(300),
    "status" CHARACTER VARYING(50) DEFAULT 'default' NOT NULL,
    "desc" TEXT,
    "content" TEXT,
    "view_count" NUMERIC(15) NOT NULL DEFAULT 0,
    "lang_slug" CHARACTER VARYING(25) NOT NULL,
    "created_at" TIMESTAMP WITH TIME ZONE,
    CONSTRAINT compotition_news_lang_slug_fk
        FOREIGN KEY ("lang_slug")
            REFERENCES langs("slug")
                ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT compotition_news_compotition_id_fk
        FOREIGN KEY ("compotition_id")
            REFERENCES compotitions("id")
                ON UPDATE CASCADE ON DELETE CASCADE

);
CREATE INDEX compotition_news_lang_slug_indx ON compotition_news ("lang_slug");
CREATE INDEX compotition_news_created_at_indx ON compotition_news ("created_at");
ALTER TABLE compotition_news OWNER TO news_user;




CREATE TABLE compotition_news_images(

    "id" SERIAL PRIMARY KEY NOT NULL,
    "compotition_news_id" INT NOT NULL,
    "image_path" CHARACTER VARYING(200) NOT NULL,
    "created_at" TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT clock_timestamp(),
    CONSTRAINT compotition_news_news_id_fk
        FOREIGN KEY ("compotition_news_id")
            REFERENCES compotition_news(id)
                ON UPDATE CASCADE ON DELETE CASCADE

);
CREATE INDEX compotition_news_news_id_indx ON compotition_news_images ("compotition_news_id");
ALTER TABLE compotition_news_images OWNER TO news_user;

CREATE TABLE compotition_news_midl_images(

    "id" SERIAL PRIMARY KEY NOT NULL,
    "compotition_news_id" INT NOT NULL,
    "image_path" CHARACTER VARYING(200) NOT NULL,
    "created_at" TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT clock_timestamp(),
    CONSTRAINT compotition_news_midl_images_news_trans_id_fk
        FOREIGN KEY ("compotition_news_id")
            REFERENCES compotition_news ("id")
                ON UPDATE CASCADE ON DELETE CASCADE

);


CREATE INDEX compotition_news_midl_images_compotition_news_id_indx ON compotition_news_midl_images ("compotition_news_id");
ALTER TABLE compotition_news_midl_images OWNER TO news_user;

CREATE TABLE compotition_news_views (

    "compotition_news_id" INT NOT NULL,
    "session_id" VARCHAR NOT NULL,
    "created_at" TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT clock_timestamp(),
    CONSTRAINT compotition_news_views_compotition_news_id_fk 
        FOREIGN KEY ("compotition_news_id")
            REFERENCES compotition_news ("id")
                ON UPDATE CASCADE ON DELETE CASCADE

);

CREATE INDEX compotition_news_views_compotition_news_id_indx ON compotition_news_views ("compotition_news_id");
CREATE INDEX compotition_news_views_session_id_indx ON compotition_news_views ("session_id");
-- CREATE INDEX compotition_news_views_created_at_indx ON compotition_news_views ("created_at");
ALTER TABLE compotition_news_views OWNER TO news_user;

-- /////////////////////////////////////////////////////////////


CREATE FUNCTION insert_competition_news_view(_viewnews_id integer, uu_id character) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
    DECLARE
        n_id INT;
    BEGIN
        SELECT compotition_news_id into n_id
            FROM compotition_news_views
            WHERE 
                created_at > now() - interval '1 day'
                and session_id=$2 and compotition_news_id = $1;
        IF NOT FOUND THEN
            insert into compotition_news_views (compotition_news_id, session_id)
            values ($1, $2) returning compotition_news_id into n_id;
            
            update compotition_news set 
                view_count = view_count + 1 where id =$1;
                
        END IF;

        RETURN n_id;
    END;
$_$;


ALTER FUNCTION insert_competition_news_view(_viewnews_id integer, uu_id character) OWNER TO news_user;






WITH news_sort_id AS (
    SELECT 
        news_id,
        extract(hour from created_at) as hour
          
    FROM
        news_views
        where created_at::date = '2022-03-13'::date
)
select news_id , hour , count(*) from news_sort_id  group by hour;


with first_news as (
	select news_id, count(*) as view_count from news_views 
	where created_at :: date = '2022-03-13'::date
	group by news_id
	order by view_count desc
	limit 20
)
select * from news_trans
    left join first_news fn on fn.news_id=news_trans.id
    order by fn.view_count;

CREATE TABLE insurance_policies_p_2018 PARTITION OF insurance_policies_p FOR VALUES FROM ('2018-01-01') TO ('2018-12-31');
CREATE TABLE insurance_policies_p_2019 PARTITION OF insurance_policies_p FOR VALUES FROM ('2019-01-01') TO ('2019-12-31');
CREATE TABLE insurance_policies_p_2020 PARTITION OF insurance_policies_p FOR    VALUES FROM ('2020-01-01') TO ('2020-12-31');


SELECT *
   FROM mytable
  WHERE (start_date, end_date) OVERLAPS ('2012-01-01'::DATE, '2012-04-12'::DATE);

  with image_json as (
            select 
                compotition_news_id, json_agg(compotition_news_images.*) as images 
            from (
                select id, compotition_news_id, image_path
                from compotition_news_images
            ) as compotition_news_images
            group by compotition_news_id
        ), c_news AS (
            select 
                cn.* , cni.images 
            from compotition_news cn 
                left join image_json cni on cn.id =cni.compotition_news_id 
        ) 
        ${
            date?
                `   , day_views as (
                    select 
                        compotition_news_id, count(*) as date_view_count 
                    from compotition_news_views 
                    where created_at::date = '${date}'::date
                    group by compotition_news_id
                    )
                `:``
        }
        
        ${date ? 
            `   select  c_news.*, day_views.date_view_count from c_news
                left join day_views on day_views.compotition_news_id=c_news.id
            `:
            `
                select  c_news.*  from c_news
            `
        }
        ${competition_id ? `where c_news.compotition_id = ${competition_id} ${lang ? ` and c_news.lang = $lang$${lang}$lang$`:``}`:
        `${lang ? ` where c_news.lang = $lang$${lang}$lang$ `:``}` } 
        order by c_news.created_at ;


                if (role != 'main_redaktor') {

            q_where = `
                where writer_id = '${u_id}' and  
                ${params[0] == 'editable' ? `(status='editable' or status='decline' or status='default') ` : `status=?`}
                ${q_lang}
            `

        } else {
            q_where = `
                where  ${is_my ? ` writer_id = '${u_id}' and ` : ''} 
                ${params[0] == 'editable' ? `(status='editable' or status='decline' or status='default') ` : `status=?`}
                ${q_lang}
            `
        }
        
    }

    var q_pg = `
            with news as (
                select 
                    news.id as news_id, news.slug,
                    ctgs.slug as ctg_slug, sub_ctgs.slug as sub_ctg_slug,
                        case 
                            when news.owner_id is not null then true
                            else false
                        end 
                    is_writer
                from news
                    left join news_ctgs on news_ctgs.id=news.category_id
                    left join sub_ctgs on sub_ctgs.slug = news_ctgs.sub_ctg_slug
                    left join ctgs on ctgs.slug = news_ctgs.ctg_slug or ctgs.slug = sub_ctgs.ctg_slug

            ),  as (
                select 
                    news_trans.id, news_trans.status, news_trans.desc, news_trans.title, 
                    news_trans.lang_slug as lang, news_trans.news_id, news_trans.comment, 
                    now() - news_trans.created_at as created_at, news_trans.created_at as o_created_at,
                    users.f_name, users.l_name, users.username
                from news_trans
                    left join users on users.id=news_trans.writer_id

                ${q_where}
            ), images as (
                select news_id, json_agg(imgs.image_path) as images from 
                    (
                        select news_id, image_path from news_images
                            order by created_at asc
                    ) as imgsthemes
                group by news_id
            )
            ${(params[0] == 'published') ? 

            `${limit ? q_text : ` select count(*) from themes; `} 

            ${limit ? 'limit ' + limit + `${page ? ` offset ${limit * (page - 1)}` : ``}` : ''}` 
                :
            q_text}
            ;
        `

         with news as (
            select 
                news.id, news.slug, news_trans.title, news_trans.author, news_trans.id as trans_id, 
                news_trans.desc, news_trans.content, news_trans.view_count, news_trans.photo_desc, news_trans.tags,
                json_build_object(
                    'days', DATE_PART('day', now() - news_trans.created_at + interval '10 hours'),
                    'hours', DATE_PART('hour', now() - news_trans.created_at + interval '10 hours' ),
                    'minutes', DATE_PART('min', now()) - DATE_PART('min',  news_trans.created_at)
                ) as created_at, news_trans.created_at as o_created_at,
                images.images, ctgs.slug as ctg_slug, ctgs_trans.val as ctg_name, 
                news_ctgs.sub_ctg_slug, sub_ctgs_trans.val as sub_ctg_name
            from news
                left join news_trans on news_trans.news_id=news.id and news_trans.lang_slug=?
                left join (
                        select news_id, json_agg(image_path) as images from news_images
                        group by news_id 
                ) as images on images.news_id=news.id
                left join news_ctgs on news_ctgs.id = news.category_id
            
                left join sub_ctgs on sub_ctgs.slug = news_ctgs.sub_ctg_slug
                left join sub_ctgs_trans on sub_ctgs_trans.sub_ctg_slug = sub_ctgs.slug and sub_ctgs_trans.lang_slug=?
            
                left join ctgs on ctgs.slug = news_ctgs.ctg_slug or ctgs.slug = sub_ctgs.ctg_slug
                left join ctgs_trans on ctgs_trans.ctg_slug=ctgs.slug and ctgs_trans.lang_slug=?
                
            where news_trans.status='published' and news.slug=?
        ), other_langs_ck as (
            select lang, json_agg(lang_slug) as other_langs from 
            (select news_trans.lang_slug, 'tm' as lang from news 
                left join news_trans on news_trans.news_id=news.id and news_trans.status = 'published' and news_trans.lang_slug != ?
            where news.slug=?) as gotoved
            group by lang
        )
        select news.*, other_langs_ck.other_langs  from news
        cross join other_langs_ck;



 select 
        news_ctgs.id, 
                case 
                    when news_ctgs.ctg_slug is null then news_ctgs.sub_ctg_slug
                    else news_ctgs.ctg_slug
                end 
            slug, 
            case 
                    when news_ctgs.ctg_slug is null then sub_ctgs_trans.val
                    else ctgs_trans.val
                end 
            "name",
            ctgs.slug as "ctg_slug", ctgs_trans.val as "ctg_name",
            sub_ctgs.slug as "sub_ctg_slug", sub_ctgs_trans.val as "sub_ctg_name"
        from news_ctgs 
            left join sub_ctgs on sub_ctgs.slug=news_ctgs.sub_ctg_slug
            left join ctgs on ctgs.slug=news_ctgs.ctg_slug or ctgs.slug=sub_ctgs.ctg_slug
            left join ctgs_trans on ctgs_trans.ctg_slug=ctgs.slug and ctgs_trans.lang_slug=$$${params[0]}$$
            left join sub_ctgs_trans on sub_ctgs_trans.sub_ctg_slug=sub_ctgs.slug and sub_ctgs_trans.lang_slug=$$${params[0]}$$
        where pinned !=0 order by pinned asc;



        select news_id, json_agg(image_path) as images from 
            news_images
            group by news_id


CREATE TABLE measurement (
    city_id         int not null,
    logdate         date not null,
    peaktemp        int,
    unitsales       int,
    PRIMARY KEY (city_id, logdate) -- assuming a primary key for uniqueness
) PARTITION BY RANGE (logdate);
-- //////////////////////////////////////////////////////////////////////////////////////////////////////////


create table us(
    id serial primary key not null,
    name character varying(100) not null
);

insert into us (name) values ('aa1'), ('abb2sd'), ('ccec3'), ('dddasdf4');

select max(name) from us;


INSERT INTO Books2
 
VALUES
 
(6, 'regf', 'Cat6', 5000),
(7, 'sdf', 'Cat7', 8000),
(8, 'gf', 'Cat8', 5000),
(9, 'cvb', 'Cat9', 5400),
(10, 'tr', 'Cat10', 3200),
(11, 'dfg', 'Cat11', 5000),
(12, 'hnbgt', 'Cat12', 8000),
(13, 'Book13', 'Cat13', 5000),
(14, 'Book14', 'Cat14', 5400),
(15, 'Book15', 'Cat15', 3200);

SELECT id, name, category, price FROM Books1
where not EXISTS (SELECT id, name, category, price FROM Books2);


select count(books1.id) from books1;

update books1 set price = null where id = 3;

alter table books1 alter column price drop not null;


-- i have "postgres" database, and i have users, friends, messages tables, so i want to dump my database but i want to set date limit for my messages table, like this dump betveen two date. 21.10.2023 21.12.2023 

CREATE TABLE cashiers_p_2019_05 PARTITION OF cashiers FOR VALUES FROM ('2019-05-01') TO ('2019-06-01');


CREATE TABLE cashiers_y2019m05 PARTITION OF cashiers
    FOR VALUES FROM ('2019-05-01') TO ('2019-06-01');

CREATE TABLE measurement (
    city_id         int not null,
    logdate         date not null,
    peaktemp        int,
    unitsales       int )
DISTRIBUTED BY (city_id)
PARTITION BY RANGE (logdate);






CREATE TABLE conductors (
    id serial primary key not null,
    username character varying DEFAULT ''::character varying NOT NULL,
    name character varying,
    surname character varying,
    password_digest character varying DEFAULT ''::character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


CREATE TABLE conductors_partitioned (
    id serial primary key not null,
    username character varying DEFAULT ''::character varying NOT NULL,
    name character varying,
    surname character varying,
    password_digest character varying DEFAULT ''::character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
) PARTITION BY RANGE (id);


INSERT INTO conductors_partitioned (id, username, name, surname, password_digest, created_at, updated_at)
SELECT id, username, name, surname, password_digest, created_at, updated_at
FROM conductors;

CREATE TABLE conductors_2024_q1 PARTITION OF conductors_partitioned
FOR VALUES FROM ('2024-01-01') TO ('2024-04-01');

CREATE TABLE conductors_2024_q2 PARTITION OF conductors_partitioned
FOR VALUES FROM ('2024-04-01') TO ('2024-07-01');

CREATE TABLE conductors_2024_q3 PARTITION OF conductors_partitioned
FOR VALUES FROM ('2024-07-01') TO ('2024-10-01');

CREATE TABLE conductors_2024_q4 PARTITION OF conductors_partitioned
FOR VALUES FROM ('2024-10-01') TO ('2025-01-01');

DROP TABLE measurement;
ALTER TABLE measurement_partitioned RENAME TO measurement;




SELECT
    MAX(c.username) as cashier,
    MAX(b.booking_number) as booking_number,
    MAX(CONCAT(p.passenger_name, ' ', p.passenger_surname)) as passenger_fullname,
    MAX(p.passenger_identity_number) as identity_number,
    MAX(tr.number) as train,
    TO_CHAR(MAX(p.journey_departure_time), 'YYYY-MM-DD HH24:MI') as "date",
    MAX(tw.wagon_number) as wagon,
    MAX(wt.display_name) as wagon_type,
    MAX(s.label) as seat,
    TO_CHAR(MAX(br.created_at), 'YYYY-MM-DD HH24:MI') as refund_time,
    COALESCE(MAX(pf.amount) FILTER (WHERE pf.formation_type_id = 1), 0) as ticket_price,
    COALESCE(MAX(pf.amount) FILTER (WHERE pf.formation_type_id = 5), 0) as bedding,
    COALESCE(MAX(pf.amount) FILTER (WHERE pf.formation_type_id = 7), 0) as sanitary,
    COALESCE(MAX(pf.amount) FILTER (WHERE pf.formation_type_id = 2), 0) as insurance,
    COALESCE(MAX(pf.amount) FILTER (WHERE pf.formation_type_id = 10), 0) as media,
    CASE
        WHEN MAX((br.created_at - p.journey_departure_time)) > INTERVAL '24 hours' THEN (SELECT MAX(pf.amount) FROM public.price_formations pf WHERE pf.pnr_id = p.id AND pf.formation_type_id = 1)
        WHEN MAX((br.created_at - p.journey_departure_time)) > INTERVAL '6 hours' THEN (SELECT MAX(pf.amount) FROM public.price_formations pf WHERE pf.pnr_id = p.id AND pf.formation_type_id = 1) - ((SELECT MAX(pf.amount) FROM public.price_formations pf WHERE pf.pnr_id = p.id AND pf.formation_type_id = 1) * 0.1)
        ELSE (SELECT MAX(pf.amount) FROM public.price_formations pf WHERE pf.pnr_id = p.id AND pf.formation_type_id = 1) - ((SELECT MAX(pf.amount) FROM public.price_formations pf WHERE pf.pnr_id = p.id AND pf.formation_type_id = 1) * 0.25)
    END as yol_nyrhdan,
    0 as vip,
    COALESCE(MAX(CASE WHEN br.created_at < '2023-06-01' THEN 5 ELSE 10 END), 0) AS return_fee,
    COALESCE(MAX(br.amount), 0) as amount
FROM
    public.pnrs p
    INNER JOIN public.bookings b ON b.id = p.booking_id
    INNER JOIN public.price_formations pf ON pf.pnr_id = p.id
    INNER JOIN public.train_runs tr ON tr.id = p.train_run_id
    INNER JOIN public.booking_refunds br ON br.pnr_id = p.id
    INNER JOIN public.cashiers c ON c.id = br.cashier_id
    INNER JOIN public.train_wagons tw ON tw.train_run_id = tr.id
    INNER JOIN public.wagon_types wt ON wt.id = p.wagon_type_id
    INNER JOIN public.seats s ON s.id = p.seat_id
    INNER JOIN public.stations st1 ON st1.id = p.source_id
    INNER JOIN public.stations st2 ON st2.id = p.destination_id
WHERE
    c.id = 6
    AND p.status = 3
GROUP BY
    p.id;







    SELECT
    MAX(c.username) as cashier,
    MAX(b.booking_number) as booking_number,
    MAX(CONCAT(p.passenger_name, ' ', p.passenger_surname)) as passenger_fullname,
    MAX(p.passenger_identity_number) as identity_number,
    MAX(tr.number) as train,
    TO_CHAR(MAX(p.journey_departure_time), 'YYYY-MM-DD HH24:MI') as "date",
    MAX(tw.wagon_number) as wagon,
    MAX(wt.display_name) as wagon_type,
    MAX(s.label) as seat,
    TO_CHAR(MAX(br.created_at), 'YYYY-MM-DD HH24:MI') as refund_time,
    COALESCE(MAX(pf.amount) FILTER (WHERE pf.formation_type_id = 1), 0) as ticket_price,
    COALESCE(MAX(pf.amount) FILTER (WHERE pf.formation_type_id = 5), 0) as bedding,
    COALESCE(MAX(pf.amount) FILTER (WHERE pf.formation_type_id = 7), 0) as sanitary,
    COALESCE(MAX(pf.amount) FILTER (WHERE pf.formation_type_id = 2), 0) as insurance,
    COALESCE(MAX(pf.amount) FILTER (WHERE pf.formation_type_id = 10), 0) as media,
    CASE
        WHEN MAX((br.created_at - p.journey_departure_time)) > INTERVAL '24 hours' THEN (SELECT MAX(pf.amount) FROM public.price_formations pf WHERE pf.pnr_id = p.id AND pf.formation_type_id = 1)
        WHEN MAX((br.created_at - p.journey_departure_time)) > INTERVAL '6 hours' THEN (SELECT MAX(pf.amount) FROM public.price_formations pf WHERE pf.pnr_id = p.id AND pf.formation_type_id = 1) - ((SELECT MAX(pf.amount) FROM public.price_formations pf WHERE pf.pnr_id = p.id AND pf.formation_type_id = 1) * 0.1)
        ELSE (SELECT MAX(pf.amount) FROM public.price_formations pf WHERE pf.pnr_id = p.id AND pf.formation_type_id = 1) - ((SELECT MAX(pf.amount) FROM public.price_formations pf WHERE pf.pnr_id = p.id AND pf.formation_type_id = 1) * 0.25)
    END as yol_nyrhdan,
    0 as vip,
    COALESCE(MAX(CASE WHEN br.created_at < '2023-06-01' THEN 5 ELSE 10 END), 0) AS return_fee,
    COALESCE(MAX(br.amount), 0) as amount
FROM
    public.pnrs p
    LEFT JOIN public.bookings b ON b.id = p.booking_id
    LEFT JOIN public.price_formations pf ON pf.pnr_id = p.id
    LEFT JOIN public.booking_payments bp ON bp.booking_id = b.id
    LEFT JOIN public.train_runs tr ON tr.id = p.train_run_id
    LEFT JOIN public.booking_refunds br ON br.pnr_id = p.id
    LEFT JOIN public.cashiers c ON c.id = br.cashier_id
    LEFT JOIN public.train_wagons tw ON tw.train_run_id = tr.id
    LEFT JOIN public.wagon_types wt ON wt.id = p.wagon_type_id
    LEFT JOIN public.seats s ON s.id = p.seat_id
    LEFT JOIN public.stations st1 ON st1.id = p.source_id
    LEFT JOIN public.stations st2 ON st2.id = p.destination_id
WHERE
    bp.coupon_id IN (4, 7)
    AND p.status = 3
GROUP BY
    p.id
ORDER BY 
    p.id;


EXPLAIN ANALYZE
SELECT 
s1.title_tm as source,
s2.title_tm as destination,
tr.departure_time as departure,
tr.arrival_time as arrival,
tr.number as train_number,
COUNT(DISTINCT p.id) as one_time_bedding_count
FROM price_formations pf
INNER JOIN pnrs p ON p.id = pf.pnr_id AND pf.formation_type_id = 3
INNER JOIN train_runs tr ON tr.id = p.train_run_id
INNER JOIN routes r ON r.id = tr.route_id
INNER JOIN stations s1 ON s1.id = r.source_id
INNER JOIN stations s2 ON s2.id = r.destination_id
WHERE tr.departure_time > '2023-01-01' AND tr.arrival_time < '2023-03-01'
GROUP BY tr.id, s1.title_tm, s2.title_tm;

--  Planning Time: 2.105 ms
--  Execution Time: 578.217 ms


EXPLAIN ANALYZE
with pf as (
    select 
        pnr_id 
    from price_formations_partitioned 
    where formation_type_id = 3
)
 SELECT 
    s1.title_tm AS source,
    s2.title_tm AS destination,
    tr.departure_time AS departure,
    tr.arrival_time AS arrival,
    tr.number AS train_number,
    COUNT(DISTINCT p.id) AS one_time_bedding_count
FROM pf
    INNER JOIN pnrs_partitioned p ON p.id = pf.pnr_id
    INNER JOIN train_runs tr ON tr.id = p.train_run_id
    INNER JOIN routes r ON r.id = tr.route_id
    INNER JOIN stations s1 ON s1.id = r.source_id
    INNER JOIN stations s2 ON s2.id = r.destination_id
WHERE 
    tr.departure_time > '2023-01-01' 
    AND tr.arrival_time < '2023-06-01' 
GROUP BY 
    tr.id, s1.title_tm, s2.title_tm;



EXPLAIN ANALYZE
select 
    s1.title_tm AS source,
    s2.title_tm AS destination,
    tr.departure_time AS departure,
    tr.arrival_time AS arrival,
    tr.number AS train_number,
    COUNT(DISTINCT p.id) AS one_time_bedding_count
from (select train_run_id from pnrs_partitioned where id  in (select pnr_id from price_formations_partitioned where formation_type_id = 3)) as p
    INNER JOIN routes r ON r.id = tr.route_id
    INNER JOIN stations s1 ON s1.id = r.source_id
    INNER JOIN stations s2 ON s2.id = r.destination_id
WHERE 
    tr.departure_time > '2023-01-01' 
    AND tr.arrival_time < '2023-06-01' 
GROUP BY 
    tr.id, s1.title_tm, s2.title_tm;

SELECT
    COUNT(p.id)
from select *price_formations_partitioned pf
    LEFT JOIN 


drop index pnrs_partitioned_train_run_id_indx;
drop index price_formations_partitioned_pnr_id_indx;
CREATE INDEX sdf32_indx ON routes ("source_id");
CREATE INDEX e43erdd_indx ON routes ("destination_id");

-- //////////////////////////////////////////////////////////////////////////////////////////////////
explain analyze
SELECT
    MAX(c.username) as cashier,
    MAX(b.booking_number) as booking_number,
    MAX(CONCAT(p.passenger_name, ' ', p.passenger_surname)) as passenger_fullname,
    MAX(p.passenger_identity_number) as identity_number,
    MAX(tr.number) as train,
    TO_CHAR(MAX(p.journey_departure_time), 'YYYY-MM-DD HH24:MI') as "date",
    MAX(tw.wagon_number) as wagon,
    MAX(wt.display_name) as wagon_type,
    MAX(s.label) as seat,
    TO_CHAR(MAX(br.created_at), 'YYYY-MM-DD HH24:MI') as refund_time,
    COALESCE(MAX(pf.amount) FILTER (WHERE pf.formation_type_id = 1), 0) as ticket_price,
    COALESCE(MAX(pf.amount) FILTER (WHERE pf.formation_type_id = 5), 0) as bedding,
    COALESCE(MAX(pf.amount) FILTER (WHERE pf.formation_type_id = 7), 0) as sanitary,
    COALESCE(MAX(pf.amount) FILTER (WHERE pf.formation_type_id = 2), 0) as insurance,
    COALESCE(MAX(pf.amount) FILTER (WHERE pf.formation_type_id = 10), 0) as media,
    CASE
        WHEN MAX((br.created_at - p.journey_departure_time)) > INTERVAL '24 hours' THEN (SELECT MAX(pf.amount) FROM price_formations pf WHERE pf.pnr_id = p.id AND pf.formation_type_id = 1)
        WHEN MAX((br.created_at - p.journey_departure_time)) > INTERVAL '6 hours' THEN (SELECT MAX(pf.amount) FROM price_formations pf WHERE pf.pnr_id = p.id AND pf.formation_type_id = 1) - ((SELECT MAX(pf.amount) FROM price_formations pf WHERE pf.pnr_id = p.id AND pf.formation_type_id = 1) * 0.1)
        ELSE (SELECT MAX(pf.amount) FROM price_formations pf WHERE pf.pnr_id = p.id AND pf.formation_type_id = 1) - ((SELECT MAX(pf.amount) FROM price_formations pf WHERE pf.pnr_id = p.id AND pf.formation_type_id = 1) * 0.25)
    END as yol_nyrhdan,
    0 as vip,
    COALESCE(MAX(CASE WHEN br.created_at < '2023-06-01' THEN 5 ELSE 10 END), 0) AS return_fee,
    COALESCE(MAX(br.amount), 0) as amount
FROM
    pnrs p
    INNER JOIN bookings b ON b.id = p.booking_id
    INNER JOIN price_formations pf ON pf.pnr_id = p.id
    INNER JOIN train_runs tr ON tr.id = p.train_run_id
    INNER JOIN booking_refunds br ON br.pnr_id = p.id
    INNER JOIN cashiers c ON c.id = br.cashier_id
    INNER JOIN train_wagons tw ON tw.train_run_id = tr.id
    INNER JOIN wagon_types wt ON wt.id = p.wagon_type_id
    INNER JOIN seats s ON s.id = p.seat_id
    INNER JOIN stations st1 ON st1.id = p.source_id
    INNER JOIN stations st2 ON st2.id = p.destination_id
WHERE
    c.id = 6
    AND p.status = 3
    AND br.created_at > '2023-01-01'
    AND br.created_at < '2023-07-01'
GROUP BY
    p.id
    limit 1000;

-- /////////

explain analyze
with p as (
    SELECT 
        p.id, 
        json_agg(
            json_build_object(
                CASE pf.formation_type_id
                    WHEN 1 THEN 'ticket_price'
                    WHEN 2 THEN 'insurance'
                    WHEN 5 THEN 'bedding'
                    WHEN 7 THEN 'sanitary'
                    WHEN 10 THEN 'media'
                END, 
                pf.amount
            )
        ) as amounts, 
        p.passenger_name || ' ' || p.passenger_surname as passenger_fullname,
        p.passenger_identity_number as identity_number,
        p.journey_departure_time,
        p.train_run_id,
        p.wagon_type_id,
        p.seat_id,
        p.booking_id
    FROM 
        pnrs p
    inner JOIN price_formations pf ON pf.pnr_id = p.id and pf.formation_type_id IN (1, 2, 5, 7, 10)
    GROUP BY p.id
)
    select 
        c.username,
        b.booking_number,
        tr.number as train,
        p.journey_departure_time as date,
        p.passenger_fullname,
        p.identity_number,
        p.amounts,
        wt.display_name as wagon_type,
        s.label as seat,
        br.created_at as refund_time,
        br.amount,
        0 as vip,
        tw.wagon_number as wagon,
        CASE
            WHEN br.created_at < '2023-06-01' 
            THEN 5 
            ELSE 10 
        END as return_fee,
        case 
            when br.created_at - p.journey_departure_time > interval '24 hours' then (json_array_elements(p.amounts) ->> 'ticket_price')::numeric 
            when br.created_at - p.journey_departure_time > interval '6 hours' then ((json_array_elements(p.amounts) ->> 'ticket_price')::numeric - (json_array_elements(p.amounts) ->> 'ticket_price')::numeric * 0.1)
            when br.created_at - p.journey_departure_time <= interval '6 hours' then ((json_array_elements(p.amounts) ->> 'ticket_price')::numeric - (json_array_elements(p.amounts) ->> 'ticket_price')::numeric * 0.25)
        end as yol_nyrhdan
    from booking_refunds br
    left join cashiers c on c.id = br.cashier_id
    left join p on p.id = br.pnr_id
    left join bookings b ON b.id = p.booking_id
    left JOIN train_runs tr ON tr.id = p.train_run_id
    left join train_wagons tw ON tw.train_run_id = tr.id
    left join wagon_types wt ON wt.id = p.wagon_type_id
    left join seats s on s.id = p.seat_id
    where 
        br.created_at > '2023-01-01' 
        and 
        br.created_at < '2023-07-01'
    limit 2;


(END)...skipping...
    cashier     | booking_number | passenger_fullname | identity_number | train |       date       | wagon | wagon_type | seat |   refund_time    | ticket_price |  bedding   |  sanitary  | insurance  |   media    |  yol_nyrhdan  | vip | return_fee |   amount    
----------------+----------------+--------------------+-----------------+-------+------------------+-------+------------+------+------------------+--------------+------------+------------+------------+------------+---------------+-----+------------+-------------
 super-disabled | 37GNFZ         | Yenis Owezgeldiyew | I-DZ 967650     | 93    | 2023-01-01 19:00 |    18 | Plaskart   | 30   | 2023-01-01 15:20 |  23.10000000 | 5.00000000 | 3.00000000 | 0.25000000 | 5.00000000 | 17.3250000000 |   0 |          5 | 25.57000000


CREATE OR REPLACE FUNCTION calculate_yol_nyrhdan(
    amounts json,
    created_at timestamp,
    journey_departure_time timestamp
) 
RETURNS numeric AS $$
DECLARE
    ticket_price numeric;
    refund_amount numeric;
BEGIN
    -- Extract the ticket_price from the JSON array
    SELECT (json_array_elements(amounts) ->> 'ticket_price')::numeric INTO ticket_price;

    -- Perform the calculation based on the time difference
    IF created_at - journey_departure_time > interval '24 hours' THEN
        refund_amount := ticket_price;
    ELSIF created_at - journey_departure_time > interval '6 hours' THEN
        refund_amount := ticket_price - ticket_price * 0.1;
    ELSE
        refund_amount := ticket_price - ticket_price * 0.25;
    END IF;

    -- Return the calculated amount
    RETURN refund_amount;
END;
$$ LANGUAGE plpgsql;



EXPLAIN ANALYZE
    WITH p AS (
        SELECT 
            p.id, 
            json_agg(
                json_build_object(
                    CASE pf.formation_type_id
                        WHEN 1 THEN 'ticket_price'
                        WHEN 2 THEN 'insurance'
                        WHEN 5 THEN 'bedding'
                        WHEN 7 THEN 'sanitary'
                        WHEN 10 THEN 'media'
                    END, 
                    pf.amount
                )
            ) AS amounts, 
            p.passenger_name || ' ' || p.passenger_surname AS passenger_fullname,
            p.passenger_identity_number AS identity_number,
            p.journey_departure_time,
            p.train_run_id,
            p.wagon_type_id,
            p.seat_id,
            p.booking_id,
            p.train_wagon_id
        FROM 
            pnrs p
        INNER JOIN price_formations pf ON pf.pnr_id = p.id AND pf.formation_type_id IN (1, 2, 5, 7, 10)
        GROUP BY p.id
    )
    SELECT 
        c.username,
        b.booking_number,
        tr.number AS train,
        p.journey_departure_time AS date,
        p.passenger_fullname,
        p.identity_number,
        p.amounts,
        wt.display_name AS wagon_type,
        s.label AS seat,
        br.created_at AS refund_time,
        br.amount,
        0 AS vip,
        tw.wagon_number AS wagon,
        calculate_yol_nyrhdan(p.amounts, br.created_at, p.journey_departure_time) AS yol_nyrhdan
    FROM 
        booking_refunds br
    LEFT JOIN 
        cashiers c ON c.id = br.cashier_id
    LEFT JOIN 
        p ON p.id = br.pnr_id
    LEFT JOIN 
        bookings b ON b.id = p.booking_id
    LEFT JOIN 
        train_runs tr ON tr.id = p.train_run_id
    LEFT JOIN 
        train_wagons tw ON tw.id = p.train_wagon_id
    LEFT JOIN 
        wagon_types wt ON wt.id = p.wagon_type_id
    LEFT JOIN 
        seats s ON s.id = p.seat_id
    WHERE 
        br.created_at > '2023-01-01' 
        AND 
        br.created_at < '2023-07-01'
    LIMIT 1000;




select 
    tr.id,
    tw.wagon_number AS wagon
from train_runs tr
left join train_wagons tw on tr.id = tw.train_run_id
limit 5;



select train_run_id, count(id) from train_wagons group by train_run_id;



WITH p AS (
    SELECT 
        p.id, 
        json_agg(
            json_build_object(
                CASE pf.formation_type_id
                    WHEN 1 THEN 'ticket_price'
                    WHEN 2 THEN 'insurance'
                    WHEN 5 THEN 'bedding'
                    WHEN 7 THEN 'sanitary'
                    WHEN 10 THEN 'media'
                END, 
                pf.amount
            )
        ) AS amounts, 
        p.passenger_name || ' ' || p.passenger_surname AS passenger_fullname,
        p.passenger_identity_number AS identity_number,
        p.journey_departure_time,
        p.train_run_id,
        p.wagon_type_id,
        p.seat_id,
        p.booking_id
    FROM 
        pnrs p
    INNER JOIN price_formations pf ON pf.pnr_id = p.id AND pf.formation_type_id IN (1, 2, 5, 7, 10)
    GROUP BY p.id
    LIMIT 10
)
SELECT *
FROM (
    SELECT 
        id,
        (json_array_elements(amounts) ->> 'ticket_price')::numeric - 
        (json_array_elements(amounts) ->> 'ticket_price')::numeric * 0.25 AS k
    FROM p
) AS subquery
WHERE k IS NOT NULL;





SELECT 
    p.id, json_agg(
        json_build_object(
            
        )
    )
from pnrs p
left join price price_formations pf on pf.pnr_id = p.id
group by p.id;


select
    p.id, 
    pf.formation_type_id,
    pf.amount
from pnrs p
left join price_formations pf on pf.pnr_id = p.id
limit 30;

    id    | formation_type_id |   amount    
----------+-------------------+-------------
 17177163 |                 1 | 14.70000000
 17177163 |                 3 | 12.00000000
 17177163 |                 2 |  0.25000000
 17177163 |                 5 |  5.00000000
 17177163 |                 7 |  3.00000000
 17177163 |                10 |  5.00000000
 17177163 |                 9 |  6.00000000
 11193209 |                 1 | 14.70000000
 11193209 |                 2 |  0.25000000
 11193209 |                 3 |  3.00000000
 11193209 |                 5 |  5.00000000
 11193209 |                 7 |  3.00000000


{
    17177163:[
        {
            "reno": 14.70000000
        },
        {
            "kila": 12.00000000
        },
        {
            "Deron": 0.25000000
        },
        {
            "landa": 5.00000000
        },
        {
            "poneer": 3.00000000
        },
        {
            "Luna": 5.00000000
        },
        {
            "opinnion": 6.00000000
        }
    ],
    11193209:[
        {
            "reno": 14.70000000
        },
        {
            "Deron": 0.25000000
        },
        {
            "kila": 3.00000000
        },
        {
            "landa": 5.00000000
        },
        {
            "poneer": 3.00000000
        }
    ]
}

select

    p.passenger_name, 
    p.passenger_surname, 
    p.journey_departure_time as date, 
    p.passenger_identity_number,
    b.booking_number

from pnrs p
    INNER JOIN bookings b on b.id = p.booking_id
    INNER JOIN price_formations pf on pf.pnr_id = p.id
    INNER JOIN 




CREATE OR REPLACE FUNCTION get_train_bedding_counts()
RETURNS TABLE (
    source TEXT,
    destination TEXT,
    departure TIMESTAMP,
    arrival TIMESTAMP,
    train_number TEXT,
    one_time_bedding_count INTEGER
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        s1.title_tm::TEXT as source,
        s2.title_tm::TEXT as destination,
        tr.departure_time as departure,
        tr.arrival_time as arrival,
        tr.number::TEXT as train_number,
        COUNT(DISTINCT p.id)::INTEGER as one_time_bedding_count
    FROM price_formations pf
    INNER JOIN pnrs p ON p.id = pf.pnr_id AND pf.formation_type_id = 3
    INNER JOIN train_runs tr ON tr.id = p.train_run_id
    INNER JOIN routes r ON r.id = tr.route_id
    INNER JOIN stations s1 ON s1.id = r.source_id
    INNER JOIN stations s2 ON s2.id = r.destination_id
    WHERE tr.departure_time >= '2023-01-01' AND tr.arrival_time <= '2023-03-01'
    GROUP BY tr.id, s1.title_tm, s2.title_tm;
END;
$$ LANGUAGE plpgsql;


tr
routes
pnrs
pf



EXPLAIN Analyze
    select 
        s1.title_tm as source,
        s2.title_tm as destination,
        tr.departure_time as departure,
        tr.arrival_time as arrival,
        tr.number as train_number,
        COUNT(DISTINCT p.id) as one_time_bedding_count
    from train_runs tr
        INNER JOIN routes r ON r.id = tr.route_id
        INNER JOIN stations s1 ON s1.id = r.source_id
        INNER JOIN stations s2 ON s2.id = r.destination_id
        INNER JOIN pnrs p ON p.train_run_id = tr.id
        INNER JOIN price_formations pf ON pf.pnr_id = p.id AND pf.formation_type_id = 3
    where p.journey_departure_time >= '2023-01-01' AND p.journey_arrival_time <= '2023-03-01'
    GROUP BY tr.id, s1.title_tm, s2.title_tm;
--  Planning Time: 2.497 ms
--  Execution Time: 2690.069 ms

EXPLAIN Analyze
    select 
        s1.title_tm as source,
        s2.title_tm as destination,
        tr.departure_time as departure,
        tr.arrival_time as arrival,
        tr.number as train_number,
        COUNT(DISTINCT p.id) as one_time_bedding_count
    from train_runs tr
        INNER JOIN routes r ON r.id = tr.route_id
        INNER JOIN stations s1 ON s1.id = r.source_id
        INNER JOIN stations s2 ON s2.id = r.destination_id
        INNER JOIN pnrs_partitioned p ON p.train_run_id = tr.id
        INNER JOIN price_formations pf ON pf.pnr_id = p.id AND pf.formation_type_id = 3
    where p.journey_departure_time >= '2023-01-01' AND p.journey_arrival_time <= '2023-03-01'
    GROUP BY tr.id, s1.title_tm, s2.title_tm;
--  Planning Time: 3.144 ms
--  Execution Time: 1169.011 ms


with rjs as (
    select routes.id,
        json_build_object(
            'source', s1.title_tm,
            'destination', s2.title_tm
        ) stations
    from routes
    left join stations s1 on s1.id = source_id
    left join stations s2 on s2.id = destination_id
    GROUP BY routes.id, s1.title_tm, s2.title_tm
), tjs as (
    select 
        t.id, t.departure_time, t.arrival_time, stations
    from train_runs t
    left join rjs on rjs.id = t.route_id
    where t.departure_time >= '2023-01-01' AND t.arrival_time <= '2023-03-01'
)
    SELECT 
        t.departure_time, t.arrival_time, t.stations,
        COUNT(p.id)
    from tjs t 
    inner join pnrs p on p.train_run_id = t.id 
    inner join price_formations pf on pf.pnr_id = p.id and pf.formation_type_id = 3; 
    GROUP by p.id;
    
select 
from price_formations pf
left join pnrs p on p.id = pf.pnr_id
where pf.formation_type_id = 3



select p.id, p.journey_arrival_time, p.journey_departure_time, tr.arrival_time, tr.departure_time
from pnrs p 
left join train_runs tr on tr.id = p.train_run_id;




select 
    p.journey_departure_time departure, 
    p.journey_arrival_time arrival,
    s1.title_tm source, 
    s2.title_tm destination,
    seats.label seat_mumber,
    tw.wagon_number
from pnrs p 
    inner join price_formations pf on p.id = pf.pnr_id and pf.formation_type_id = 3
    left join train_wagons tw on p.train_wagon_id = tw.id
    left join stations s1 on p.source_id = s1.id
    left join stations s2 on p.destination_id = s2.id
    left join seats on p.seat_id = seats.id
where p.train_run_id = 12223;


select 
    json_agg(some.*) routes
from (
    select 
        s1.title_tm source, 
        s2.title_tm destination,
        tw.wagon_number,
        seats.label seat_mumber
    from pnrs p
        left join train_wagons tw on p.train_wagon_id = tw.id
        left join stations s1 on p.source_id = s1.id
        left join stations s2 on p.destination_id = s2.id
        left join seats on p.seat_id = seats.id
    where p.train_run_id = 12223
    
)
    p.journey_departure_time departure, 
    p.journey_arrival_time arrival,
from pnrs p 
    inner join price_formations pf on p.id = pf.pnr_id and pf.formation_type_id = 3
group by s.title_tm, s2.title_tm




select 
    s1.title_tm source, 
    s2.title_tm destination,
    tw.wagon_number,
    seats.label seat_mumber
from pnrs p
    left join train_wagons tw on p.train_wagon_id = tw.id
    left join stations s1 on p.source_id = s1.id
    left join stations s2 on p.destination_id = s2.id
    left join seats on p.seat_id = seats.id
where p.train_run_id = 12223;


   source    | destination | wagon_number | seat_mumber 
-------------+-------------+--------------+-------------
 cit1        | h_ksij123k2 |            3 | 28
 cit1        | h_ksij123k2 |            3 | 38
 cit1        | h_ksij123k2 |            3 | 33
 city162     | city7       |            4 | 12
 city162     | city7       |            4 | 15
 cit1        | h_ksij123k2 |            4 | 20
 cit1        | h_ksij123k2 |            9 | 50
 city162     | Pelwert     |            9 | 29
 city162     | renodevow   |            9 | 49




{
    "wagons":[
        "3":[
            {
                "source": "cit1",
                "destination": "h_ksij123k2",
                "seat":28
            },
            {
                "source": "cit1",
                "destination": "h_ksij123k2",
                "seat":38
            },
            {
                "source": "cit1",
                "destination": "h_ksij123k2",
                "seat":33
            }
        ],
        "4":[
            {
                "source":"city162",
                "destination":"city7",
                "seat":12
            },
            {
                "source":"city162",
                "destination":"city7",
                "seat":15
            },
            {
                "source":"city1",
                "destination":"h_ksij123k2",
                "seat":20
            }
        ],
        "9":[
            {
                "source":"city162",
                "destination":"renodevow",
                "seat":49
            },
            {
                "source":"city162",
                "destination":"Pelwert",
                "seat":29
            },
            {
                "source":"city1",
                "destination":"h_ksij123k2",
                "seat":50
            }
        ]
    ]
}


select
    json_object_agg(
        wagon_number, 
        seats_data
    ) as "wagons"
from (
    select 
        tw.wagon_number::text ||'-'|| MAX(wt.display_name) as wagon_number, 
        json_agg(
            json_build_object(
                'source', s1.title_tm,
                'destination', s2.title_tm,
                'seat', seats.label
            )
        ) as seats_data
    from pnrs p
    inner join price_formations pf on p.id = pf.pnr_id and pf.formation_type_id = 3
    left join wagon_types wt on p.wagon_type_id = wt.id
    left join train_wagons tw on p.train_wagon_id = tw.id
    left join stations s1 on p.source_id = s1.id
    left join stations s2 on p.destination_id = s2.id
    left join seats on p.seat_id = seats.id
    where p.train_run_id = 12223
    group by tw.wagon_number
    limit 1
) as wagon_seats;




{"routes":
[
    {
        "source": "cit1",
        "destination": "h_ksij123k2",
        "wagons": [
            {
                "wagon_number": 3,
                "seats": [
                    "28",
                    "38",
                    "33"
                ]
            },
            {
                "wagon_number": 4,
                "seats": [
                    "12",
                    "15"
                ]
            },
            {
                "wagon_number": 9,
                "seats": [
                    "50",
                    "29"
                ]
            }
        ], 
    }, 
    {
        "source": "city162",
        "destination": "Pelwert",
        "wagons": [
            {
                "wagon_number": 9,
                "seats": [
                    "49"
                ]
            }
        ]
    },
    {
        "source": "city162",
        "destination": "renodevow",
        "wagons": [
            {
                "wagon_number": 9,
                "seats": [
                    "49"
                ]
            }
        ]
    }

]
}

SELECT
    jsonb_agg(route_info) routes
FROM (
    SELECT 
        jsonb_build_object(
            'source', source,
            'destination', destination,
            'wagons', jsonb_agg(wagon_info)
        ) AS route_info
    FROM (
        SELECT
            s1.title_tm AS source,
            s2.title_tm AS destination,
            jsonb_build_object(
                'wagon_number', tw.wagon_number,
                'seats', jsonb_agg(seats.label ORDER BY seats.label)
            ) AS wagon_info
        FROM pnrs p
        LEFT JOIN train_wagons tw ON p.train_wagon_id = tw.id
        LEFT JOIN stations s1 ON p.source_id = s1.id
        LEFT JOIN stations s2 ON p.destination_id = s2.id
        LEFT JOIN seats ON p.seat_id = seats.id
        WHERE p.train_run_id = 12223
        GROUP BY s1.title_tm, s2.title_tm, tw.wagon_number
    ) AS wagons
    GROUP BY source, destination
) AS routes;






select jsonb_agg(
    jsonb_build_object(
        'number', wagon_number,
        'seats', seats
    )
) as wagons
from (
    select
        tw.wagon_number,
        jsonb_agg(seats.label order by seats.label) as seats
    from pnrs p
    left join train_wagons tw on p.train_wagon_id = tw.id
    left join seats on p.seat_id = seats.id
    where p.train_run_id = 12223
    group by tw.wagon_number
) as subquery;






    select 
        tw.wagon_number,
        seats.label seat_mumber
    from pnrs p
        left join train_wagons tw on p.train_wagon_id = tw.id
        left join seats on p.seat_id = seats.id
    where p.train_run_id = 12223

 wagon_number | seat_mumber 
--------------+-------------
            3 | 28
            3 | 38
            3 | 33
            3 | 12
            3 | 15
            7 | 20
            7 | 50
            7 | 29
            7 | 49
           12 | 59
           12 | 54
           12 | 49
           12 | 13

[
    "wagons": [
        {
            "number": 3,
            "seats": [
                "28",
                "38",
                "33",
                "12",
                "15"
            ]
        },
        {
            "number": 7,
            "seats": [
                "20",
                "50",
                "29",
                "49"
            ]
        },
        {
            "number": 12,
            "seats": [
                "59",
                "54",
                "49",
                "13"
            ]
        }
    ]
]


with p as (
    select source, destination, seat_mumber
    from pnrs p 
    left join 
    where p.train_run_id = 12223
)

select 
    train_run_id, jdon_agg(some.*) wagons
from (
    select train_run_id, json_build_object(wagon_number, json_agg(
            
        )
        select s1.title_tm source, s2.title_tm destination, seat_mumber
            from 
        ) 
) some
group by train_run_id


select train_run_id, count(id) c
from pnrs
group by train_run_id 
order by c DESC;




SELECT
CONCAT(LEFT(p.passenger_name, 1), REPEAT('*', LENGTH(p.passenger_name) - 1), ' ', LEFT(p.passenger_surname, 1), REPEAT('*', LENGTH(p.passenger_surname) - 1)) as passenger_fullname,
s1.title_tm as source,
s2.title_tm as destination,
s.label as seat,
wt.name as wagon_type,
tw.wagon_number as wagon_number
FROM pnrs p
INNER JOIN train_runs tr ON tr.id = p.train_run_id
INNER JOIN price_formations pf ON pf.pnr_id = p.id and pf.formation_type_id = 10
INNER JOIN stations s1 ON s1.id = p.source_id
INNER JOIN stations s2 ON s2.id = p.destination_id
INNER JOIN seats s ON s.id = p.seat_id
INNER JOIN wagon_types wt ON wt.id = p.wagon_type_id
INNER JOIN train_wagons tw ON tw.id = p.train_wagon_id
WHERE tr.id = $1;


	select
		json_object_agg(
			wagon_number_type, 
			seats_data
		) as "wagons"
	from (
		select 
			tw.wagon_number::text ||'-'|| wt.display_name as wagon_number_type, 
			json_agg(
				json_build_object(
                    'Ýolagçy', CONCAT(
                            LEFT(p.passenger_name, 1), REPEAT('*', LENGTH(p.passenger_name) - 1), ' ', 
                            LEFT(p.passenger_surname, 1), REPEAT('*', LENGTH(p.passenger_surname) - 1)
                        ),
					'Ugraýan ýeri', s1.title_tm,
					'Barýan ýeri', s2.title_tm,
					'Ýer', seats.label
				)
			) as seats_data
		from pnrs p
		inner join price_formations pf on p.id = pf.pnr_id and pf.formation_type_id = 3
		left join wagon_types wt on p.wagon_type_id = wt.id
		left join train_wagons tw on p.train_wagon_id = tw.id
		left join stations s1 on p.source_id = s1.id
		left join stations s2 on p.destination_id = s2.id
		left join seats on p.seat_id = seats.id
		where p.train_run_id = 12223
		group by wagon_number_type
        limit 1
	);

    -- ///////////////////////////////////////

explain analyze
SELECT
    TO_CHAR(p.created_at, 'DD/MM/YYYY') as "date",
    COALESCE(SUM(pf.amount) FILTER (WHERE pf.formation_type_id = 1), 0) as ticket_price,
    COALESCE(SUM(pf.amount) FILTER (WHERE pf.formation_type_id = 5), 0) as bedding,
    COALESCE(SUM(pf.amount) FILTER (WHERE pf.formation_type_id = 13), 0) as vip_bedding,
    COALESCE(SUM(pf.amount) FILTER (WHERE pf.formation_type_id = 3), 0) as services,
    COALESCE(SUM(pf.amount) FILTER (WHERE pf.formation_type_id = 2), 0) as insurance,
    COALESCE(SUM(pf.amount) FILTER (WHERE pf.formation_type_id = 11), 0) as meal,
    COALESCE(SUM(pf.amount) FILTER (WHERE pf.formation_type_id = 10), 0) as media,
    COALESCE(SUM(pf.amount) FILTER (WHERE pf.formation_type_id = 12), 0) as tea_coffe,
    COALESCE(SUM(pf.amount) FILTER (WHERE pf.formation_type_id = 7), 0) as sanitary,
    COALESCE(SUM(pf.amount) FILTER (WHERE pf.formation_type_id = 9), 0) as late_purchase,
    COUNT(DISTINCT p.id) as pnr_count
FROM
    pnrs p
    INNER JOIN booking_payments bp ON bp.id = p.booking_payment_id
    INNER JOIN price_formations pf ON pf.pnr_id = p.id
WHERE
    bp.cashier_id IN (310, 416)
    AND p.created_at > '2023-01-01'
    AND p.created_at < '2023-01-04'
GROUP BY
    "date"
ORDER BY 
    "date";




        SELECT 
            TO_CHAR(p.created_at, 'DD/MM/YYYY') as "date",
            count(p.id),
            json_agg(
                json_build_object(
                    CASE pf.formation_type_id
                        WHEN 1 THEN 'ticket_price'
                        WHEN 2 THEN 'insurance'
                        WHEN 3 THEN 'services'
                        WHEN 5 THEN 'bedding'
                        WHEN 7 THEN 'sanitary'
                        WHEN 9 THEN 'late_purchase'
                        WHEN 10 THEN 'media'
                        WHEN 11 THEN 'meal'
                        WHEN 12 THEN 'tea_coffe'
                        WHEN 13 THEN 'vip_bedding'
                    END, 
                    sum(pf.amount)
                )
            ) AS amounts
        FROM pnrs p
        left join booking_payments bp on bp.id = p.booking_payment_id
        left JOIN price_formations pf ON pf.pnr_id = p.id
        WHERE pf.formation_type_id IN (1, 2, 3, 5, 7, 9, 10, 11, 12, 13)
            and p.created_at > '2023-01-01' and p.created_at < '2023-04-01'
        GROUP BY date limit 2;


SELECT 
    TO_CHAR(p.created_at, 'DD/MM/YYYY') AS "date",
    COUNT(p.id) AS count_pnrs,
    json_agg(
        json_build_object(
            amount_data.formation_type, 
            amount_data.total_amount
        )
    ) AS amounts
FROM pnrs p
LEFT JOIN (
    SELECT 
        pf.pnr_id,
        CASE pf.formation_type_id
            WHEN 1 THEN 'ticket_price'
            WHEN 2 THEN 'insurance'
            WHEN 3 THEN 'services'
            WHEN 5 THEN 'bedding'
            WHEN 7 THEN 'sanitary'
            WHEN 9 THEN 'late_purchase'
            WHEN 10 THEN 'media'
            WHEN 11 THEN 'meal'
            WHEN 12 THEN 'tea_coffe'
            WHEN 13 THEN 'vip_bedding'
        END AS formation_type,
        SUM(pf.amount) AS total_amount
    FROM price_formations pf
    WHERE pf.formation_type_id IN (1, 2, 3, 5, 7, 9, 10, 11, 12, 13)
    GROUP BY pf.pnr_id, pf.formation_type_id
) AS amount_data ON amount_data.pnr_id = p.id
WHERE p.created_at > '2023-01-01' AND p.created_at < '2023-04-01'
GROUP BY TO_CHAR(p.created_at, 'DD/MM/YYYY')
LIMIT 2;


explain analyze
with amounts as (
    SELECT 
        TO_CHAR(pf.created_at, 'DD/MM/YYYY') AS "date",
        CASE pf.formation_type_id
            WHEN 1 THEN 'ticket_price'
            WHEN 2 THEN 'insurance'
            WHEN 3 THEN 'services'
            WHEN 5 THEN 'bedding'
            WHEN 7 THEN 'sanitary'
            WHEN 9 THEN 'late_purchase'
            WHEN 10 THEN 'media'
            WHEN 11 THEN 'meal'
            WHEN 12 THEN 'tea_coffe'
            WHEN 13 THEN 'vip_bedding'
        END AS formation_type,
        SUM(pf.amount) AS total_amount,
        0 as vip,
        count(distinct p.id) as pnr_count
    FROM pnrs p
    INNER JOIN price_formations pf ON pf.pnr_id = p.id
    inner join booking_payments bp on bp.id = p.booking_payment_id
    WHERE pf.formation_type_id IN (1, 2, 3, 5, 7, 9, 10, 11, 12, 13)
        and bp.cashier_id IN (310, 416)
        and p.created_at > '2023-01-01' and p.created_at < '2023-02-01'
    GROUP BY date, formation_type
)
    select 
        date,
        json_agg(
            json_build_object(
                formation_type, 
                total_amount
            )
        ) AS amounts
    from amounts
    group by date;




SELECT 
    TO_CHAR(pf.created_at, 'DD/MM/YYYY') AS date,
    SUM(CASE WHEN pf.formation_type_id = 1 THEN pf.amount ELSE 0 END) AS ticket_price,
    SUM(CASE WHEN pf.formation_type_id = 5 THEN pf.amount ELSE 0 END) AS bedding,
    SUM(CASE WHEN pf.formation_type_id = 13 THEN pf.amount ELSE 0 END) AS vip_bedding,
    SUM(CASE WHEN pf.formation_type_id = 3 THEN pf.amount ELSE 0 END) AS services,
    SUM(CASE WHEN pf.formation_type_id = 2 THEN pf.amount ELSE 0 END) AS insurance,
    SUM(CASE WHEN pf.formation_type_id = 11 THEN pf.amount ELSE 0 END) AS meal,
    SUM(CASE WHEN pf.formation_type_id = 10 THEN pf.amount ELSE 0 END) AS media,
    SUM(CASE WHEN pf.formation_type_id = 12 THEN pf.amount ELSE 0 END) AS tea_coffe,
    SUM(CASE WHEN pf.formation_type_id = 7 THEN pf.amount ELSE 0 END) AS sanitary,
    SUM(CASE WHEN pf.formation_type_id = 9 THEN pf.amount ELSE 0 END) AS late_purchase,
    COUNT(DISTINCT p.id) AS pnr_count
FROM pnrs p
INNER JOIN price_formations pf ON pf.pnr_id = p.id
INNER JOIN booking_payments bp ON bp.id = p.booking_payment_id
WHERE pf.formation_type_id IN (1, 2, 3, 5, 7, 9, 10, 11, 12, 13)
  AND bp.cashier_id IN (310, 416)
  AND p.created_at > '2023-01-01' AND p.created_at < '2023-02-01'
GROUP BY TO_CHAR(pf.created_at, 'DD/MM/YYYY');




ALTER TABLE booking_payments_partitioned
DROP CONSTRAINT booking_payments_payment_type_id_fk;


-- explain analyze

explain analyze
select id from pnrs;




SELECT
cg.title AS sold_station, 
COALESCE(SUM(pf.amount), 0) AS total_price,
COALESCE(SUM(pf.amount) FILTER (WHERE pf.formation_type_id = 1), 0) AS ticket_price,
COALESCE(SUM(pf.amount) FILTER (WHERE pf.formation_type_id = 2), 0) AS insurance_price,
COALESCE(SUM(pf.amount) FILTER (WHERE pf.formation_type_id = 5), 0) AS bed_price,
COALESCE(SUM(pf.amount) FILTER (WHERE pf.formation_type_id = 13), 0) AS vip_bedding,
COALESCE(SUM(pf.amount) FILTER (WHERE pf.formation_type_id = 3), 0) AS services_price,
COALESCE(SUM(pf.amount) FILTER (WHERE pf.formation_type_id = 7), 0) AS sanitary_fee,
COALESCE(SUM(pf.amount) FILTER (WHERE pf.formation_type_id = 9), 0) AS before24h_fee,
COALESCE(SUM(pf.amount) FILTER (WHERE pf.formation_type_id = 8), 0) AS reservation_fee,
COALESCE(SUM(pf.amount) FILTER (WHERE pf.formation_type_id = 4), 0) AS return_fee,
COALESCE(SUM(pf.amount) FILTER (WHERE pf.formation_type_id = 6), 0) AS ugyor_price,
COUNT(DISTINCT p.id) AS passenger_count,
COALESCE(SUM(pf.amount) FILTER (WHERE pf.formation_type_id = 11), 0) AS food_price,
COALESCE(SUM(pf.amount) FILTER (WHERE pf.formation_type_id = 10), 0) AS media_price,
COALESCE(SUM(pf.amount) FILTER (WHERE pf.formation_type_id = 12), 0) AS tea_price 
FROM pnrs p
INNER JOIN price_formations pf ON pf.pnr_id = p.id
INNER JOIN booking_payments bp ON bp.id = p.booking_payment_id
INNER JOIN cashiers c ON c.id = bp.cashier_id
INNER JOIN cashier_groups cg ON cg.id = c.cashier_group_id
WHERE
bp.payment_type_id = 12
AND bp.cashier_id NOT IN (SELECT id FROM cashiers WHERE cashier_group_id IN (96))
GROUP BY
cg.title
ORDER BY
cg.title;




    SELECT 
        cg.title AS sold_station,
        count(DISTINCT p.id) AS passenger_count,
        get_formation_type(pf.formation_type_id) AS formation_type
    FROM pnrs p
        INNER JOIN price_formations pf ON pf.pnr_id = p.id
        inner join booking_payments bp on bp.id = p.booking_payment_id
        inner join cashiers c on c.id = bp.cashier_id
        inner join cashier_groups cg on cg.id = c.cashier_group_id
    group by sold_station, formation_type;



select 
    uuid, 
    created_at,
    request_local_id,
    request_phone,
    request_amount,
    status,
    error_code,
    result_status,
    result_ref_num,
    result_amount,
    result_state,
    client

from transactions
where result_ref_num != 0 and result_amount != 0
    order by result_ref_num
limit 10;


select count(uuid), client 
from transactions
group by client 
order by count desc;


select 
    uuid,
    request_phone,
    request_amount,
    result_ref_num,
    result_amount,
    result_state,
    request_local_id,
    result_ref_num
from transactions limit 10;


select 
    result_amount, 
    request_amount,
    client
from transactions 
where result_amount != 0 and request_amount != request_amount;



select 
    uuid, 
    request_local_id
from transactions
where result_ref_num != 0
limit 100;


select 
    count(uuid), 
    result_ref_num
from transactions
group by result_ref_num
limit 100;



select 
    request_service,
    error_code,
    error_msg,
    result_service,
    result_destination,
    is_checked,
    result_reason,
    note,
    reason
from transactions
where error_msg != '' or result_destination != '' or result_reason != '';


select count(uuid), error_msg from transactions group by error_msg;


where error_msg != '' limit 10;


select 
    username
from users;


select 
    count(uuid),
    detail
from cashes
group by detail order by count desc limit 10;


select *
from cashes
limit 10;


select 
    client,
    json_agg(
        json_build_object(
            'contact', contact,
            'amount', sum(amount)
        )
    )
from cashes
group by client
limit 10;


explain analyze
WITH ranked_data AS (
    SELECT 
        created_at, 
        client,
        ROW_NUMBER() OVER (PARTITION BY client ORDER BY created_at DESC) AS rn
    FROM transactions
    WHERE client IN ('terminal10', 'terminal11', 'terminal12') and status = 'SUCCESS'
    -- TODO if add condition on created_at, speed decreases half.
),lst as(
    SELECT 
        created_at,
        client
    FROM ranked_data
    WHERE rn <= 2
    ORDER BY client, created_at DESC
), js as (
    select 
        json_agg(
            created_at
        ) dates,
        client
    from lst
    group by client    
), sm as (    
    select 
        sum(amount) as amount,
        ch.client
    from cashes ch
        inner join js on js.client = ch.client
    where ch.created_at < (js.dates ->> 0)::timestamp and ch.created_at > (js.dates ->> 1)::timestamp
    -- TODO add condition for "is exactly transfered?"
    group by ch.client
) 
select 
    sm.amount,
    js.dates,
    js.client
from js
    inner join sm on sm.client = js.client;




select 
    created_at,
    client
from ranges
where 
    client in ('ashgabat_6', 'ashgabat_10', 'ashgabat_9', 'ashgabat_8', 'ashgabat_7', 'ashgabat_5', 'ashgabat_4', 'ashgabat_3', 'ashgabat_2', 'ashgabat_1')


 amount | count |   client    
--------+-------+-------------
     50 |    60 | ashgabat_1
      5 |    73 | ashgabat_1
      1 |    22 | ashgabat_1
    100 |     6 | ashgabat_1
     20 |    36 | ashgabat_1
     10 |    86 | ashgabat_1
      1 |     8 | ashgabat_10
     10 |    32 | ashgabat_10
    100 |    11 | ashgabat_10
     50 |    30 | ashgabat_10
      5 |     4 | ashgabat_10
     20 |    13 | ashgabat_10


client     |     value
_____________________________
ashgabat_1 |[{'amount':50, 'count':60},{'amount':5, 'count':73},{'amount':1, 'count':22},{'amount':100, 'count':6}, {'amount':20, 'count':36}, {'amount':10, 'count':86}]
ashgabat_10|[{'amount':10, 'count':32},{'amount':100, 'count':11},{'amount':50, 'count':30},{'amount':5, 'count':4}, {'amount':20, 'count':13}]



select
    count(uuid),
    status
from transactions
group by status;




select 
    *
from transactions
limit 10;




-- todo how many cash have summa each client last two date;

explain analyze
WITH ranked_data AS (
    SELECT 
        created_at, 
        client,
        ROW_NUMBER() OVER (PARTITION BY client ORDER BY created_at DESC) AS rn
    FROM ranges
    WHERE client IN ('ashgabat_6', 'ashgabat_10', 'ashgabat_9', 'ashgabat_8', 'ashgabat_7', 'ashgabat_5', 'ashgabat_4', 'ashgabat_3', 'ashgabat_2', 'ashgabat_1')
    -- TODO if add condition on created_at, speed decreases half.
),lst as(
    SELECT 
        created_at,
        client
    FROM ranked_data
    WHERE rn <= 2
    ORDER BY client, created_at DESC
), js as (
    select 
        json_agg(
            created_at
        ) dates,
        client
    from lst
    group by client    
), sm as (    
    select 
        sum(amount) as amount,
        ch.client
    from cashes ch
        inner join js on js.client = ch.client
    where ch.created_at < (js.dates ->> 0)::timestamp and ch.created_at > (js.dates ->> 1)::timestamp
    -- TODO add condition for "is exactly transfered?"
    group by ch.client
) 
select 
    sm.amount,
    js.dates,
    js.client
from js
    inner join sm on sm.client = js.client;



WITH rp AS (
    SELECT 
        created_at, 
        client,
        ROW_NUMBER() OVER (PARTITION BY client ORDER BY created_at DESC) AS rn
    FROM ranges
    -- TODO if add condition on created_at, speed decreases half.
),lst as(
    SELECT 
        created_at,
        client
    FROM rp
    WHERE rn <= 2
    ORDER BY client, created_at DESC
), js as (
    select 
        json_agg(
            created_at
        ) dates,
        client
    from lst
    group by client    
), c as (
    select 
        amount,
        count(amount),
        js.client
    from js
    inner join cashes ch on ch.client = js.client
    where ch.created_at < (js.dates ->> 0)::timestamp and ch.created_at > (js.dates ->> 1)::timestamp
    group by js.client, amount
    order by amount desc
), rd as (
    select
        json_agg(
            json_build_object(
                'valuta', amount,
                'count', count
            )
        ) as amount,
        sum(amount*count) as summa,
        client
    from c
    group by client
) 
select 
    rd.amount,
    rd.summa,
    js.dates,
    js.client
from js
    inner join rd on rd.client = js.client;
-- if have only one date?
    


select created_at, client from ranges where client = 'terminal2' order by created_at desc;

         created_at         |  client   
----------------------------+-----------
 2024-01-12 09:23:32.458229 | terminal2
 2024-01-10 14:32:27.924099 | terminal2
 2024-01-10 12:03:54.311966 | terminal2
 2024-01-09 09:56:40.757926 | terminal2
 2024-01-06 10:35:19.90146  | terminal2
 2024-01-05 09:16:59.735938 | terminal2
 2024-01-04 09:49:41.971192 | terminal2
 2024-01-03 11:18:52.568447 | terminal2
 2024-01-02 10:57:42.663284 | terminal2
 2023-12-30 10:40:43.627749 | terminal2
 2023-12-29 11:25:40.763261 | terminal2
 2023-12-28 10:09:20.424051 | terminal2
 2023-12-27 09:36:29.364586 | terminal2
 2023-12-26 09:49:50.839764 | terminal2
 2023-12-24 16:51:03.268712 | terminal2
 2023-12-22 09:50:36.501122 | terminal2
 2023-12-21 09:55:14.312022 | terminal2

 client   | date
----------+------
terminal2 | ["2024-01-12 09:23:32.458229","2024-01-10 14:32:27.924099"]
terminal2 | ["2024-01-10 14:32:27.924099","2024-01-10 12:03:54.311966"]
terminal2 | ["2024-01-10 12:03:54.311966","2024-01-09 09:56:40.757926"]
terminal2 | ["2024-01-09 09:56:40.757926","2024-01-06 10:35:19.90146"]


with js as (
    SELECT 
        client, 
        ROW_NUMBER() OVER (PARTITION BY client ORDER BY created_at DESC) AS rn,
        ARRAY[
            to_char(created_at, 'YYYY-MM-DD HH24:MI:SS.US'), 
            to_char(next_created_at, 'YYYY-MM-DD HH24:MI:SS.US')
        ] AS date
    FROM (
        SELECT 
            client,
            created_at,
            LEAD(created_at) OVER (PARTITION BY client ORDER BY created_at DESC) AS next_created_at
        FROM 
            ranges
    ) subquery
    WHERE next_created_at IS NOT NULL
    order by created_at desc
)
    select 
        js.client,
        js.rn,
        date,
        ch.created_at
    from js
    inner join cashes ch on ch.client = js.client and ch.created_at < (js.date[1])::timestamp and ch.created_at > (js.date[2])::timestamp
    order by js.date[1] desc
    limit 2;




    select 
        amount,
        count(amount),
        js.client,
        js.rn
    from js
    inner join cashes ch on ch.client = js.client and ch.created_at < (js.date[1])::timestamp and ch.created_at > (js.date[2])::timestamp
    group by js.client, js.rn, amount



)
    select
        json_agg(
            json_build_object(
                'valuta', amount,
                'count', count
            )
        ) as amount,
        sum(amount*count) as summa,
        client
    from c
    group by client
) 
select 
    rd.amount,
    rd.summa,
    js.date,
    js.client
from js
    inner join rd on rd.client = js.client
    limit 2;


  client   |                            date                             
-----------+-------------------------------------------------------------
 terminal2 | {"2024-01-12 09:23:32.458229","2024-01-10 14:32:27.924099"}
 terminal2 | {"2024-01-10 14:32:27.924099","2024-01-10 12:03:54.311966"}
 terminal2 | {"2024-01-10 12:03:54.311966","2024-01-09 09:56:40.757926"}
 terminal2 | {"2024-01-09 09:56:40.757926","2024-01-06 10:35:19.901460"}


  terminal2 | {"2023-03-31 11:17:03.434715","2023-03-30 17:03:01.803730"}




  with js as (
    SELECT 
        client, 
        ARRAY[
            to_char(created_at, 'YYYY-MM-DD HH24:MI:SS.US'), 
            to_char(next_created_at, 'YYYY-MM-DD HH24:MI:SS.US')
        ] AS date
    FROM (
        SELECT 
            client,
            created_at,
            LEAD(created_at) OVER (PARTITION BY client ORDER BY created_at DESC) AS next_created_at
        FROM 
            ranges
    ) subquery
    WHERE next_created_at IS NOT NULL
    order by created_at desc
)
select 
    ch.created_at, 
    (js.date[1])::timestamp as tmstmp1,
    (js.date[2])::timestamp as tmstmp2,
    js.client
from js
inner join cashes ch on ch.client = js.client
where ch.created_at < (js.date[1])::timestamp and ch.created_at > (js.date[2])::timestamp
limit 20;








WITH rp AS (
    SELECT 
        created_at, 
        client,
        ROW_NUMBER() OVER (PARTITION BY client ORDER BY created_at DESC) AS rn
    FROM ranges
    -- TODO if add condition on created_at, speed decreases half.
),lst as(
    SELECT 
        created_at,
        client
    FROM rp
    WHERE rn <= 2
    ORDER BY client, created_at DESC
), js as (
    select 
        json_agg(
            created_at
        ) dates,
        client
    from lst
    group by client    
), c as (
    select 
        amount,
        count(amount),
        js.client
    from js
    inner join cashes ch on ch.client = js.client
    where ch.created_at < (js.dates ->> 0)::timestamp and ch.created_at > (js.dates ->> 1)::timestamp
    group by js.client, amount
    order by amount desc
), rd as (
    select
        json_agg(
            json_build_object(
                'valuta', amount,
                'count', count
            )
        ) as amount,
        sum(amount*count) as summa,
        client
    from c
    group by client
) 
select 
    rd.amount,
    rd.summa,
    js.dates,
    js.client
from js
    inner join rd on rd.client = js.client
    order by js.dates ->>0 desc;




select 
    c.client,
    sum(amount) as summa,
    json_agg(
        r.created_at
    ) dates
from cashes c
left join ranges r on r.client = c.client and r.created_at > '2024-08-01' and r.created_at < '2024-08-31'
where c.created_at > '2024-08-01' and c.created_at < '2024-08-31'
group by c.client limit 1;

with c as (
    select
        client,
        sum(amount) as summa
    from cashes c
    where c.created_at > '2024-08-01' and c.created_at < '2024-08-31'
    group by client
)
select * from c;


select 
    client,
    sum(request_amount::int)
from transactions t
where created_at > '2024-08-01' and created_at < '2024-08-31'
group by client;


with tr as (
    select 
        client,
        sum((request_amount::int)/100.0),
        case
            when reason = '' then 'others'
            else reason
        end as reason
    from transactions t
    where created_at > '2024-08-01' and created_at < '2024-08-31' and status = 'SUCCESS'
    group by client, reason
)
select 
    client,
    sum(sum) as total_sum,
    json_agg(
        json_build_object(
            'reason', reason,
            'sum', sum
        )
    ) as transfer_reasons
from tr
group by tr.client;



select 
    json_agg(
        json_build_object(
            'id', c.id,
            'name', c.name,
            'icon', c.icon
        )
    )
from categories c
where status = true;

select 
    json_agg(
        json_build_object(
            'id', ps.id,
            'name', ps.name,
            'price', pps.price,
            -- 'category', cs.name,
            'pharmacy', phs.name,
            'bookmark', pps.id in (select ph_ps_id from bookmarks where device_id = 'test_device_id'),
            'images', ps.images
        )
    )
from pharmacy_products pps
left join products ps on pps.product_id = ps.id
left join pharmacies phs on phs.id = pps.pharmacy_id
-- left join product_categories pcs on pcs.product_id = ps.id
-- left join categories cs on cs.id = pcs.category_id
where pps.status = true;


select
    sum(request_amount)
from 



    select 
        client,
        request_amount,
        case
            when reason = '' then 'others'
            else reason
        end as reason
    from transactions t
    where created_at > '2024-08-01' and created_at < '2024-08-31' and status = 'SUCCESS'
        and reason = 'leftover' and client = 'terminal10';
        
select 
    count(client),
    client
from transactions
group by client;





    select 
        client,
        request_amount
    from transactions t
    where created_at > '2024-08-01' and created_at < '2024-08-31' and status = 'SUCCESS'
        and reason = 'leftover' and client = 'terminal10';
        


with tr as (
    select 
        'toleg' as service,
        sum(request_amount::int/100.0),
        reason
    from transactions
    where reason != '' 
        and created_at > '2024-08-01' 
        and created_at < '2024-08-31' 
        and status = 'SUCCESS' 
    group by reason
)
    select 
        json_agg(
            json_build_object(
                'reason', reason,
                'sum', sum
            )
        ) as transfer_reasons,
        sum(sum) as total_sum
    from tr
    group by tr.service;


2024-07-01


INSERT INTO books (title, author, publisher) VALUES ('The Catcher in the Rye', 'J.D. Salinger', 'Little, Brown and Company');
INSERT INTO books (title, author, publisher) VALUES ('To Kill a Mockingbird', 'Harper Lee', 'J.B. Lippincott & Co.');
INSERT INTO books (title, author, publisher) VALUES ('1984', 'George Orwell', 'Secker & Warburg');
INSERT INTO books (title, author, publisher) VALUES ('Pride and Prejudice', 'Jane Austen', 'T. Egerton');
INSERT INTO books (title, author, publisher) VALUES ('The Great Gatsby', 'F. Scott Fitzgerald', 'Charles Scribners Sons');
INSERT INTO books (title, author, publisher) VALUES ('Moby-Dick', 'Herman Melville', 'Harper & Brothers');
INSERT INTO books (title, author, publisher) VALUES ('War and Peace', 'Leo Tolstoy', 'The Russian Messenger');
INSERT INTO books (title, author, publisher) VALUES ('The Odyssey', 'Homer', 'Unknown');
INSERT INTO books (title, author, publisher) VALUES ('The Brothers Karamazov', 'Fyodor Dostoevsky', 'The Russian Messenger');
INSERT INTO books (title, author, publisher) VALUES ('Brave New World', 'Aldous Huxley', 'Chatto & Windus');
INSERT INTO books (title, author, publisher) VALUES ('Ulysses', 'James Joyce', 'Sylvia Beach');
INSERT INTO books (title, author, publisher) VALUES ('The Divine Comedy', 'Dante Alighieri', 'Unknown');
INSERT INTO books (title, author, publisher) VALUES ('Hamlet', 'William Shakespeare', 'Unknown');
INSERT INTO books (title, author, publisher) VALUES ('One Hundred Years of Solitude', 'Gabriel Garcia Marquez', 'Harper & Row');
INSERT INTO books (title, author, publisher) VALUES ('The Iliad', 'Homer', 'Unknown');
INSERT INTO books (title, author, publisher) VALUES ('Crime and Punishment', 'Fyodor Dostoevsky', 'The Russian Messenger');
INSERT INTO books (title, author, publisher) VALUES ('The Canterbury Tales', 'Geoffrey Chaucer', 'Unknown');
INSERT INTO books (title, author, publisher) VALUES ('Don Quixote', 'Miguel de Cervantes', 'Francisco de Robles');
INSERT INTO books (title, author, publisher) VALUES ('In Search of Lost Time', 'Marcel Proust', 'Grasset and Gallimard');
INSERT INTO books (title, author, publisher) VALUES ('Wuthering Heights', 'Emily Brontë', 'Thomas Cautley Newby');
INSERT INTO books (title, author, publisher) VALUES ('The Hobbit', 'J.R.R. Tolkien', 'George Allen & Unwin');
INSERT INTO books (title, author, publisher) VALUES ('Madame Bovary', 'Gustave Flaubert', 'Revue de Paris');
INSERT INTO books (title, author, publisher) VALUES ('The Count of Monte Cristo', 'Alexandre Dumas', 'Pierre-Jules Hetzel');
INSERT INTO books (title, author, publisher) VALUES ('Anna Karenina', 'Leo Tolstoy', 'The Russian Messenger');
INSERT INTO books (title, author, publisher) VALUES ('The Picture of Dorian Gray', 'Oscar Wilde', 'Lippincotts Monthly Magazine');
INSERT INTO books (title, author, publisher) VALUES ('Les Misérables', 'Victor Hugo', 'A. Lacroix, Verboeckhoven & Cie.');
INSERT INTO books (title, author, publisher) VALUES ('Jane Eyre', 'Charlotte Brontë', 'Smith, Elder & Co.');
INSERT INTO books (title, author, publisher) VALUES ('The Adventures of Huckleberry Finn', 'Mark Twain', 'Chatto & Windus / Charles L. Webster And Company');
INSERT INTO books (title, author, publisher) VALUES ('Fahrenheit 451', 'Ray Bradbury', 'Ballantine Books');
INSERT INTO books (title, author, publisher) VALUES ('The Sound and the Fury', 'William Faulkner', 'Jonathan Cape and Harrison Smith');
INSERT INTO books (title, author, publisher) VALUES ('The Grapes of Wrath', 'John Steinbeck', 'The Viking Press-James Lloyd');
INSERT INTO books (title, author, publisher) VALUES ('Great Expectations', 'Charles Dickens', 'Chapman & Hall');
INSERT INTO books (title, author, publisher) VALUES ('Lolita', 'Vladimir Nabokov', 'Olympia Press');
INSERT INTO books (title, author, publisher) VALUES ('Heart of Darkness', 'Joseph Conrad', 'Blackwoods Magazine');
INSERT INTO books (title, author, publisher) VALUES ('Catch-22', 'Joseph Heller', 'Simon & Schuster');
INSERT INTO books (title, author, publisher) VALUES ('The Stranger', 'Albert Camus', 'Gallimard');
INSERT INTO books (title, author, publisher) VALUES ('The Metamorphosis', 'Franz Kafka', 'Kurt Wolff Verlag');
INSERT INTO books (title, author, publisher) VALUES ('The Old Man and the Sea', 'Ernest Hemingway', 'Charles Scribners Sons');
INSERT INTO books (title, author, publisher) VALUES ('Beloved', 'Toni Morrison', 'Alfred A. Knopf');
INSERT INTO books (title, author, publisher) VALUES ('The Trial', 'Franz Kafka', 'Verlag Die Schmiede');
INSERT INTO books (title, author, publisher) VALUES ('Invisible Man', 'Ralph Ellison', 'Random House');
INSERT INTO books (title, author, publisher) VALUES ('Gullivers Travels', 'Jonathan Swift', 'Benjamin Motte');
INSERT INTO books (title, author, publisher) VALUES ('Mansfield Park', 'Jane Austen', 'Thomas Egerton');
INSERT INTO books (title, author, publisher) VALUES ('Slaughterhouse-Five', 'Kurt Vonnegut', 'Delacorte');
INSERT INTO books (title, author, publisher) VALUES ('Frankenstein', 'Mary Shelley', 'Lackington, Hughes, Harding, Mavor & Jones');
INSERT INTO books (title, author, publisher) VALUES ('The Scarlet Letter', 'Nathaniel Hawthorne', 'Ticknor, Reed & Fields');
INSERT INTO books (title, author, publisher) VALUES ('Dracula', 'Bram Stoker', 'Archibald Constable and Company');
INSERT INTO books (title, author, publisher) VALUES ('The Sun Also Rises', 'Ernest Hemingway', 'Charles Scribners Sons');
INSERT INTO books (title, author, publisher) VALUES ('The Bell Jar', 'Sylvia Plath', 'Heinemann');
INSERT INTO books (title, author, publisher) VALUES ('The Lord of the Rings', 'J.R.R. Tolkien', 'George Allen & Unwin');
INSERT INTO books (title, author, publisher) VALUES ('Middlemarch', 'George Eliot', 'William Blackwood and Sons');


with pnrs as (
    select * 
    from pnrs_2024_09
    
)


select id from musics
where id not in (select unnest(music_ids) from l_musics where user_id = 1);

explain analyze
select 
    music_id, rating
from ratings
where user_id != 1 and music_id not in (select unnest(music_ids) from l_musics where user_id = 1)
    and user_id in (select unnest(similar_user_ids) from l_musics where user_id = 1)
order by rating desc
limit 10;


INSERT INTO l_musics (user_id, music_ids)
VALUES ($1, ARRAY[$2]::int[])  -- Insert a new row with the user_id and music_id
ON CONFLICT (user_id)   -- If the user_id already exists, update the music_ids array
DO UPDATE
SET music_ids = CASE
    WHEN array_position(l_musics.music_ids, $2) IS NULL THEN array_append(l_musics.music_ids, $2)
    ELSE l_musics.music_ids
END;



    INSERT INTO l_musics (user_id, similar_user_ids)
        VALUES ($1, ARRAY[$2]::int[])  -- Insert a new row with the user_id and music_id
        ON CONFLICT (user_id)   -- If the user_id already exists, update the similar_user_ids array
    DO UPDATE
        SET similar_user_ids = CASE
            WHEN array_position(l_musics.similar_user_ids, $2) IS NULL THEN array_append(l_musics.similar_user_ids, $2)
            ELSE l_musics.similar_user_ids
        END;


select 
    c.id, c.name, sc.sub_categories
from categories c
left join (
    select 
        sc.category_id, 
        json_agg(
            json_build_object(
                'id', sc.id,
                'name', sc.name
            ) 
        ) as sub_categories
    from sub_categories sc
    group by category_id
) sc on sc.category_id = c.id;




SELECT 
tr.id as id,
s1.title_tm as source,
s2.title_tm as desctination,
TO_CHAR(tr.departure_time, 'YYYY-MM-DD HH24:MI') as departure,
TO_CHAR(tr.arrival_time, 'YYYY-MM-DD HH24:MI') as arrival,
tr.number as train_number,
COUNT(DISTINCT p.id) as one_time_bedding_count
FROM train_runs tr
INNER JOIN pnrs p ON p.train_run_id = tr.id 
INNER JOIN price_formations pf ON pf.pnr_id = p.id AND pf.formation_type_id = 3
INNER JOIN routes r ON r.id = tr.route_id
INNER JOIN stations s1 ON s1.id = r.source_id
INNER JOIN stations s2 ON s2.id = r.destination_id
WHERE tr.departure_time > $1 AND tr.departure_time < $2
GROUP BY tr.id, s1.title_tm, s2.title_tm
ORDER BY TO_NUMBER(tr.number, '99999999') DESC;


select 
    pps.id,
    ps.name,
    pps.price,
    ph.name pharmacy,
    true bookmark,
    ps.images
from bookmarks bs
left join pharmacy_products pps on pps.id = bs.ph_ps_id
left join products ps on ps.id = pps.product_id
left join pharmacies ph on ph.id = pps.pharmacy_id
where device_id = 'test_device_id';


select 
    json_agg(
        json_build_object(
            'id', ps.id,
            'name', ps.name,
            'price', pps.price,
            'category', cs.name,
            'pharmacy', phs.name,
            'bookmark', pps.id in (select ph_ps_id from bookmarks where device_id = 'test_device_id'),
            'images', ps.images
        )
    )
from pharmacy_products pps
left join products ps on pps.product_id = ps.id
left join pharmacies phs on phs.id = pps.pharmacy_id
left join product_categories pcs on pcs.product_id = ps.id
left join categories cs on cs.id = pcs.category_id
where pps.status = true and cs.id = 2;

