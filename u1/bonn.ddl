-- *********************************************
-- * Standard SQL generation                   
-- *--------------------------------------------
-- * DB-MAIN version: 9.2.0              
-- * Generator date: Oct 16 2014              
-- * Generation date: Sat Apr 18 21:54:02 2015 
-- * LUN file: D:\Sync\HBS\2\vdb\u1\working\distributed_database.lun 
-- * Schema: Logical_Bonn/SQL 
-- ********************************************* 


-- Database Section
-- ________________ 

create database Logical_Bonn;


-- DBSpace Section
-- _______________


-- Tables Section
-- _____________ 

create table article (
     ID_article numeric(8) not null,
     item varchar(32) not null,
     type varchar(64) not null,
     ID_supplier numeric(8) not null,
     pur_basePrice numeric(8,2) not null,
     pur_currency varchar(16) not null,
     pur_purchaseDate date not null,
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
     constraint ID_article_ID primary key (ID_article),
     constraint SID_article_ID unique (ID_depot, dep_location));

create table customer (
     ID_customer numeric(8) not null,
     company varchar(32) not null,
     address varchar(32) not null,
     zip varchar(16) not null,
     city varchar(32) not null,
     state varchar(32) default 'Bonn' not null,
     constraint ID_customer_ID primary key (ID_customer));

create table depot (
     ID_depot numeric(8) not null,
     company varchar(32) not null,
     address varchar(32) not null,
     zip varchar(16) not null,
     city varchar(32) not null,
     state varchar(32) not null,
     constraint ID_depot_ID primary key (ID_depot));

create table rent (
     ID_customer numeric(8) not null,
     ID_article numeric(8) not null,
     contract numeric(8) not null,
     rentFrom date not null,
     rentTo date not null,
     returnFlag char not null,
     constraint ID_rent_ID primary key (ID_customer, ID_article, contract));

create table supplier (
     ID_supplier numeric(8) not null,
     company varchar(32) not null,
     address varchar(32) not null,
     zip varchar(16) not null,
     city varchar(32) not null,
     state varchar(32) not null,
     constraint ID_supplier_ID primary key (ID_supplier));


-- Constraints Section
-- ___________________ 

alter table article add constraint REF_artic_depot
     foreign key (ID_depot)
     references depot;

alter table article add constraint REF_artic_suppl_FK
     foreign key (ID_supplier)
     references supplier;

alter table rent add constraint REF_rent_custo
     foreign key (ID_customer)
     references customer;

alter table rent add constraint REF_rent_artic_FK
     foreign key (ID_article)
     references article;


-- Index Section
-- _____________ 

create unique index ID_article_IND
     on article (ID_article);

create unique index SID_article_IND
     on article (ID_depot, dep_location);

create index REF_artic_suppl_IND
     on article (ID_supplier);

create unique index ID_customer_IND
     on customer (ID_customer);

create unique index ID_depot_IND
     on depot (ID_depot);

create unique index ID_rent_IND
     on rent (ID_customer, ID_article, contract);

create index REF_rent_artic_IND
     on rent (ID_article);

create unique index ID_supplier_IND
     on supplier (ID_supplier);

