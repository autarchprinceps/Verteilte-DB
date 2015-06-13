-- ***************************************************************
-- * File Name:                  london_replication_database.sql *
-- * File Creator:               Knolle                          *
-- * CreationDate:               23. Mai 2015                    *
-- *                                                             *
-- * <ChangeLogDate>             <ChangeLogText>                 *
-- ***************************************************************
--
-- ***************************************************************
-- * Verteilte Datenbanksysteme SS 2015
-- * Uebung 6 
-- * Replikation
--
-- ***************************************************************
-- * SQL*plus Job Control Section
--
set 	echo 		on
set 	linesize 	256
set 	pagesize 	50
set     escape      \
spool   ./london_replication_database.log

--
-- Systemdatum Start
--
  SELECT user,
         TO_CHAR(SYSDATE, 'dd-mm-yy hh24:mi:ss') 
  FROM   dual
  ;
  
drop synonym depot;
drop table depot;

create table depot (
  ID_depot numeric(8) not null,
  company varchar(32) not null,
  address varchar(32) not null,
  zip varchar(16) not null,
  city varchar(32) not null,
  state varchar(32) not null,
  constraint PK_depot primary key (ID_depot)
);

drop synonym supplier;
drop table supplier;

create table supplier (
  ID_supplier numeric(8) not null,
  company varchar(128) not null,
  address varchar(32) not null,
  zip varchar(16) not null,
  city varchar(32) not null,
  state varchar(32) not null,
  constraint PK_supplier primary key (ID_supplier)
);

--
-- ***************************************************************
-- * Die Aenderungen fuer den Standort London  
--

create or replace trigger ldn_depot_tri
instead of insert ON DEPOT -- TODO modify, delete?
for all rows
when (:new.id_depot is null)
begin
	insert into depot@bonn values(NULL,  :NEW.COMPANY, :NEW.ADDRESS, :NEW.ZIP, :NEW.CITY, :NEW.STATE);
EXCEPTION
WHEN OTHERS THEN
NULL;
END;
/

create or replace trigger ldn_supplier_tri
instead of insert ON SUPPLIER -- TODO modify, delete?
for all rows
when (:new.id_supplier is null)
begin
	insert into supplier@bonn values(NULL,  :NEW.COMPANY, :NEW.ADDRESS, :NEW.ZIP, :NEW.CITY, :NEW.STATE);
EXCEPTION
WHEN OTHERS THEN
NULL;
END;
/

CREATE OR REPLACE TRIGGER ldn_ARTICLE_TRI
BEFORE INSERT OR DELETE OR MODIFY ON ldn_ARTICLE
FOR EACH ROW
BEGIN
	IF INSERTING THEN
		SELECT ldn_ARTICLE_SEQ.NEXTVAL
		INTO :NEW.ID_ARTICLE
		FROM dual;
		INSERT INTO BNN_ARTICLE@BONN VALUES(:NEW.ID_ARTICLE, :NEW.ITEM, :NEW.TYPE, :NEW.ID_SUPPLIER, :NEW.PUR_BASEPRICE, :NEW.PUR_CURRENCY,
			:NEW.PUR_PURCHASEDATE, :NEW.SAL_RENTALPRICEMONTH, :NEW.SAL_RENTALPRICEWEEK, :NEW.SAL_RENTALPRICEDAY, :NEW.SAL_CURRENCY, :NEW.ID_DEPOT,
			:NEW.DEP_LOCATION, :NEW.DEP_WEIGHTKG, :NEW.DEP_HEIGHTCM, :NEW.DEP_LENGTHCM, :NEW.DEP_BREADTHCM);
	ELSIF DELETING THEN
		DELETE FROM BNN_ARTICLE@BONN WHERE :NEW.ID_ARTICLE = ID_ARTICLE;
	ELSIF MODIFYING THEN
		UPDATE BNN_ARTICLE@BONN SET
			ID_ARTICLE = :new.ID_ARTICLE,
			ITEM = :new.ITEM,
			TYPE = :new.TYPE,
			ID_SUPPLIER = :new.ID_SUPPLIER,
			PUR_BASEPRICE = :new.PUR_BASEPRICE,
			PUR_CURRENCY = :new.PUR_CURRENCY,
			PUR_PURCHASEDATE = :new.PUR_PURCHASEDATE,
			SAL_RENTALPRICEMONTH = :new.SAL_RENTALPRICEMONTH,
			SAL_RENTALPRICEWEEK = :new.SAL_RENTALPRICEWEEK,
			SAL_RENTALPRICEDAY = :new.SAL_RENTALPRICEDAY,
			SAL_CURRENCY = :new.SAL_CURRENCY,
			ID_DEPOT = :new.ID_DEPOT,
			DEP_LOCATION = :new.DEP_LOCATION,
			DEP_WEIGHTKG = :new.DEP_WEIGHTKG,
			DEP_HEIGHTCM = :new.DEP_HEIGHTCM,
			DEP_LENGTHCM = :new.DEP_LENGTHCM,
			DEP_BREADTHCM = :new.DEP_BREADTHCM
		WHERE :OLD.ID_ARTICLE = ID_ARTICLE;
	END IF;
