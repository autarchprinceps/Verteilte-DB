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

--	Testcases
--	Insert customer
--	* correct
insert into customer values ( null , 'Test' , 'Tettaustraße 1' , '53111' , 'Bonn' , 'Germany' );
--	Insert article
--	* correct
insert into ARTICLE values ( null , 'Test', 'Test' , 1 , 20000.00, 'Euro', to_date('2010-10-23', 'yyyy-mm-dd'), 1004.00, 251.00, 104.00, 'Dollar', 1, 1337, 2721.00, 120.00, 150.00, 200.00);
--	* without correct supplier
insert into ARTICLE values ( null , 'Test', 'Test' , 23 , 20000.00, 'Euro', to_date('2010-10-23', 'yyyy-mm-dd'), 1004.00, 251.00, 104.00, 'Dollar', 2, 1337, 2721.00, 120.00, 150.00, 200.00);
--	* without correct depot
insert into ARTICLE values ( null , 'Test', 'Test' , 1 , 20000.00, 'Euro', to_date('2010-10-23', 'yyyy-mm-dd'), 1004.00, 251.00, 104.00, 'Dollar', 5, 1337, 2721.00, 120.00, 150.00, 200.00);
--	Insert rent
--	* correct
insert into rent values (11, 17, 3, to_date('2017-01-01','yyyy-mm-dd'), to_date('2018-01-01','yyyy-mm-dd'), 0);
--	* without customer
insert into rent values (42, 17, 3, to_date('2017-01-01','yyyy-mm-dd'), to_date('2018-01-01','yyyy-mm-dd'), 0);
--	* without article
insert into rent values (11, 42, 3, to_date('2017-01-01','yyyy-mm-dd'), to_date('2018-01-01','yyyy-mm-dd'), 0);
--	Delete customer
--	* correct
delete from customer where id_customer = 2001;
--	* with existing rent
insert into customer values ( null , 'Test' , 'Tettaustraße 1' , '53111' , 'Bonn' , 'Germany' );
insert into rent values (2011, 17, 1, to_date('2017-01-01','yyyy-mm-dd'), to_date('2018-01-01','yyyy-mm-dd'), 0);
delete from customer where id_customer = 2011;
--	Delete article
--	* correct
delete from article where id_article = 2001;
--	* with existing rent
insert into ARTICLE values ( null , 'Test', 'Test' , 1 , 20000.00, 'Euro', to_date('2010-10-23', 'yyyy-mm-dd'), 1004.00, 251.00, 104.00, 'Dollar', 1, 1337, 2721.00, 120.00, 150.00, 200.00);
insert into rent values (11, 2011, 1, to_date('2017-01-01','yyyy-mm-dd'), to_date('2018-01-01','yyyy-mm-dd'), 0);
delete from article where id_article = 2011;
--	Delete rent
--	* correct
delete from rent where id_customer = 11 and id_article = 17 and contract = 3


-- Aufräumen
delete from rent where rentto = to_date('2018-01-01', 'yyyy-mm-dd');
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
