TRUNCATE TABLE categories;
TRUNCATE TABLE configs;
TRUNCATE TABLE items;
TRUNCATE TABLE shippings;
TRUNCATE TABLE transaction_evidences;
TRUNCATE TABLE users;

DELETE FROM user_password WHERE user_id > 4000;

INSERT INTO categories SELECT * FROM mysql_categories;
INSERT INTO configs SELECT * FROM mysql_configs;
INSERT INTO items SELECT * FROM mysql_items;
INSERT INTO shippings SELECT * FROM mysql_shippings;
INSERT INTO transaction_evidences SELECT * FROM mysql_transaction_evidences;
INSERT INTO users SELECT * FROM mysql_users;
