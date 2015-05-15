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
-- * Übung 4 
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
INSERT INTO LND_CUSTOMER values (NULL,
:new.COMPANY, :new.ADDRESS, :new.ZIP, :new.CITY, :new.STATE);
ELSIF :new.state = 'USA' THEN
INSERT INTO NYK_CUSTOMER values (NULL,
:new.COMPANY, :new.ADDRESS, :new.ZIP, :new.CITY, :new.STATE);
END IF;
END IF;
IF DELETING THEN
IF :old.state = 'Germany' OR :old.state = 'Nethderlands' THEN
DELETE FROM BNN_CUSTOMER WHERE ID_CUSTOMER =
:old.ID_CUSTOMER;
elsif :old.state = 'United Kingdom' THEN
DELETE FROM LND_CUSTOMER WHERE ID_CUSTOMER =
:old.ID_CUSTOMER;
elsif :old.state = 'USA' THEN
DELETE FROM NYK_CUSTOMER WHERE ID_CUSTOMER =
:old.ID_CUSTOMER;
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