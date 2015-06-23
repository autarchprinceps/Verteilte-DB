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
INSERT INTO

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
DESCRIBE

SELECT


--
-- Systemdatum Ende
--
  SELECT user,
         TO_CHAR(SYSDATE, 'dd-mm-yy hh24:mi:ss')
  FROM   dual
  ;
--
spool off
