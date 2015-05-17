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

Insert into ARTICLE values ( null , 'Test', 'Test' , 1 , 20000.00, 'Euro', to_date('2010-10-23', 'yyyy-mm-dd'), 1004.00, 251.00, 104.00, 'Dollar', 2, 42, 2721.00, 120.00, 150.00, 200.00);
Insert into ARTICLE values ( null , 'Test', 'Test' , 1 , 20000.00, 'Euro', to_date('2010-10-23', 'yyyy-mm-dd'), 1004.00, 251.00, 104.00, 'Dollar', 2, 42, 2721.00, 120.00, 150.00, 200.00);
Insert into ARTICLE values ( null , 'Test', 'Test' , 2 , 20000.00, 'Euro', to_date('2010-10-23', 'yyyy-mm-dd'), 1004.00, 251.00, 104.00, 'Dollar', 2, 42, 2721.00, 120.00, 150.00, 200.00);
Insert into ARTICLE values ( null , 'Test', 'Test' , 2 , 20000.00, 'Euro', to_date('2010-10-23', 'yyyy-mm-dd'), 1004.00, 251.00, 104.00, 'Dollar', 2, 42, 2721.00, 120.00, 150.00, 200.00);
Insert into ARTICLE values ( null , 'Test', 'Test' , 3 , 20000.00, 'Euro', to_date('2010-10-23', 'yyyy-mm-dd'), 1004.00, 251.00, 104.00, 'Dollar', 2, 42, 2721.00, 120.00, 150.00, 200.00);
Insert into ARTICLE values ( null , 'Test', 'Test' , 3 , 20000.00, 'Euro', to_date('2010-10-23', 'yyyy-mm-dd'), 1004.00, 251.00, 104.00, 'Dollar', 2, 42, 2721.00, 120.00, 150.00, 200.00);


Insert into customer values ( null , 'Test' , 'Tettaustraße 1' , '53111' , 'Bonn' , 'Germany' );
Insert into customer values ( null , 'Test' , 'Tettaustraße 1' , '53111' , 'Bonn' , 'Germany' );
Insert into customer values ( null , 'Test' , '402 Testing Stree' , 'N12 8LY' , 'London' , 'United Kingdom' );
Insert into customer values ( null , 'Test' , '402 Testing Stree' , 'N12 8LY' , 'London' , 'United Kingdom' );
Insert into customer values ( null , 'Test' , '402 Testing Avenue' , 'NY 221012' , 'New York' , 'United States' );

--
-- ***************************************************************
-- * Globale Loeschvorgaenge (idealerweise die oben eingef�gten 
-- * Datensaetze)
--

-- delete r from rent as r natural join customer c where c.company = 'Test';
delete from customer where company = 'Test';
delete from article where item = 'Test';

--
-- Systemdatum Ende
--
  SELECT user,
         TO_CHAR(SYSDATE, 'dd-mm-yy hh24:mi:ss') 
  FROM   dual
  ;  
--
spool off