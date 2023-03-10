DROP TABLE IF EXISTS configs;
create table public.configs (
  name character varying(191) primary key not null,
  val character varying(255) not null
);

DROP TABLE IF EXISTS users;
create table users
(
    id              bigint generated by default as identity
        constraint users_pk
            primary key,
    account_name    varchar(128)                           not null
        constraint users_u_index
            unique,
    hashed_password bytea                                  not null,
    address         varchar(191)                           not null,
    num_sell_items  integer   default 0                    not null,
    last_bump       timestamp default '2000-01-01 00:00:0' not null,
    created_at      timestamp default CURRENT_TIMESTAMP    not null
);

DROP TABLE IF EXISTS items;
create table items
(
    id          bigint generated by default as identity
        constraint items_pk
            primary key,
    seller_id   bigint                  not null,
    buyer_id    bigint    default 0     not null,
    status      text                    not null,
    name        text                    not null,
    price       integer                 not null,
    description text                    not null,
    image_name  text,
    category_id integer                 not null,
    created_at  timestamp default now() not null,
    updated_at  timestamp default now() not null
);

create index items__index
    on items (category_id);

DROP TABLE IF EXISTS `transaction_evidences`;
create table public.transaction_evidences (
  id bigint primary key not null,
  seller_id bigint not null,
  buyer_id bigint not null,
  status text not null,
  item_id bigint not null,
  item_name text not null,
  item_price integer not null,
  item_description text not null,
  item_category_id integer not null,
  item_root_category_id integer not null,
  created_at timestamp without time zone not null default now(),
  updated_at timestamp without time zone not null default now()
);
create unique index transaction_evidences_item_id_uindex on transaction_evidences using btree (item_id);





DROP TABLE IF EXISTS `shippings`;
create table public.shippings (
  transaction_evidence_id bigint primary key not null,
  status text not null,
  item_name text not null,
  item_id bigint not null,
  reserve_id text not null,
  reserve_time bigint not null,
  to_address text not null,
  to_name text not null,
  from_address text not null,
  from_name text not null,
  img_binary bytea not null,
  created_at timestamp without time zone not null default now(),
  updated_at timestamp without time zone not null default now()
);


DROP TABLE IF EXISTS `categories`;
create table public.categories (
  id integer primary key not null,
  parent_id integer not null,
  category_name text not null
);