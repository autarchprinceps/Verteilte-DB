-- ***************************************************************
-- * File Name:                  test_global_pk_database.sql     *
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
spool   ./test_global_pk_database.log

--
-- Systemdatum Start
--
  SELECT user,
         TO_CHAR(SYSDATE, 'dd-mm-yy hh24:mi:ss') 
  FROM   dual
  ;  
--
-- ***************************************************************
-- * Globales Testskript  
--

--
-- ***************************************************************
-- * Globale Einfuegevorgaenge (pro lakaler Tabelle)  
--

-- **TEST ARCTICLE TABLE INSERTS
--Insert into supplier values ( 1 , 'S�ddeutsche Baumaschinen Handels GmbH' , 'Heinkelstra�e 8' , 'Neu-Ulm' , '89231' , 'Germany' );
--Insert into BNN_ARTICLE values ( null , 'TEST5 Bomag Vibratory Roller - Ride-On - Smooth/Padfoot 48" Drum Width, BW124-3, 6,000 lbs' , 'Vibratory Roller' , 1 , 20000.00, 'Euro', to_date('2010-10-23', 'yyyy-mm-dd'), 1004.00, 251.00, 104.00, 'Dollar', NULL, 39, 2721.00, 120.00, 150.00, 200.00);
--Insert into BNN_ARTICLE values ( null , 'TEST2 Bomag Vibratory Roller - Ride-On - Smooth/Padfoot 48" Drum Width, BW124-3, 6,000 lbs' , 'Vibratory Roller' , 1 , 20000.00, 'Euro', to_date('2010-10-23', 'yyyy-mm-dd'), 1004.00, 251.00, 104.00, 'Dollar', NULL, 40, 2721.00, 120.00, 150.00, 200.00);
--Insert into BNN_ARTICLE values ( null , 'TEST3 Bomag Vibratory Roller - Ride-On - Smooth/Padfoot 48" Drum Width, BW124-3, 6,000 lbs' , 'Vibratory Roller' , 1 , 20000.00, 'Euro', to_date('2010-10-23', 'yyyy-mm-dd'), 1004.00, 251.00, 104.00, 'Dollar', NULL, 41, 2721.00, 120.00, 150.00, 200.00);
Insert into ARTICLE values ( null , 'TEST4 Bomag Vibratory Roller - Ride-On - Smooth/Padfoot 48" Drum Width, BW124-3, 6,000 lbs' , 'Vibratory Roller' , 1 , 20000.00, 'Euro', to_date('2010-10-23', 'yyyy-mm-dd'), 1004.00, 251.00, 104.00, 'Dollar', 2, 42, 2721.00, 120.00, 150.00, 200.00);

-- **TEST CUSTOMER TABLE INSERTS:
--Insert into BNN_customer values ( null , 'Test1 BB Hoch- und Tiefbau GmbH' , 'Tettaustra�e 1' , 'Bonn' , '53111' , 'Germany' );
--Insert into BNN_customer values ( null , 'Test2 BB Hoch- und Tiefbau GmbH' , 'Tettaustra�e 1' , 'Bonn' , '53111' , 'Germany' );
--Insert into BNN_customer values ( null , 'Test3 BB Hoch- und Tiefbau GmbH' , 'Tettaustra�e 1' , 'Bonn' , '53111' , 'Germany' );
--Insert into BNN_customer values ( null , 'Test4 BB Hoch- und Tiefbau GmbH' , 'Tettaustra�e 1' , 'Bonn' , '53111' , 'Germany' );

--Insert into LDN_customer values ( null , 'Test1 BB Hoch- und Tiefbau GmbH' , 'Tettaustra�e 1' , 'Bonn' , '53111' , 'Germany' );
--Insert into LDN_customer values ( null , 'Test2 BB Hoch- und Tiefbau GmbH' , 'Tettaustra�e 1' , 'Bonn' , '53111' , 'Germany' );
--Insert into LDN_customer values ( null , 'Test3 BB Hoch- und Tiefbau GmbH' , 'Tettaustra�e 1' , 'Bonn' , '53111' , 'Germany' );
--Insert into LDN_customer values ( null , 'Test4 BB Hoch- und Tiefbau GmbH' , 'Tettaustra�e 1' , 'Bonn' , '53111' , 'Germany' );


--** TEST IN GLOBAL VIEW INSERTS:
Insert into customer values ( null , 'Test1 BB Hoch- und Tiefbau GmbH' , 'Tettaustra�e 1' , 'Bonn' , '53111' , 'Germany' );

--
-- ***************************************************************
-- * Globale Loeschvorgaenge (idealerweise die oben eingef�gten 
-- * Datensaetze)
--

--DELETE FROM ...

--
-- Systemdatum Ende
--
  SELECT user,
         TO_CHAR(SYSDATE, 'dd-mm-yy hh24:mi:ss') 
  FROM   dual
  ;  
--
spool off