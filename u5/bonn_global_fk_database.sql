-- ***************************************************************
-- * File Name:                  bonn_global_fk_database.sql     *
-- * File Creator:               Knolle                          *
-- * CreationDate:               10. Mai 2015                    *
-- *                                                             *
-- * <ChangeLogDate>             <ChangeLogText>                 *
-- ***************************************************************
--
-- ***************************************************************
-- * Verteilte Datenbanksysteme SS 2015
-- * �bung 5
-- * Schluesselintegritaet
--
-- ***************************************************************
-- * SQL*plus Job Control Section
--
set 	echo 		on
set 	linesize 	256
set 	pagesize 	50
set     escape      \
spool   ./bonn_global_fk_database.log

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

DROP TRIGGER BNN_ARTICLE_TRI;
DROP TRIGGER BNN_RENT_TRI;
DROP TRIGGER BNN_CUSTOMER_TRI;
DROP TRIGGER CUSTOMER_GLO_TRI;
DROP TRIGGER ARTICLE_GLO_TRI;
DROP TRIGGER RENT_GLO_TRI;

DROP SEQUENCE CUSTOMER_SEQ;
DROP SEQUENCE ARTICLE_SEQ;
DROP SEQUENCE BNN_CUSTOMER_SEQ;
DROP SEQUENCE BNN_ARTICLE_SEQ;
DROP SEQUENCE BNN_RENT_SEQ;

--
-- ***************************************************************
-- * Erstellung der lokalen Schluesselintegritaet
--

CREATE SEQUENCE BNN_CUSTOMER_SEQ
START WITH 2001
INCREMENT BY 10
NOCYCLE;

CREATE SEQUENCE BNN_ARTICLE_SEQ
START WITH 2001
INCREMENT BY 10
NOCYCLE;

CREATE SEQUENCE BNN_RENT_SEQ
START WITH 2001
INCREMENT BY 10
NOCYCLE;


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

CREATE OR REPLACE TRIGGER BNN_RENT_TRI
BEFORE INSERT ON BNN_RENT
FOR EACH ROW
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
DECLARE
	rent_id int;
BEGIN
IF INSERTING THEN
	IF :new.state = 'Germany' OR :new.state = 'Netherlands' THEN
		INSERT INTO BNN_CUSTOMER values (NULL,
		:new.COMPANY, :new.ADDRESS, :new.ZIP, :new.CITY, :new.STATE);
	ELSIF :new.state = 'United Kingdom' THEN
		INSERT INTO LDN_CUSTOMER@london values (NULL,
		:new.COMPANY, :new.ADDRESS, :new.ZIP, :new.CITY, :new.STATE);
	ELSIF :new.state = 'United States' OR :new.state = 'Canada' THEN
		INSERT INTO NYK_CUSTOMER@newyork values (NULL,
		:new.COMPANY, :new.ADDRESS, :new.ZIP, :new.CITY, :new.STATE);
	ELSE
		RAISE_APPLICATION_ERROR(-21000, 'Invalid state');
	END IF;
END IF;
IF DELETING THEN
	SELECT count(ID_CUSTOMER)
	INTO rent_id
	FROM rent
	WHERE rent.ID_CUSTOMER = :old.ID_CUSTOMER;
	IF rent_id > 0 THEN
		RAISE_APPLICATION_ERROR(-21001, 'Delete failed');
	ELSE
		IF :old.state = 'Germany' OR :old.state = 'Netherlands' THEN
			DELETE FROM BNN_CUSTOMER WHERE ID_CUSTOMER =
			:old.ID_CUSTOMER;
		elsif :old.state = 'United Kingdom' THEN
			DELETE FROM LDN_CUSTOMER@london WHERE ID_CUSTOMER =
			:old.ID_CUSTOMER;
		elsif :old.state = 'United States' OR :new.state = 'Canada' THEN
			DELETE FROM NYK_CUSTOMER@newyork WHERE ID_CUSTOMER =
			:old.ID_CUSTOMER;
		ELSE
			RAISE_APPLICATION_ERROR(-21002, 'Invalid state');
		END IF;
	END IF;
END IF;
END;
/

CREATE OR REPLACE TRIGGER ARTICLE_GLO_TRI
INSTEAD OF INSERT OR DELETE ON article
FOR EACH ROW
DECLARE
	depot_state depot.STATE%TYPE;
	sup_id int;
	rent_id int;
BEGIN
IF INSERTING THEN
	SELECT state
	INTO depot_state
	FROM depot
	WHERE depot.ID_DEPOT = :new.ID_DEPOT;
	SELECT count(ID_SUPPLIER)
	INTO sup_id
	FROM supplier
	WHERE supplier.ID_SUPPLIER = :new.ID_SUPPLIER;
	dbms_output.Put_line(depot_state);
	IF sup_id = 0 THEN
		RAISE_APPLICATION_ERROR(-21003, 'No supplier');
	ELSE
		IF depot_state = 'Germany' THEN
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
		ELSE
			RAISE_APPLICATION_ERROR(-21004, 'Invalid depot');
		END IF;
	END IF;
