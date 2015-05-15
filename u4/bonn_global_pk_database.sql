-- ***************************************************************
-- * File Name:                  bonn_global_pk_database.sql     *
-- * File Creator:               Knolle                          *
-- * CreationDate:               10. Mai 2015                    *
-- *                                                             *
-- * <ChangeLogDate>             <ChangeLogText>                 *
-- ***************************************************************
--
-- ***************************************************************
-- * Verteilte Datenbanksysteme SS 2015
-- * �bung 4 
-- * Schluesselintegritaet
--
-- ***************************************************************
-- * SQL*plus Job Control Section
--
set 	echo 		on
set 	linesize 	256
set 	pagesize 	50
set     escape      \
spool   ./bonn_global_pk_database.log

--
-- Systemdatum Start
--
  SELECT user,
         TO_CHAR(SYSDATE, 'dd-mm-yy hh24:mi:ss') 
  FROM   dual
  ;  
--
-- ***************************************************************
-- * Das globale Schema fuer den Standort Bonn  
--

--
-- ***************************************************************
-- * Initialisierung  
--

--DROP TRIGGER ...

DROP TRIGGER BNN_ARTICLE_TRI;
DROP TRIGGER BNN_CUSTOMER_TRI;
DROP SEQUENCE BNN_CUSTOMER_SEQ;
DROP SEQUENCE BNN_ARTICLE_SEQ;

--
-- ***************************************************************
-- * Erstellung der lokalen Schluesselintegritaet
--

CREATE SEQUENCE BNN_CUSTOMER_SEQ
START WITH 100000
MAXVALUE 199999
INCREMENT BY 1
NOCACHE
NOCYCLE;

CREATE SEQUENCE BNN_ARTICLE_SEQ
START WITH 100000
MAXVALUE 199999
INCREMENT BY 1
NOCACHE
NOCYCLE;

--CREATE TRIGGER ...

CREATE OR REPLACE TRIGGER BNN_ARTICLE_TRI
BEFORE INSERT ON BNN_ARTICLE
FOR EACH ROW
BEGIN
SELECT BNN_ARTICLE_SEQ.NEXTVAL
INTO :NEW.ID_ARTICLE
FROM dual;
EXCEPTION
WHEN OTHERS THEN
NULL;
END;
/

CREATE OR REPLACE TRIGGER BNN_CUSTOMER_TRI
BEFORE INSERT ON BNN_CUSTOMER
FOR EACH ROW
BEGIN
SELECT BNN_CUSTOMER_SEQ.NEXTVAL
INTO :NEW.ID_CUSTOMER
FROM dual;
EXCEPTION
WHEN OTHERS THEN
NULL;
END;
/

--
-- ***************************************************************
-- * Erstellung der globalen Schluesselintegritaet 
--

CREATE OR REPLACE TRIGGER CUSTOMER_GLO_TRI
INSTEAD OF INSERT OR DELETE ON customer
FOR EACH ROW
BEGIN
IF INSERTING THEN
IF :new.state = 'Germany' OR :new.state = 'Nethderlands' THEN
INSERT INTO BNN_CUSTOMER values (NULL,
:new.COMPANY, :new.ADDRESS, :new.ZIP, :new.CITY, :new.STATE);
ELSIF :new.state = 'United Kingdom' THEN
INSERT INTO LDN_CUSTOMER@london values (NULL,
:new.COMPANY, :new.ADDRESS, :new.ZIP, :new.CITY, :new.STATE);
ELSIF :new.state = 'USA' THEN
INSERT INTO NYK_CUSTOMER@newyork values (NULL,
:new.COMPANY, :new.ADDRESS, :new.ZIP, :new.CITY, :new.STATE);
END IF;
END IF;
IF DELETING THEN
IF :old.state = 'Germany' OR :old.state = 'Nethderlands' THEN
DELETE FROM BNN_CUSTOMER WHERE ID_CUSTOMER =
:old.ID_CUSTOMER;
elsif :old.state = 'United Kingdom' THEN
DELETE FROM LDN_CUSTOMER@london WHERE ID_CUSTOMER =
:old.ID_CUSTOMER;
elsif :old.state = 'USA' THEN
DELETE FROM NYK_CUSTOMER@newyork WHERE ID_CUSTOMER =
:old.ID_CUSTOMER;
END IF;
END IF;
END;
/

