-- ***************************************************************
-- * File Name:                  bonn_replication_database.sql   *
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
spool   ./bonn_replication_database.log

--
-- Systemdatum Start
--
  SELECT user,
         TO_CHAR(SYSDATE, 'dd-mm-yy hh24:mi:ss') 
  FROM   dual
  ;

DROP SEQUENCE BNN_depot_SEQ;
DROP SEQUENCE BNN_supplier_SEQ;
  
--
-- ***************************************************************
-- * Die Aenderungen fuer den Standort Bonn  
--

CREATE OR REPLACE TRIGGER BNN_ARTICLE_TRI
BEFORE INSERT ON BNN_ARTICLE
FOR EACH ROW
when (new.ID_ARTICLE IS NULL)
BEGIN
SELECT BNN_ARTICLE_SEQ.NEXTVAL
INTO :NEW.ID_ARTICLE
FROM dual;
EXCEPTION
WHEN OTHERS THEN
NULL;
END;
/

CREATE OR REPLACE TRIGGER BNN_RENT_TRI
BEFORE INSERT ON BNN_RENT
FOR EACH ROW
when (new.CONTRACT IS NULL)
BEGIN
SELECT BNN_RENT_SEQ.NEXTVAL
INTO :NEW.CONTRACT
FROM dual;
EXCEPTION
WHEN OTHERS THEN
NULL;
END;
/

CREATE OR REPLACE TRIGGER BNN_CUSTOMER_TRI
BEFORE INSERT ON BNN_CUSTOMER
FOR EACH ROW
when (new.ID_CUSTOMER IS NULL)
BEGIN
SELECT BNN_CUSTOMER_SEQ.NEXTVAL
INTO :NEW.ID_CUSTOMER
FROM dual;
EXCEPTION
WHEN OTHERS THEN
NULL;
END;
/

CREATE SEQUENCE BNN_depot_SEQ
START WITH 10
NOCYCLE;

CREATE OR REPLACE TRIGGER BNN_depot_TRI
BEFORE INSERT OR DELETE OR update ON depot
FOR EACH ROW
BEGIN
	if INSERTING then
		SELECT BNN_depot_SEQ.NEXTVAL
		INTO :NEW.ID_DEPOT
		FROM dual;
		insert into depot@newyork values(:NEW.ID_DEPOT, :NEW.COMPANY, :NEW.ADDRESS, :NEW.ZIP, :NEW.CITY, :NEW.STATE);
		insert into depot@london values(:NEW.ID_DEPOT, :NEW.COMPANY, :NEW.ADDRESS, :NEW.ZIP, :NEW.CITY, :NEW.STATE);
	elsif DELETING then
		delete from depot@newyork where :OLD.ID_DEPOT = ID_DEPOT;
		delete from depot@london where :OLD.ID_DEPOT = ID_DEPOT;
	elsif updating then
		update depot@newyork
		set
			ID_DEPOT = :NEW.ID_DEPOT,
			COMPANY = :NEW.COMPANY,
			ADDRESS = :NEW.ADDRESS,
			ZIP = :NEW.ZIP,
			CITY = :NEW.CITY,
			STATE = :NEW.STATE
		where :OLD.ID_DEPOT = ID_DEPOT;
		update depot@london
		set
			ID_DEPOT = :NEW.ID_DEPOT,
			COMPANY = :NEW.COMPANY,
			ADDRESS = :NEW.ADDRESS,
			ZIP = :NEW.ZIP,
			CITY = :NEW.CITY,
			STATE = :NEW.STATE
		where :OLD.ID_DEPOT = ID_DEPOT;
	end if;
EXCEPTION
WHEN OTHERS THEN
NULL;
END;
/

CREATE SEQUENCE BNN_supplier_SEQ
START WITH 10
NOCYCLE;

CREATE OR REPLACE TRIGGER BNN_supplier_TRI
BEFORE INSERT ON supplier
FOR EACH ROW
BEGIN
	if INSERTING then
		SELECT BNN_supplier_SEQ.NEXTVAL
		INTO :NEW.ID_SUPPLIER
		FROM dual;
		insert into supplier@newyork values(:NEW.ID_SUPPLIER, :NEW.COMPANY, :NEW.ADDRESS, :NEW.ZIP, :NEW.CITY, :NEW.STATE);
		insert into supplier@london values(:NEW.ID_SUPPLIER, :NEW.COMPANY, :NEW.ADDRESS, :NEW.ZIP, :NEW.CITY, :NEW.STATE);
	elsif DELETING then
		delete from supplier@newyork where :OLD.ID_SUPPLIER = ID_SUPPLIER;
		delete from supplier@london where :OLD.ID_SUPPLIER = ID_SUPPLIER;
	elsif updating then
		update supplier@newyork
		set
			ID_SUPPLIER = :NEW.ID_SUPPLIER,
			COMPANY = :NEW.COMPANY,
			ADDRESS = :NEW.ADDRESS,
			ZIP = :NEW.ZIP,
			CITY = :NEW.CITY,
			STATE = :NEW.STATE
		where :OLD.ID_SUPPLIER = ID_SUPPLIER;
		update supplier@london
		set
			ID_SUPPLIER = :NEW.ID_SUPPLIER,
			COMPANY = :NEW.COMPANY,
			ADDRESS = :NEW.ADDRESS,
			ZIP = :NEW.ZIP,
			CITY = :NEW.CITY,
			STATE = :NEW.STATE
		where :OLD.ID_SUPPLIER = ID_SUPPLIER;
	end if;
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
