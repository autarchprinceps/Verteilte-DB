-- ***************************************************************
-- * File Name:                  bonn_database.sql               *
-- * File Creator:               Knolle                          *
-- * CreationDate:               12. April 2015                  *
-- *                                                             *
-- * <ChangeLogDate>             <ChangeLogText>                 *
-- ***************************************************************
--
-- ***************************************************************
-- * Verteilte Datenbanksysteme SS 2015
-- * ‹bung 2 
-- * Allokation
--
-- ***************************************************************
-- * SQL*plus Job Control Section
--
set 	echo 		on
set 	linesize 	256
set 	pagesize 	50
set     escape      \
spool   ./bonn_database.log

--
-- Systemdatum Start
--
  SELECT user,
         TO_CHAR(SYSDATE, 'dd-mm-yy hh24:mi:ss') 
  FROM   dual
  ;  
--
drop table bnn_article purge;
drop table bnn_customer purge;
drop table depot purge;
drop table supplier purge;
drop table bnn_rent purge;

-- ***************************************************************
-- * Das lokale Schema f¸r den Standort Bonn  
--

create table bnn_article (
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

create table bnn_customer (
  ID_customer numeric(8) not null,
  company varchar(128) not null,
  address varchar(32) not null,
  zip varchar(16) not null,
  city varchar(32) not null,
  state varchar(32) not null,
  constraint PK_customer primary key (ID_customer)
);

create table depot (
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

create table bnn_rent (
  ID_customer numeric(8) not null,
  ID_article numeric(8) not null,
  contract numeric(8) not null,
  rentFrom date not null,
  rentTo date not null,
  returnFlag numeric(1) not null,
  constraint PK_rent primary key (ID_article, ID_customer, contract)
);

alter table bnn_article add constraint RK_bnn_article_depot
  foreign key (ID_depot)
  references depot;
alter table bnn_article add constraint RK_bnn_article_supplier
  foreign key (ID_supplier)
  references supplier;
alter table bnn_rent add constraint RK_bnn_rent_customer
  foreign key (ID_customer)
  references bnn_customer;

-- Inserts
-- table depot
Insert into depot values (1, 'Baumaschinen Verleih Bonn', 'Buddestraﬂe 30', '53111', 'Bonn', 'Germany');
Insert into depot values (2, 'The Hireman values (London) Ltd.', '53 Tanner Street', 'SE1 3PL', 'London', 'United Kingdom');
Insert into depot values (3, 'ABLE Equipment Rental', '21 Dixon Avenue', 'NY 11726', 'Copiague', 'USA');
-- table supplier
Insert into supplier values (1, 'S¸ddeutsche Baumaschinen Handels GmbH', 'Heinkelstraﬂe 8', 'Neu-Ulm', '89231', 'Germany');
Insert into supplier values (2, 'Maschinenhandel \& Vermietung', 'Weseler Straﬂe 68', 'Alpen', '46519', 'Germany');
Insert into supplier values (3, 'ATLAS Mortag', 'Auf dem Waidrasen 10', 'Bonn', '53111', 'Germany');
-- table bnn_article
Insert into bnn_article values (17, 'New-Holland', 'Excavator', 3, 18000.00, 'Euro', to_date('2010-06-07', 'yyyy-mm-dd'), 874.00, 340.00, 85.00, 'Euro', 1, 53, 1600.00, 250.00, 300.00, 100.00);
Insert into bnn_article values (18, 'Yanmar, ViO30', 'Excavator', 2, 25000.00, 'Euro', to_date('2010-09-10', 'yyyy-mm-dd'), 2500.00, 900.00, 190.40, 'Euro', 1, 12, 3270.00, 300.00, 400.00, 150.00);
-- table bnn_customer
Insert into bnn_customer values (11, 'BB Hoch- und Tiefbau GmbH', 'Tettaustraﬂe 1', 'Bonn', '53111', 'Germany');
Insert into bnn_customer values (12, 'Canzler Bau GmbH', 'Daasdorfer Straﬂe 38', 'Weimar', '99428', 'Germany');
Insert into bnn_customer values (13, 'Etzoldt Bau GmbH Hoch- und Tiefbau', 'Mittelstraﬂe 23', 'Jena', '07745', 'Germany');
Insert into bnn_customer values (14, 'Kkd Tiefbau Weimar GmbH', 'Dammstr. 2', 'Apolda', '99510', 'Germany');
Insert into bnn_customer values (15, 'TBI Holdings B.V.', 'Wilhelminaplein 37', 'Rotterdam', '3072 DE', 'Netherlands');
-- table bnn_rent
Insert into bnn_rent values (11, 17, 1, to_date('2015-05-10', 'yyyy-mm-dd'), to_date('2015-05-16', 'yyyy-mm-dd'), 0);
Insert into bnn_rent values (11, 17, 2, to_date('2015-07-20', 'yyyy-mm-dd'), to_date('2015-08-19', 'yyyy-mm-dd'), 0);
Insert into bnn_rent values (12, 18, 1, to_date('2015-03-11', 'yyyy-mm-dd'), to_date('2015-04-10', 'yyyy-mm-dd'), 1);
Insert into bnn_rent values (12, 18, 2, to_date('2015-05-22', 'yyyy-mm-dd'), to_date('2015-05-28', 'yyyy-mm-dd'), 0);
Insert into bnn_rent values (13, 17, 1, to_date('2015-12-27', 'yyyy-mm-dd'), to_date('2015-12-31', 'yyyy-mm-dd'), 0);
Insert into bnn_rent values (13, 18, 1, to_date('2015-06-17', 'yyyy-mm-dd'), to_date('2015-06-21', 'yyyy-mm-dd'), 0);
Insert into bnn_rent values (14, 17, 1, to_date('2015-05-18', 'yyyy-mm-dd'), to_date('2015-05-24', 'yyyy-mm-dd'), 0);
Insert into bnn_rent values (14, 18, 1, to_date('2016-01-10', 'yyyy-mm-dd'), to_date('2016-02-09', 'yyyy-mm-dd'), 0);
Insert into bnn_rent values (15, 17, 1, to_date('2015-06-10', 'yyyy-mm-dd'), to_date('2015-06-12', 'yyyy-mm-dd'), 0);
Insert into bnn_rent values (15, 17, 2, to_date('2016-02-05', 'yyyy-mm-dd'), to_date('2016-02-10', 'yyyy-mm-dd'), 0);

--
-- Systemdatum Ende
--
  SELECT user,
         TO_CHAR(SYSDATE, 'dd-mm-yy hh24:mi:ss') 
  FROM   dual
  ;  
--
spool off