CREATE OR REPLACE TRIGGER ARTICLE_GLO_TRI
INSTEAD OF INSERT OR DELETE ON article
FOR EACH ROW
DECLARE
  depot_state depot.STATE%TYPE;
BEGIN
IF INSERTING THEN
 SELECT state
 INTO depot_state
 FROM depot 
 WHERE depot.ID_DEPOT = :new.ID_DEPOT;
dbms_output.Put_line(depot_state);
IF depot_state = 'Germany' OR depot_state = 'Nethderlands' THEN
INSERT INTO BNN_ARTICLE values (NULL,
:new.ITEM, :new.TYPE, :new.ID_SUPPLIER, :new.PUR_BASEPRICE, :new.PUR_CURRENCY, 
:new.PUR_PURCHASEDATE, :new.SAL_RENTALPRICEMONTH, :new.SAL_RENTALPRICEWEEK, 
:new.SAL_RENTALPRICEDAY,:new.SAL_CURRENCY, :new.ID_DEPOT, :new.DEP_LOCATION, 
:new.DEP_WEIGHTKG, :new.DEP_HEIGHTCM, :new.DEP_LENGTHCM, :new.DEP_BREADTHCM);
ELSIF depot_state = 'United Kingdom' THEN
INSERT INTO LDN_ARTICLE@london values (NULL,
:new.ITEM, :new.TYPE, :new.ID_SUPPLIER, :new.PUR_BASEPRICE, :new.PUR_CURRENCY, 
:new.PUR_PURCHASEDATE, :new.SAL_RENTALPRICEMONTH, :new.SAL_RENTALPRICEWEEK, 
:new.SAL_RENTALPRICEDAY, :new.SAL_CURRENCY, :new.ID_DEPOT, :new.DEP_LOCATION, 
:new.DEP_WEIGHTKG, :new.DEP_HEIGHTCM, :new.DEP_LENGTHCM, :new.DEP_BREADTHCM);
ELSIF depot_state = 'USA' THEN
INSERT INTO NYK_ARTICLE@newyork values (NULL,
:new.ITEM, :new.TYPE, :new.ID_SUPPLIER, :new.PUR_BASEPRICE, :new.PUR_CURRENCY, 
:new.PUR_PURCHASEDATE, :new.SAL_RENTALPRICEMONTH, :new.SAL_RENTALPRICEWEEK, 
:new.SAL_RENTALPRICEDAY, :new.SAL_CURRENCY, :new.ID_DEPOT, :new.DEP_LOCATION, 
:new.DEP_WEIGHTKG, :new.DEP_HEIGHTCM, :new.DEP_LENGTHCM, :new.DEP_BREADTHCM);
END IF;
END IF;
IF DELETING THEN
 SELECT state
 INTO depot_state
 FROM depot 
 WHERE depot.ID_DEPOT = :old.ID_DEPOT;
IF depot_state = 'Germany' OR depot_state = 'Nethderlands' THEN
DELETE FROM BNN_ARTICLE WHERE ID_ARTICLE = :old.ID_ARTICLE;
elsif depot_state = 'United Kingdom' THEN
DELETE FROM LDN_ARTICLE@london WHERE ID_ARTICLE = :old.ID_ARTICLE;
elsif depot_state = 'USA' THEN
DELETE FROM NYK_ARTICLE@newyork WHERE ID_ARTICLE = :old.ID_ARTICLE;
END IF;
END IF;
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