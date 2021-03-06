-- ***************************************************************
-- * File Name:                  newyork_database.sql            *
-- * File Creator:               Knolle                          *
-- * CreationDate:               12. April 2015                  *
-- *                                                             *
-- * <ChangeLogDate>             <ChangeLogText>                 *
-- ***************************************************************
--
-- ***************************************************************
-- * Verteilte Datenbanksysteme SS 2015
-- * �bung 2 
-- * Allokation
--
-- ***************************************************************
-- * SQL*plus Job Control Section
--
set 	echo 		on
set 	linesize 	256
set 	pagesize 	50
set     escape      \
spool   ./newyork_database.log

--
-- Systemdatum Start
--
  SELECT user,
         TO_CHAR(SYSDATE, 'dd-mm-yy hh24:mi:ss') 
  FROM   dual
  ;  
--
drop table nyk_article purge;
drop table nyk_customer purge;
drop table nyk_rent purge;

-- ***************************************************************
-- * Das lokale Schema f�r den Standort New York
--
create table nyk_article (
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

create table nyk_customer (
  ID_customer numeric(8) not null,
  company varchar(128) not null,
  address varchar(32) not null,
  zip varchar(16) not null,
  city varchar(32) not null,
  state varchar(32) not null,
  constraint PK_customer primary key (ID_customer)
);

create table nyk_rent (
  ID_customer numeric(8) not null,
  ID_article numeric(8) not null,
  contract numeric(8) not null,
  rentFrom date not null,
  rentTo date not null,
  returnFlag numeric(1) not null,
  constraint PK_rent primary key (ID_article, ID_customer, contract)
);

alter table nyk_rent add constraint RK_nyk_rent_customer
  foreign key (ID_customer)
  references nyk_customer;

-- Inserts
-- table nyk_article
Insert into nyk_article values (31, 'Bomag Vibratory Roller - Ride-On - Smooth/Padfoot 48" Drum Width, BW124-3, 6,000 lbs', 'Vibratory Roller', 1, 20000.00, 'Euro', to_date('2010-10-23', 'yyyy-mm-dd'), 1004.00, 251.00, 104.00, 'Dollar', 3, 38, 2721.00, 120.00, 150.00, 200.00);
Insert into nyk_article values (32, 'Bomag Vibratory Roller - Ride-On - Smooth/Padfoot Asphalt Roller - 3 Ton Vibratory Bomag BW120', 'Vibratory Roller', 1, 24000.00, 'Euro', to_date('2010-04-12', 'yyyy-mm-dd'), 1200.00, 300.00, 150.00, 'Dollar', 3, 64, 3000.00, 180.00, 200.00, 250.00);
Insert into nyk_article values (33, 'Industrial - 5000 lbs Cushion Triple Mast', 'Fork Lift', 2, 16000.00, 'Euro', to_date('2010-03-01', 'yyyy-mm-dd'), 1300.00, 495.00, 165.00, 'Dollar', 3, 12, 1800.00, 250.00, 250.00, 150.00);
Insert into nyk_article values (34, 'Industrial - 8,000 lbs Cushion Triple Mast', 'Fork Lift', 2, 23000.00, 'Euro', to_date('2010-08-20', 'yyyy-mm-dd'), 2430.00, 810, 270, 'Dollar', 3, 13, 1900.00, 280.00, 250.00, 150.00);
-- table nyk_customer
Insert into nyk_customer values (310, 'Parsons Brinckerhoff', 'One Penn Plaza', 'New York', 'NY 10119', 'United States');
Insert into nyk_customer values (311, 'Gannett Fleming', '380 Seventh Avenue', 'New York', 'NY 10121-0101', 'United States');
Insert into nyk_customer values (312, 'Rhode Island Engineering', '397 Mourning Dove Drive', 'Saunderstown', 'RI', 'United States');
Insert into nyk_customer values (313, 'American Engineering Co', '400 South County Trail', 'Exeter', 'RI', 'United States');
Insert into nyk_customer values (314, 'EP and CC Consulting Inc', '24 Rosevear Avenue', 'Toronto', 'ON M4C 1Z3', 'Canada');
-- table nyk_rent
Insert into nyk_rent values (310, 31, 1, to_date('2015-03-10', 'yyyy-mm-dd'), to_date('2015-04-09', 'yyyy-mm-dd'), 1);
Insert into nyk_rent values (310, 32, 1, to_date('2015-02-10', 'yyyy-mm-dd'), to_date('2015-02-15', 'yyyy-mm-dd'), 1);
Insert into nyk_rent values (311, 33, 1, to_date('2015-07-11', 'yyyy-mm-dd'), to_date('2015-07-18', 'yyyy-mm-dd'), 0);
Insert into nyk_rent values (311, 34, 1, to_date('2015-06-22', 'yyyy-mm-dd'), to_date('2015-06-28', 'yyyy-mm-dd'), 0);
Insert into nyk_rent values (312, 31, 1, to_date('2015-05-06', 'yyyy-mm-dd'), to_date('2015-05-12', 'yyyy-mm-dd'), 0);
Insert into nyk_rent values (312, 32, 1, to_date('2015-03-22', 'yyyy-mm-dd'), to_date('2015-03-28', 'yyyy-mm-dd'), 1);
Insert into nyk_rent values (313, 33, 1, to_date('2016-01-03', 'yyyy-mm-dd'), to_date('2016-01-10', 'yyyy-mm-dd'), 0);
Insert into nyk_rent values (313, 34, 1, to_date('2015-12-15', 'yyyy-mm-dd'), to_date('2015-12-21', 'yyyy-mm-dd'), 0);
Insert into nyk_rent values (314, 31, 1, to_date('2016-01-02', 'yyyy-mm-dd'), to_date('2016-02-03', 'yyyy-mm-dd'), 0);
Insert into nyk_rent values (314, 32, 1, to_date('2015-09-17', 'yyyy-mm-dd'), to_date('2015-09-24', 'yyyy-mm-dd'), 0);

--
-- Systemdatum Ende
--
  SELECT user,
         TO_CHAR(SYSDATE, 'dd-mm-yy hh24:mi:ss') 
  FROM   dual
  ;  
--
spool off