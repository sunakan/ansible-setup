create table if not exists products
(
  id                 bigint auto_increment primary key,
  name               varchar(255)          not null comment 'Name of the product',
  quantity_remaining integer               not null comment 'How many of this product are left?',
  price_cents        integer               not null comment 'Price of one product, in cents',
  created_at         timestamp(6)          not null comment 'レコード作成日時(メタデータ)',
  updated_at         timestamp(6)          not null comment 'レコード更新日時(メタデータ)'
) engine=InnoDB comment='製品';
create unique index index_products_on_name on products (name);

create table if not exists users (
  id                         bigint auto_increment primary key,
  email                      varchar(255)          not null comment 'Email address of this user',
  payments_customer_id       varchar(255)          not null comment 'ID of 顧客 in our payments service',
  payments_payment_method_id varchar(255)          not null comment 'ID of 顧客 chosen payment method in our payments service',
  created_at                 timestamp(6)          not null comment 'レコード作成日時(メタデータ)',
  updated_at                 timestamp(6)          not null comment 'レコード更新日時(メタデータ)'
) engine=innodb comment='ユーザー';
create unique index index_users_on_email on users (email);
create unique index index_users_on_payments_customer_id on users (payments_customer_id);
create unique index index_users_on_payments_payment_method_id on users (payments_payment_method_id);

create table if not exists orders
(
  id                     bigint auto_increment primary key,
  product_id             bigint                not null comment 'Which product is in this order?',
  quantity               int                   not null comment 'How many?',
  address                text                  not null comment 'What address should it be shipped to?',
  email                  text                  not null comment 'What email address should be notified?',
  created_at             timestamp(6)          not null comment 'レコード作成日時(メタデータ)',
  updated_at             timestamp(6)          not null comment 'レコード更新日時(メタデータ)',
  user_id                bigint                not null comment 'Which user placed and paid-for this order?',
  charge_completed_at    timestamp(6)                   comment 'If set, when was the charge completed?',
  charge_successful      boolean default false not null comment 'If the charge was completed, was it successful or was it declined?',
  charge_decline_reason  text                           comment 'If the charge was declined, why?',
  charge_id              text                           comment 'If this was paid for, what was the charge id from the remote system?',
  email_id               text                           comment 'If the email confirmation went out, what was the id in the remote system?',
  fulfillment_request_id text                           comment 'If the 注文 fulfillment was requested, what was the id in the remote system?'
) engine=InnoDB comment='注文';
create index index_orders_on_product_id on orders (product_id);
create index index_orders_on_user_id on orders (user_id);
alter table orders add constraint fk_orders_product_id foreign key (product_id) references products (id);
alter table orders add constraint fk_orders_user_id    foreign key (user_id)    references users (id);
