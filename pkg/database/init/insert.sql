insert into countries (name, flag) values ('Ukraine', '🇺🇦');
insert into countries (name, flag) values ('Poland', '🇵🇱');
insert into producers (name, country_id, address, description, logo) values ('Pfizer', 1, 'address1', 'description1', 'logo1');
insert into producers (name, country_id, address, description, logo) values ('AstraZeneca', 2, 'address2', 'description2', 'logo2');
insert into producers (name, country_id, address, description, logo) values ('Moderna', 1, 'address3', 'description3', 'logo3');
insert into producers (name, country_id, address, description, logo) values ('Janssen', 2, 'address4', 'description4', 'logo4');
insert into products (producer_id, name, description, images, packaging, barcode, strength, dosage_type) values (1, 'product1', 'description1', '{image1, image2}', 'packaging1', 'barcode1', 'strength1', 'dosage_type1');
insert into products (producer_id, name, description, images, packaging, barcode, strength, dosage_type) values (2, 'product2', 'description2', '{image3, image4}', 'packaging2', 'barcode2', 'strength2', 'dosage_type2');
insert into products (producer_id, name, description, images, packaging, barcode, strength, dosage_type) values (3, 'product3', 'description3', '{image5, image6}', 'packaging3', 'barcode3', 'strength3', 'dosage_type3');
insert into categories (name, icon) values ('category1', 'icon1');
insert into categories (name, icon) values ('category2', 'icon2');
insert into categories (name, icon) values ('category3', 'icon3');
insert into product_categories (product_id, category_id) values (1, 1);
insert into product_categories (product_id, category_id) values (1, 2);
insert into product_categories (product_id, category_id) values (2, 1);
insert into product_categories (product_id, category_id) values (2, 3);
insert into product_categories (product_id, category_id) values (3, 2);
insert into product_categories (product_id, category_id) values (3, 3);
insert into cities (name) values ('Dubai');
insert into cities (name) values ('Los Angels');
insert into pharmacies (name, address, images, phone, email, open_time, close_time, status) values ('pharmacy1', 'address1', '{image1, image2}', 'phone1', 'email1', 'open_time1', 'close_time1', true);
insert into pharmacies (name, address, images, phone, email, open_time, close_time, status) values ('pharmacy2', 'address2', '{image1, image2}', 'phone2', 'email2', 'open_time2', 'close_time2', true);
insert into pharmacies (name, address, images, phone, email, open_time, close_time, status) values ('pharmacy3', 'address3', '{image1, image2}', 'phone3', 'email3', 'open_time3', 'close_time3', true);
insert into pharmacies (name, address, images, phone, email, open_time, close_time, status) values ('pharmacy4', 'address4', '{image1, image2}', 'phone4', 'email4', 'open_time4', 'close_time4', true);
insert into pharmacy_products (pharmacy_id, product_id, price, expiration_date, stock_count, cupon, status) values (1, 1, 100, '2024-08-01', 10, true, true);
insert into pharmacy_products (pharmacy_id, product_id, price, expiration_date, stock_count, cupon, status) values (1, 2, 200, '2024-08-02', 20, true, true);
insert into pharmacy_products (pharmacy_id, product_id, price, expiration_date, stock_count, cupon, status) values (2, 2, 176, '2024-08-02', 20, true, true);
insert into pharmacy_products (pharmacy_id, product_id, price, expiration_date, stock_count, cupon, status) values (1, 3, 300, '2024-08-03', 30, true, true);
insert into pharmacy_products (pharmacy_id, product_id, price, expiration_date, stock_count, cupon, status) values (2, 3, 348, '2024-08-03', 30, true, true);
insert into devices (device_id) values ('test_device_id');
insert into bookmarks (ph_ps_id, device_id) values (1, 'test_device_id');
insert into bookmarks (ph_ps_id, device_id) values (2, 'test_device_id');


insert into pharmacy_managers 
    (username, name, password, phone) 
values 
    ('admin', 'Admin', '$2a$10$H.rT7fOPEYn9dOfMJpi26.daBUWGl5zKTCUx.fzZ.GYnN32ZPAaUC', '1234567890');

insert into admins 
    (username, name, password, phone) 
values 
    ('admin', 'Admin', '$2a$10$H.rT7fOPEYn9dOfMJpi26.daBUWGl5zKTCUx.fzZ.GYnN32ZPAaUC', '1234567890');

