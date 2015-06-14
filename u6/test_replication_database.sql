-- ***************************************************************
-- * File Name:                  test_replication_database.sql   *
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
spool   ./test_replication_database.log

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

insert into depot values(null, 'test', 'test 1', '12345', 'test', 'Germany');
select * from depot natural join depot@london;

insert into supplier values(null, 'test', 'test 1', '12345', 'test', 'Germany');
select * from supplier natural join supplier@london;

insert into ldn_customer@london values(null, 'test', 'test 1', '12345', 'test', 'United Kingdom');
select * from ldn_customer@london natural join bnn_customer;


--
-- Systemdatum Ende
--
  SELECT user,
         TO_CHAR(SYSDATE, 'dd-mm-yy hh24:mi:ss') 
  FROM   dual
  ;  
--
spool off