EXCEPTION
WHEN OTHERS THEN
NULL;
END;
/

CREATE OR REPLACE TRIGGER ldn_RENT_TRI
BEFORE INSERT OR DELETE OR MODIFY ON ldn_rent
FOR EACH ROW
BEGIN
	IF INSERTING THEN
		SELECT ldn_RENT_SEQ.NEXTVAL
		INTO :NEW.CONTRACT
		FROM dual;
		INSERT INTO BNN_RENT@BONN VALUES(:NEW.ID_CUSTOMER; :NEW.ID_ARTICLE, :NEW.CONTRACT, :NEW.RENTFROM, :NEW.RENTTO, :NEW.RETURNFLAG);
	ELSIF DELETING THEN
		DELETE FROM BNN_RENT@BONN WHERE :NEW.ID_CUSTOMER = ID_CUSTOMER AND :NEW.ID_ARTICLE = ID_ARTICLE AND :NEW.CONTRACT = CONTRACT;
	ELSIF MODIFYING THEN
		UPDATE BNN_RENT@BONN SET
			ID_CUSTOMER = :NEW.ID_CUSTOMER,
			ID_ARTICLE = :NEW.ID_ARTICLE,
			CONTRACT = :NEW.CONTRACT,
			RENTFROM = :NEW.RENTFROM,
			RENTTO = :NEW.RENTTO
		WHERE :NEW.ID_CUSTOMER = ID_CUSTOMER AND :NEW.ID_ARTICLE = ID_ARTICLE AND :NEW.CONTRACT = CONTRACT;
	END IF;
EXCEPTION
WHEN OTHERS THEN
NULL;
END;
/

CREATE OR REPLACE TRIGGER ldn_CUSTOMER_TRI
BEFORE INSERT OR DELETE OR MODIFY ON ldn_CUSTOMER
FOR EACH ROW
BEGIN
	IF INSERTING THEN
		SELECT ldn_CUSTOMER_SEQ.NEXTVAL
		INTO :NEW.ID_CUSTOMER
		FROM dual;
		insert into bnn_customer@bonn values(:new.ID_CUSTOMER, :new.COMPANY, :new.ADDRESS; :NEW.ZIP, :NEW.CITY, :NEW.STATE);
	ELSIF DELETING THEN
		DELETE FROM BNN_CUSTOMER@BONN WHERE :OLD.ID_CUSTOMER = ID_CUSTOMER;
	ELSIF MODIFYING THEN
		UPDATE BNN_CUSTOMER@BONN SET
			ID_CUSTOMER = :NEW.ID_CUSTOMER,
			COMPANY = :NEW.COMPANY,
			ADDRESS = :NEW.ADDRESS,
			ZIP = :NEW.ZIP,
			CITY = :NEW.CITY,
			STATE = :NEW.STATE
		WHERE :OLD.ID_CUSTOMER = ID_CUSTOMER;
	END IF;
EXCEPTION
WHEN OTHERS THEN
NULL;
END;
/

--
-- Systemdatum Ende
--
  SELECT user,
         TO_CHAR(SYSDATE, 'dd-mm-yy hh24:mi:ss') 
  FROM   dual
  ;  
--
spool off