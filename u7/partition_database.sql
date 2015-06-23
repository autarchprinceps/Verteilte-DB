-- ***************************************************************
-- * File Name:                  partition_database.sql          *
-- * File Creator:               Knolle                          *
-- * CreationDate:               19. June 2015                   *
-- *                                                             *
-- * <ChangeLogDate>             <ChangeLogText>                 *
-- ***************************************************************
--
-- ***************************************************************
-- * Verteilte Datenbanken SS 2015
-- * Uebung 7
-- * Partition
--
-- ***************************************************************
-- * SQL*plus Job Control Section
--
set 	echo 		on
set 	linesize 	256
set 	pagesize 	50
set     escape      \
spool   ./partition_database.log

--
-- Systemdatum Start
--
  SELECT user,
         TO_CHAR(SYSDATE, 'dd-mm-yy hh24:mi:ss')
  FROM   dual
  ;
--
-- ***************************************************************
-- * Erstellung der partitionierten Tabellen am Standort Bonn
--
drop table part_rent;
drop table part_article;
drop table part_customer;
drop table part_supplier;
DROP TABLE part_depot;

CREATE TABLE part_depot(
	id_depot	number(8,0)			not null,
	company		varchar2(32 byte)	not null,
	address		varchar2(32 byte)	not null,
	zip			varchar2(16 byte)	not null,
	city		varchar2(32 byte)	not null,
	state		varchar2(32 byte)	not null,
	constraint pk_part_depot primary key(id_depot)
) partition by list (state) (
	partition part_ldn values ('United Kingdom') tablespace tbs_london,
	partition part_nyk values ('USA') tablespace tbs_newyork,
	partition part_bnn values ('Germany') tablespace tbs_bonn
);

-- TODO partition
create table part_supplier(
	id_supplier	number(8,0)			not null,
	company 	varchar2(128 byte)	not null,
	address 	varchar2(32 byte)	not null,
	zip 		varchar2(16 byte)	not null,
	city 		varchar2(32 byte)	not null,
	state		varchar2(32 byte)	not null,
	constraint pk_part_supplier primary key(id_supplier)
);

CREATE TABLE part_ARTICLE(
	ID_ARTICLE				NUMBER(8,0) 		NOT NULL,
	ITEM 					VARCHAR2(128 BYTE)	NOT NULL,
	TYPE 					VARCHAR2(64 BYTE) 	NOT NULL,
	ID_SUPPLIER 			NUMBER(8,0) 		NOT NULL,
	PUR_BASEPRICE 			NUMBER(8,2) 		NOT NULL,
	PUR_CURRENCY 			VARCHAR2(16 BYTE) 	NOT NULL,
	PUR_PURCHASEDATE		DATE 				NOT NULL,
	SAL_RENTALPRICEMONTH 	NUMBER(8,2) 		NOT NULL,
	SAL_RENTALPRICEWEEK 	NUMBER(8,2) 		NOT NULL,
	SAL_RENTALPRICEDAY	 	NUMBER(8,2) 		NOT NULL,
	SAL_CURRENCY 			VARCHAR2(16 BYTE) 	NOT NULL,
	ID_DEPOT 				NUMBER(8,0)			NOT	NULL,
	DEP_LOCATION 			NUMBER(6,0) 		NOT NULL,
	DEP_WEIGHTKG 			NUMBER(6,2) 		NOT NULL,
	DEP_HEIGHTCM 			NUMBER(6,2) 		NOT NULL,
	DEP_LENGTHCM 			NUMBER(6,2) 		NOT NULL,
	DEP_BREADTHCM	 		NUMBER(6,2) 		NOT NULL,
	constraint pk_part_article 			primary key(id_article),
	constraint uk_part_article			unique(id_depot, dep_location),
	constraint fk_part_depot_article	foreign key(id_depot)
		references part_depot(id_depot),
	constraint fk_part_supplier_article	foreign key(id_supplier)
		references part_supplier(id_supplier)
) partition by reference(fk_part_depot_article);

