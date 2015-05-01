-- ***************************************************************
-- * File Name:                  london_database.sql             *
-- * File Creator:               Knolle                          *
-- * CreationDate:               12. April 2015                  *
-- *                                                             *
-- * <ChangeLogDate>             <ChangeLogText>                 *
-- ***************************************************************
--
-- ***************************************************************
-- * Verteilte Datenbanksysteme SS 2015
-- * Übung 2 
-- * Allokation
--
-- ***************************************************************
-- * SQL*plus Job Control Section
--
set 	echo 		on
set 	linesize 	256
set 	pagesize 	50
set     escape      \
spool   ./london_database.log

--
-- Systemdatum Start
--
  SELECT user,
         TO_CHAR(SYSDATE, 'dd-mm-yy hh24:mi:ss') 
  FROM   dual
  ;  
--
drop table ldn_article purge;
drop table ldn_customer purge;
drop table ldn_rent purge;

-- ***************************************************************
-- * Das lokale Schema für den Standort London
--
create table ldn_article (
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

create table ldn_customer (
  ID_customer numeric(8) not null,
  company varchar(128) not null,
  address varchar(32) not null,
  zip varchar(16) not null,
  city varchar(32) not null,
  state varchar(32) not null,
  constraint PK_customer primary key (ID_customer)
);

create table ldn_rent (
  ID_customer numeric(8) not null,
  ID_article numeric(8) not null,
  contract numeric(8) not null,
  rentFrom date not null,
  rentTo date not null,
  returnFlag numeric(1) not null,
  constraint PK_rent primary key (ID_article, ID_customer, contract)
);

alter table ldn_rent add constraint RK_ldn_rent_customer
  foreign key (ID_customer)
  references ldn_customer;

-- Inserts
-- table ldn_article
Insert into ldn_article values (25, 'Single Tool Portable Compressor, 85cfm - Diesel', 'Compressor', 3, 18000.00, 'Euro', to_date('2010-04-18', 'yyyy-mm-dd'), 450.00, 150.00, 30.00, 'Pound', 2, 12, 500.00, 120.00, 200.00, 100.00);
Insert into ldn_article values (26, 'Two Tool Portable Compressor, 150cfm - Diesel', 'Compressor', 3, 2000.00, 'Euro', to_date('2010-05-07', 'yyyy-mm-dd'), 498.00, 166.00, 34.00, 'Pound', 2, 2, 700.00, 150.00, 200.00, 110.00);
-- table ldn_customer
Insert into ldn_customer values (26, 'Brunelli Engineering Ltd', '10 Abbey Orchard Street', 'London', 'SW1P 2JP', 'United Kingdom');
Insert into ldn_customer values (27, 'Skelton Group Cooting', 'Road Canterbury', 'Kent', 'CT3 3EP', 'United Kingdom');
Insert into ldn_customer values (28, 'Renshaw Civil \& Safety Engineering', 'Saltwood', 'Hythe', 'CT21 4WN', 'United Kingdom');
Insert into ldn_customer values (29, 'Meeres Civil Engineering', '309 Ballards Lane', 'London', 'N12 8LY', 'United Kingdom');
-- table ldn_rent
Insert into ldn_rent values (26, 25, 1, to_date('2015-03-10', 'yyyy-mm-dd'), to_date('2015-03-15', 'yyyy-mm-dd'), 1);
Insert into ldn_rent values (26, 25, 2, to_date('2015-04-15', 'yyyy-mm-dd'), to_date('2015-04-20', 'yyyy-mm-dd'), 1);
Insert into ldn_rent values (27, 26, 1, to_date('2015-06-08', 'yyyy-mm-dd'), to_date('2015-10-08', 'yyyy-mm-dd'), 0);
Insert into ldn_rent values (27, 26, 2, to_date('2015-09-20', 'yyyy-mm-dd'), to_date('2015-10-19', 'yyyy-mm-dd'), 0);
Insert into ldn_rent values (28, 25, 1, to_date('2015-09-18', 'yyyy-mm-dd'), to_date('2015-09-24', 'yyyy-mm-dd'), 0);
Insert into ldn_rent values (28, 26, 1, to_date('2016-01-05', 'yyyy-mm-dd'), to_date('2016-02-04', 'yyyy-mm-dd'), 0);
Insert into ldn_rent values (29, 25, 1, to_date('2016-02-10', 'yyyy-mm-dd'), to_date('2016-02-15', 'yyyy-mm-dd'), 1);
Insert into ldn_rent values (29, 26, 1, to_date('2015-11-11', 'yyyy-mm-dd'), to_date('2015-11-17', 'yyyy-mm-dd'), 0);

--
-- Systemdatum Ende
--
  SELECT user,
         TO_CHAR(SYSDATE, 'dd-mm-yy hh24:mi:ss') 
  FROM   dual
  ;  
--
spool off