END IF;
IF DELETING THEN
	SELECT state
	INTO depot_state
	FROM depot
	WHERE depot.ID_DEPOT = :old.ID_DEPOT;
	SELECT count(ID_ARTICLE)
	INTO rent_id
	FROM RENT
	WHERE RENT.ID_ARTICLE = :old.ID_ARTICLE;
	IF rent_id > 0 THEN
		RAISE_APPLICATION_ERROR(-21005, 'Delete failed');
	ELSE
		IF depot_state = 'Germany' THEN
			DELETE FROM BNN_ARTICLE WHERE ID_ARTICLE = :old.ID_ARTICLE;
		elsif depot_state = 'United Kingdom' THEN
			DELETE FROM LDN_ARTICLE@london WHERE ID_ARTICLE = :old.ID_ARTICLE;
		elsif depot_state = 'USA' THEN
			DELETE FROM NYK_ARTICLE@newyork WHERE ID_ARTICLE = :old.ID_ARTICLE;
		ELSE
			RAISE_APPLICATION_ERROR(-21006, 'Invalid depot state');
		END IF;
	END IF;
END IF;
END;
/

CREATE OR REPLACE TRIGGER RENT_GLO_TRI
INSTEAD OF INSERT OR DELETE ON rent
FOR EACH ROW
DECLARE
	cust_state customer.STATE%TYPE;
	article_id int;
BEGIN
IF INSERTING THEN
	SELECT state
	INTO cust_state
	FROM customer
	WHERE customer.ID_CUSTOMER = :new.ID_CUSTOMER;
	SELECT count(ID_ARTICLE)
	INTO article_id
	FROM article
	where article.ID_ARTICLE = :new.ID_ARTICLE;
	IF article_id = 0 THEN
		RAISE_APPLICATION_ERROR(-21007, 'No article');
	ELSE
		IF cust_state = 'Germany' OR cust_state = 'Nethderlands' THEN
			INSERT INTO BNN_RENT (ID_CUSTOMER, ID_ARTICLE, CONTRACT, RENTFROM, RENTTO, RETURNFLAG)
			values (:new.ID_CUSTOMER, :new.ID_ARTICLE, :new.CONTRACT, :new.RENTFROM, :new.RENTTO, :new.RETURNFLAG);
		ELSIF cust_state = 'United Kingdom' THEN
			INSERT INTO LDN_RENT@london (ID_CUSTOMER, ID_ARTICLE, CONTRACT, RENTFROM, RENTTO, RETURNFLAG)
			values (:new.ID_CUSTOMER, :new.ID_ARTICLE, :new.CONTRACT, :new.RENTFROM, :new.RENTTO, :new.RETURNFLAG);
		ELSIF cust_state = 'United States' OR cust_state = 'Canada' THEN
			INSERT INTO NYK_RENT@newyork (ID_CUSTOMER, ID_ARTICLE, CONTRACT, RENTFROM, RENTTO, RETURNFLAG)
			values (:new.ID_CUSTOMER, :new.ID_ARTICLE, :new.CONTRACT, :new.RENTFROM, :new.RENTTO, :new.RETURNFLAG);
		ELSE
			RAISE_APPLICATION_ERROR(-21008, 'Invalid customer');
		END IF;
	END IF;
END IF;
IF DELETING THEN
	SELECT state
	INTO cust_state
	FROM customer
	WHERE customer.ID_CUSTOMER = :old.ID_CUSTOMER;
	IF cust_state = 'Germany' OR cust_state = 'Nethderlands' THEN
		DELETE FROM BNN_RENT WHERE ID_ARTICLE = :old.ID_ARTICLE AND ID_CUSTOMER = :old.ID_CUSTOMER AND CONTRACT = :old.CONTRACT;
	ELSIF cust_state = 'United Kingdom' THEN
		DELETE FROM LDN_RENT@london WHERE ID_ARTICLE = :old.ID_ARTICLE AND ID_CUSTOMER = :old.ID_CUSTOMER AND CONTRACT = :old.CONTRACT;
	ELSIF cust_state = 'United States' OR cust_state = 'Canada' THEN
		DELETE FROM NYK_RENT@newyork WHERE ID_ARTICLE = :old.ID_ARTICLE AND ID_CUSTOMER = :old.ID_CUSTOMER AND CONTRACT = :old.CONTRACT;
	ELSE
		RAISE_APPLICATION_ERROR(-21009, 'Invalid customer state');
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