create table part_customer(
	id_customer	number(8,0)			not null,
	company		varchar2(128 byte)	not null,
	address		varchar2(32 byte)	not null,
	zip			varchar2(16 byte)	not null,
	city		varchar2(32 byte)	not null,
	state		varchar2(32 byte)	not	null,
	constraint pk_part_customer primary key(id_customer)
) partition by list (state) (
	partition part_ldn values ('United Kingdom') tablespace tbs_london,
	partition part_nyk values ('United States', 'Canada') tablespace tbs_newyork,
	partition part_bnn values ('Germany', 'Netherlands') tablespace tbs_bonn
);

create table part_rent(
	id_customer	number(8,0)	not null,
	id_article	number(8,0)	not null,
	contract	number(8,0)	not null,
	rentfrom	date		not null,
	rentto		date		not null,
	returnflag	number(1,0)	not null,
	constraint pk_part_rent 			primary key(
		id_customer, id_article, contract
	),
	constraint fk_part_customer_rent	foreign key(id_customer)
		references part_customer(id_customer),
	constraint fk_part_article_rent		foreign key(id_article)
		references part_article(id_article)
) partition by reference(fk_part_article_rent);

--
-- ***************************************************************
-- * Einfügung der Beispieldaten
--
-- table depot
Insert into rent_depot values (1, 'Baumaschinen Verleih Bonn', 'Buddestraße 30', 'Bonn', '53111', 'Germany');
Insert into rent_depot values (2, 'The Hireman values (London) Ltd.', '53 Tanner Street', 'London', 'SE1 3PL', 'United Kingdom');
Insert into rent_depot values (3, 'ABLE Equipment Rental', '21 Dixon Avenue', 'Copiague', 'NY 11726', 'USA');
-- table supplier
Insert into rent_supplier values (1, 'Süddeutsche Baumaschinen Handels GmbH', 'Heinkelstraße 8', 'Neu-Ulm', '89231', 'Germany');
Insert into rent_supplier values (2, 'Maschinenhandel \& Vermietung', 'Weseler Straße 68', 'Alpen', '46519', 'Germany');
Insert into rent_supplier values (3, 'ATLAS Mortag', 'Auf dem Waidrasen 10', 'Bonn', '53111', 'Germany');
-- table article
Insert into rent_article values (1, 'Bomag Vibratory Roller - Ride-On - Smooth/Padfoot 48" Drum Width, BW124-3, 6,000 lbs', 'Vibratory Roller', 1, 20000.00, 'Euro', to_date('2010-10-23', 'yyyy-mm-dd'), 1004.00, 251.00, 104.00, 'Dollar', 3, 38, 2721.00, 120.00, 150.00, 200.00);
Insert into rent_article values (2, 'Bomag Vibratory Roller - Ride-On - Smooth/Padfoot Asphalt Roller - 3 Ton Vibratory Bomag BW120', 'Vibratory Roller', 1, 24000.00, 'Euro', to_date('2010-04-12', 'yyyy-mm-dd'), 1200.00, 300.00, 150.00, 'Dollar', 3, 64, 3000.00, 180.00, 200.00, 250.00);
Insert into rent_article values (3, 'Industrial - 5000 lbs Cushion Triple Mast', 'Fork Lift', 2, 16000.00, 'Euro', to_date('2010-03-01', 'yyyy-mm-dd'), 1300.00, 495.00, 165.00, 'Dollar', 3, 12, 1800.00, 250.00, 250.00, 150.00);
Insert into rent_article values (4, 'Industrial - 8,000 lbs Cushion Triple Mast', 'Fork Lift', 2, 23000.00, 'Euro', to_date('2010-08-20', 'yyyy-mm-dd'), 2430.00, 810, 270, 'Dollar', 3, 13, 1900.00, 280.00, 250.00, 150.00);
Insert into rent_article values (5, 'Single Tool Portable Compressor, 85cfm - Diesel', 'Compressor', 3, 18000.00, 'Euro', to_date('2010-04-18', 'yyyy-mm-dd'), 450.00, 150.00, 30.00, 'Pound', 2, 12, 500.00, 120.00, 200.00, 100.00);
Insert into rent_article values (6, 'Two Tool Portable Compressor, 150cfm - Diesel', 'Compressor', 3, 2000.00, 'Euro', to_date('2010-05-07', 'yyyy-mm-dd'), 498.00, 166.00, 34.00, 'Pound', 2, 2, 700.00, 150.00, 200.00, 110.00);
Insert into rent_article values (7, 'New-Holland', 'Excavator', 3, 18000.00, 'Euro', to_date('2010-06-07', 'yyyy-mm-dd'), 874.00, 340.00, 85.00, 'Euro', 1, 53, 1600.00, 250.00, 300.00, 100.00);
Insert into rent_article values (8, 'Yanmar, ViO30', 'Excavator', 2, 25000.00, 'Euro', to_date('2010-09-10', 'yyyy-mm-dd'), 2500.00, 900.00, 190.40, 'Euro', 1, 12, 3270.00, 300.00, 400.00, 150.00);
-- table customer
Insert into rent_customer values (1, 'BB Hoch- und Tiefbau GmbH', 'Tettaustraße 1', 'Bonn', '53111', 'Germany');
Insert into rent_customer values (2, 'Canzler Bau GmbH', 'Daasdorfer Straße 38', 'Weimar', '99428', 'Germany');
Insert into rent_customer values (3, 'Etzoldt Bau GmbH Hoch- und Tiefbau', 'Mittelstraße 23', 'Jena', '07745', 'Germany');
Insert into rent_customer values (4, 'Kkd Tiefbau Weimar GmbH', 'Dammstr. 2', 'Apolda', '99510', 'Germany');
Insert into rent_customer values (5, 'TBI Holdings B.V.', 'Wilhelminaplein 37', 'Rotterdam', '3072 DE', 'Netherlands');
Insert into rent_customer values (6, 'Brunelli Engineering Ltd', '10 Abbey Orchard Street', 'London', 'SW1P 2JP', 'United Kingdom');
Insert into rent_customer values (7, 'Skelton Group Cooting', 'Road Canterbury', 'Kent', 'CT3 3EP', 'United Kingdom');
Insert into rent_customer values (8, 'Renshaw Civil \& Safety Engineering', 'Saltwood', 'Hythe', 'CT21 4WN', 'United Kingdom');
Insert into rent_customer values (9, 'Meeres Civil Engineering', '309 Ballards Lane', 'London', 'N12 8LY', 'United Kingdom');
Insert into rent_customer values (10, 'Parsons Brinckerhoff', 'One Penn Plaza', 'New York', 'NY 10119', 'United States');
Insert into rent_customer values (11, 'Gannett Fleming', '380 Seventh Avenue', 'New York', 'NY 10121-0101', 'United States');
Insert into rent_customer values (12, 'Rhode Island Engineering', '397 Mourning Dove Drive', 'Saunderstown', 'RI', 'United States');
Insert into rent_customer values (13, 'American Engineering Co', '400 South County Trail', 'Exeter', 'RI', 'United States');
Insert into rent_customer values (14, 'EP and CC Consulting Inc', '24 Rosevear Avenue', 'Toronto', 'ON M4C 1Z3', 'Canada');
-- table rent
Insert into rent_rent values (1, 7, 1, to_date('2015-05-10', 'yyyy-mm-dd'), to_date('2015-05-16', 'yyyy-mm-dd'), 0);
Insert into rent_rent values (1, 7, 2, to_date('2015-07-20', 'yyyy-mm-dd'), to_date('2015-08-19', 'yyyy-mm-dd'), 0);
Insert into rent_rent values (2, 8, 1, to_date('2015-03-11', 'yyyy-mm-dd'), to_date('2015-04-10', 'yyyy-mm-dd'), 1);
Insert into rent_rent values (2, 8, 2, to_date('2015-05-22', 'yyyy-mm-dd'), to_date('2015-05-28', 'yyyy-mm-dd'), 0);
Insert into rent_rent values (3, 7, 1, to_date('2015-12-27', 'yyyy-mm-dd'), to_date('2015-12-31', 'yyyy-mm-dd'), 0);
Insert into rent_rent values (3, 8, 1, to_date('2015-06-17', 'yyyy-mm-dd'), to_date('2015-06-21', 'yyyy-mm-dd'), 0);
Insert into rent_rent values (4, 7, 1, to_date('2015-05-18', 'yyyy-mm-dd'), to_date('2015-05-24', 'yyyy-mm-dd'), 0);
Insert into rent_rent values (4, 8, 1, to_date('2016-01-10', 'yyyy-mm-dd'), to_date('2016-02-09', 'yyyy-mm-dd'), 0);
Insert into rent_rent values (5, 7, 1, to_date('2015-06-10', 'yyyy-mm-dd'), to_date('2015-06-12', 'yyyy-mm-dd'), 0);
Insert into rent_rent values (5, 7, 2, to_date('2016-02-05', 'yyyy-mm-dd'), to_date('2016-02-10', 'yyyy-mm-dd'), 0);
Insert into rent_rent values (6, 5, 1, to_date('2015-03-10', 'yyyy-mm-dd'), to_date('2015-03-15', 'yyyy-mm-dd'), 1);
Insert into rent_rent values (6, 5, 2, to_date('2015-04-15', 'yyyy-mm-dd'), to_date('2015-04-20', 'yyyy-mm-dd'), 1);
Insert into rent_rent values (7, 6, 1, to_date('2015-06-08', 'yyyy-mm-dd'), to_date('2015-10-08', 'yyyy-mm-dd'), 0);
Insert into rent_rent values (7, 6, 2, to_date('2015-09-20', 'yyyy-mm-dd'), to_date('2015-10-19', 'yyyy-mm-dd'), 0);
Insert into rent_rent values (8, 5, 1, to_date('2015-09-18', 'yyyy-mm-dd'), to_date('2015-09-24', 'yyyy-mm-dd'), 0);
Insert into rent_rent values (8, 6, 1, to_date('2016-01-05', 'yyyy-mm-dd'), to_date('2016-02-04', 'yyyy-mm-dd'), 0);
Insert into rent_rent values (9, 5, 1, to_date('2016-02-10', 'yyyy-mm-dd'), to_date('2016-02-15', 'yyyy-mm-dd'), 1);
Insert into rent_rent values (9, 6, 1, to_date('2015-11-11', 'yyyy-mm-dd'), to_date('2015-11-17', 'yyyy-mm-dd'), 0);
Insert into rent_rent values (10, 1, 1, to_date('2015-03-10', 'yyyy-mm-dd'), to_date('2015-04-09', 'yyyy-mm-dd'), 1);
Insert into rent_rent values (10, 2, 1, to_date('2015-02-10', 'yyyy-mm-dd'), to_date('2015-02-15', 'yyyy-mm-dd'), 1);
Insert into rent_rent values (11, 3, 1, to_date('2015-07-11', 'yyyy-mm-dd'), to_date('2015-07-18', 'yyyy-mm-dd'), 0);
Insert into rent_rent values (11, 4, 1, to_date('2015-06-22', 'yyyy-mm-dd'), to_date('2015-06-28', 'yyyy-mm-dd'), 0);
Insert into rent_rent values (12, 1, 1, to_date('2015-05-06', 'yyyy-mm-dd'), to_date('2015-05-12', 'yyyy-mm-dd'), 0);
Insert into rent_rent values (12, 2, 1, to_date('2015-03-22', 'yyyy-mm-dd'), to_date('2015-03-28', 'yyyy-mm-dd'), 1);
Insert into rent_rent values (13, 3, 1, to_date('2016-01-03', 'yyyy-mm-dd'), to_date('2016-01-10', 'yyyy-mm-dd'), 0);
Insert into rent_rent values (13, 4, 1, to_date('2015-12-15', 'yyyy-mm-dd'), to_date('2015-12-21', 'yyyy-mm-dd'), 0);
Insert into rent_rent values (14, 1, 1, to_date('2016-01-02', 'yyyy-mm-dd'), to_date('2016-02-03', 'yyyy-mm-dd'), 0);
Insert into rent_rent values (14, 2, 1, to_date('2015-09-17', 'yyyy-mm-dd'), to_date('2015-09-24', 'yyyy-mm-dd'), 0);


--
-- ***************************************************************
-- * Test der Partitionierung
--
SELECT

INSERT

DELETE

UPDATE

--
-- ***************************************************************
-- * Experimente mit dem Data Dictionary
-- * USER_PART_TABLES, USER_TAB_PARTITIONS
--
DESCRIBE user_part_tables;
SELECT * from user_part_tables;

describe user_tab_partitions;
select * from user_tab_partitions;


--
-- Systemdatum Ende
--
  SELECT user,
         TO_CHAR(SYSDATE, 'dd-mm-yy hh24:mi:ss')
  FROM   dual
  ;
--
spool off
