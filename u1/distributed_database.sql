spool ./distributed_database.log
set		echo 		on
set 	linesize 	256
set 	pagesize 	50
set     escape      \

select user, TO_CHAR(SYSDATE, 'dd-mm-yy hh24:mi:ss') from dual;  

drop table article purge;
drop table customer purge;
drop table depot purge;
drop table supplier purge;
drop table rent purge;

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

-- Disable Foreign Key Constraint Section
alter table article disable constraint RK_article_depot;
alter table article disable constraint RK_article_supplier;
alter table rent disable constraint RK_rent_customer;
alter table rent disable constraint RK_rent_article;

-- Disable Primary Key Constraint Section
alter table article disable constraint PK_article;
alter table article disable constraint UK_article;
alter table customer disable constraint PK_customer;
alter table depot disable constraint PK_depot;
alter table supplier disable constraint PK_supplier;
alter table rent disable constraint PK_rent;

-- table depot
Insert into depot values (1, 'Baumaschinen Verleih Bonn', 'Buddestraße 30', 'Bonn', '53111', 'Germany');
Insert into depot values (2, 'The Hireman values (London) Ltd.', '53 Tanner Street', 'London', 'SE1 3PL', 'United Kingdom');
Insert into depot values (3, 'ABLE Equipment Rental', '21 Dixon Avenue', 'Copiague', 'NY 11726', 'USA');
-- table supplier
Insert into supplier values (1, 'Süddeutsche Baumaschinen Handels GmbH', 'Heinkelstraße 8', 'Neu-Ulm', '89231', 'Germany');
Insert into supplier values (2, 'Maschinenhandel \& Vermietung', 'Weseler Straße 68', 'Alpen', '46519', 'Germany');
Insert into supplier values (3, 'ATLAS Mortag', 'Auf dem Waidrasen 10', 'Bonn', '53111', 'Germany');
-- table article
Insert into article values (1, 'Bomag Vibratory Roller - Ride-On - Smooth/Padfoot 48" Drum Width, BW124-3, 6,000 lbs', 'Vibratory Roller', 1, 20000.00, 'Euro', to_date('2010-10-23', 'yyyy-mm-dd'), 1004.00, 251.00, 104.00, 'Dollar', 3, 38, 2721.00, 120.00, 150.00, 200.00);
Insert into article values (2, 'Bomag Vibratory Roller - Ride-On - Smooth/Padfoot Asphalt Roller - 3 Ton Vibratory Bomag BW120', 'Vibratory Roller', 1, 24000.00, 'Euro', to_date('2010-04-12', 'yyyy-mm-dd'), 1200.00, 300.00, 150.00, 'Dollar', 3, 64, 3000.00, 180.00, 200.00, 250.00);
Insert into article values (3, 'Industrial - 5000 lbs Cushion Triple Mast', 'Fork Lift', 2, 16000.00, 'Euro', to_date('2010-03-01', 'yyyy-mm-dd'), 1300.00, 495.00, 165.00, 'Dollar', 3, 12, 1800.00, 250.00, 250.00, 150.00);
Insert into article values (4, 'Industrial - 8,000 lbs Cushion Triple Mast', 'Fork Lift', 2, 23000.00, 'Euro', to_date('2010-08-20', 'yyyy-mm-dd'), 2430.00, 810, 270, 'Dollar', 3, 13, 1900.00, 280.00, 250.00, 150.00);
Insert into article values (5, 'Single Tool Portable Compressor, 85cfm - Diesel', 'Compressor', 3, 18000.00, 'Euro', to_date('2010-04-18', 'yyyy-mm-dd'), 450.00, 150.00, 30.00, 'Pound', 2, 12, 500.00, 120.00, 200.00, 100.00);
Insert into article values (6, 'Two Tool Portable Compressor, 150cfm - Diesel', 'Compressor', 3, 2000.00, 'Euro', to_date('2010-05-07', 'yyyy-mm-dd'), 498.00, 166.00, 34.00, 'Pound', 2, 2, 700.00, 150.00, 200.00, 110.00);
Insert into article values (7, 'New-Holland', 'Excavator', 3, 18000.00, 'Euro', to_date('2010-06-07', 'yyyy-mm-dd'), 874.00, 340.00, 85.00, 'Euro', 1, 53, 1600.00, 250.00, 300.00, 100.00);
Insert into article values (8, 'Yanmar, ViO30', 'Excavator', 2, 25000.00, 'Euro', to_date('2010-09-10', 'yyyy-mm-dd'), 2500.00, 900.00, 190.40, 'Euro', 1, 12, 3270.00, 300.00, 400.00, 150.00);
-- table customer
Insert into customer values (1, 'BB Hoch- und Tiefbau GmbH', 'Tettaustraße 1', 'Bonn', '53111', 'Germany');
Insert into customer values (2, 'Canzler Bau GmbH', 'Daasdorfer Straße 38', 'Weimar', '99428', 'Germany');
Insert into customer values (3, 'Etzoldt Bau GmbH Hoch- und Tiefbau', 'Mittelstraße 23', 'Jena', '07745', 'Germany');
Insert into customer values (4, 'Kkd Tiefbau Weimar GmbH', 'Dammstr. 2', 'Apolda', '99510', 'Germany');
Insert into customer values (5, 'TBI Holdings B.V.', 'Wilhelminaplein 37', 'Rotterdam', '3072 DE', 'Netherlands');
Insert into customer values (6, 'Brunelli Engineering Ltd', '10 Abbey Orchard Street', 'London', 'SW1P 2JP', 'United Kingdom');
Insert into customer values (7, 'Skelton Group Cooting', 'Road Canterbury', 'Kent', 'CT3 3EP', 'United Kingdom');
Insert into customer values (8, 'Renshaw Civil \& Safety Engineering', 'Saltwood', 'Hythe', 'CT21 4WN', 'United Kingdom');
Insert into customer values (9, 'Meeres Civil Engineering', '309 Ballards Lane', 'London', 'N12 8LY', 'United Kingdom');
Insert into customer values (10, 'Parsons Brinckerhoff', 'One Penn Plaza', 'New York', 'NY 10119', 'United States');
Insert into customer values (11, 'Gannett Fleming', '380 Seventh Avenue', 'New York', 'NY 10121-0101', 'United States');
Insert into customer values (12, 'Rhode Island Engineering', '397 Mourning Dove Drive', 'Saunderstown', 'RI', 'United States');
Insert into customer values (13, 'American Engineering Co', '400 South County Trail', 'Exeter', 'RI', 'United States');
Insert into customer values (14, 'EP and CC Consulting Inc', '24 Rosevear Avenue', 'Toronto', 'ON M4C 1Z3', 'Canada');
-- table rent
Insert into rent values (1, 7, 1, to_date('2015-05-10', 'yyyy-mm-dd'), to_date('2015-05-16', 'yyyy-mm-dd'), 0);
Insert into rent values (1, 7, 2, to_date('2015-07-20', 'yyyy-mm-dd'), to_date('2015-08-19', 'yyyy-mm-dd'), 0);
Insert into rent values (2, 8, 1, to_date('2015-03-11', 'yyyy-mm-dd'), to_date('2015-04-10', 'yyyy-mm-dd'), 1);
Insert into rent values (2, 8, 2, to_date('2015-05-22', 'yyyy-mm-dd'), to_date('2015-05-28', 'yyyy-mm-dd'), 0);
Insert into rent values (3, 7, 1, to_date('2015-12-27', 'yyyy-mm-dd'), to_date('2015-12-31', 'yyyy-mm-dd'), 0);
Insert into rent values (3, 8, 1, to_date('2015-06-17', 'yyyy-mm-dd'), to_date('2015-06-21', 'yyyy-mm-dd'), 0);
Insert into rent values (4, 7, 1, to_date('2015-05-18', 'yyyy-mm-dd'), to_date('2015-05-24', 'yyyy-mm-dd'), 0);
Insert into rent values (4, 8, 1, to_date('2016-01-10', 'yyyy-mm-dd'), to_date('2016-02-09', 'yyyy-mm-dd'), 0);
Insert into rent values (5, 7, 1, to_date('2015-06-10', 'yyyy-mm-dd'), to_date('2015-06-12', 'yyyy-mm-dd'), 0);
Insert into rent values (5, 7, 2, to_date('2016-02-05', 'yyyy-mm-dd'), to_date('2016-02-10', 'yyyy-mm-dd'), 0);
Insert into rent values (6, 5, 1, to_date('2015-03-10', 'yyyy-mm-dd'), to_date('2015-03-15', 'yyyy-mm-dd'), 1);
Insert into rent values (6, 5, 2, to_date('2015-04-15', 'yyyy-mm-dd'), to_date('2015-04-20', 'yyyy-mm-dd'), 1);
Insert into rent values (7, 6, 1, to_date('2015-06-08', 'yyyy-mm-dd'), to_date('2015-10-08', 'yyyy-mm-dd'), 0);
Insert into rent values (7, 6, 2, to_date('2015-09-20', 'yyyy-mm-dd'), to_date('2015-10-19', 'yyyy-mm-dd'), 0);
Insert into rent values (8, 5, 1, to_date('2015-09-18', 'yyyy-mm-dd'), to_date('2015-09-24', 'yyyy-mm-dd'), 0);
Insert into rent values (8, 6, 1, to_date('2016-01-05', 'yyyy-mm-dd'), to_date('2016-02-04', 'yyyy-mm-dd'), 0);
Insert into rent values (9, 5, 1, to_date('2016-02-10', 'yyyy-mm-dd'), to_date('2016-02-15', 'yyyy-mm-dd'), 1);
Insert into rent values (9, 6, 1, to_date('2015-11-11', 'yyyy-mm-dd'), to_date('2015-11-17', 'yyyy-mm-dd'), 0);
Insert into rent values (10, 1, 1, to_date('2015-03-10', 'yyyy-mm-dd'), to_date('2015-04-09', 'yyyy-mm-dd'), 1);
Insert into rent values (10, 2, 1, to_date('2015-02-10', 'yyyy-mm-dd'), to_date('2015-02-15', 'yyyy-mm-dd'), 1);
Insert into rent values (11, 3, 1, to_date('2015-07-11', 'yyyy-mm-dd'), to_date('2015-07-18', 'yyyy-mm-dd'), 0);
Insert into rent values (11, 4, 1, to_date('2015-06-22', 'yyyy-mm-dd'), to_date('2015-06-28', 'yyyy-mm-dd'), 0);
Insert into rent values (12, 1, 1, to_date('2015-05-06', 'yyyy-mm-dd'), to_date('2015-05-12', 'yyyy-mm-dd'), 0);
Insert into rent values (12, 2, 1, to_date('2015-03-22', 'yyyy-mm-dd'), to_date('2015-03-28', 'yyyy-mm-dd'), 1);
Insert into rent values (13, 3, 1, to_date('2016-01-03', 'yyyy-mm-dd'), to_date('2016-01-10', 'yyyy-mm-dd'), 0);
Insert into rent values (13, 4, 1, to_date('2015-12-15', 'yyyy-mm-dd'), to_date('2015-12-21', 'yyyy-mm-dd'), 0);
Insert into rent values (14, 1, 1, to_date('2016-01-02', 'yyyy-mm-dd'), to_date('2016-02-03', 'yyyy-mm-dd'), 0);
Insert into rent values (14, 2, 1, to_date('2015-09-17', 'yyyy-mm-dd'), to_date('2015-09-24', 'yyyy-mm-dd'), 0);

-- Reenable Primary Key Constraint Section
alter table article enable constraint PK_article;
alter table article enable constraint UK_article;
alter table customer enable constraint PK_customer;
alter table depot enable constraint PK_depot;
alter table supplier enable constraint PK_supplier;
alter table rent enable constraint PK_rent;

-- Reenable Foreign Key Constraint Section
alter table article enable constraint RK_article_depot;
alter table article enable constraint RK_article_supplier;
alter table rent enable constraint RK_rent_customer;
alter table rent enable constraint RK_rent_article;

-- Test Section
describe depot
select count(*) from depot;

describe customer
select count(*) from customer;

describe supplier
select count(*) from supplier;

describe article
select count(*) from article;

describe rent
select count(*) from rent;


select user, TO_CHAR(SYSDATE, 'dd-mm-yy hh24:mi:ss') from dual;

spool off
