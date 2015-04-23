create table article (
  ID_article numeric(8) not null,
  item varchar(128) not null,
  type varchar(64) not null,
  ID_supplier numeric(8) not null,
  pur_basePrice numeric(8,2) not null,
  pur_currency varchar(16) not null,
  pur_purchasedate date not null,
  sal_rentalPriceMonth numeric(8,2) not null,
  sal_rentalPriceWeek numeric(8,2) not null,
  sal_rentalPriceDay numeric(8,2) not null,
  sal_currency varchar(16) not null,
  ID_depot numeric(8),
  dep_location numeric(6) not null,
  dep_weightKg numeric(6,2) not null,
  dep_heightCm numeric(6,2) not null,
  dep_lengthCm numeric(6,2) not null,
  dep_breadthCm numeric(6,2) not null,
  constraint PK_article primary key (ID_article),
  constraint UK_article unique (ID_depot, dep_location)
);

create table customer (
  ID_customer numeric(8) not null,
  company varchar(128) not null,
  address varchar(32) not null,
  zip varchar(16) not null,
  city varchar(32) not null,
  state varchar(32) not null,
  constraint PK_customer primary key (ID_customer)
);

create table depot(
  ID_depot numeric(8) not null,
  company varchar(32) not null,
  address varchar(32) not null,
  zip varchar(16) not null,
  city varchar(32) not null,
  state varchar(32) not null,
  constraint PK_depot primary key (ID_depot)
);

create table supplier (
  ID_supplier numeric(8) not null,
  company varchar(128) not null,
  address varchar(32) not null,
  zip varchar(16) not null,
  city varchar(32) not null,
  state varchar(32) not null,
  constraint PK_supplier primary key (ID_supplier)
);

create table rent (
  ID_customer numeric(8) not null,
  ID_article numeric(8) not null,
  contract numeric(8) not null,
  rentFrom date not null,
  rentTo date not null,
  returnFlag numeric(1) not null,
  constraint PK_rent primary key (ID_article, ID_customer, contract)
);

alter table article add constraint RK_article_depot
  foreign key (ID_depot)
  references depot;
alter table article add constraint RK_article_supplier
  foreign key (ID_supplier)
  references supplier;
alter table rent add constraint RK_rent_customer
  foreign key (ID_customer)
  references customer;
alter table rent add constraint RK_rent_article
  foreign key (ID_article)
  references article;
