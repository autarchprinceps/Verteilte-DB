-- ***************************************************************
-- * File Name:                  partition_database.sql          *
-- * File Creator:               Knolle                          *
-- * CreationDate:               19. June 2015                   *
-- *                                                             *
-- * <ChangeLogDate>             <ChangeLogText>                 *
-- ***************************************************************
--
-- ***************************************************************
-- * Verteilte Datenbanken SS 2015
-- * Uebung 7 
-- * Partition
--
-- ***************************************************************
-- * SQL*plus Job Control Section
--
set 	echo 		on
set 	linesize 	256
set 	pagesize 	50
set     escape      \
spool   ./partition_database.log

--
-- Systemdatum Start
--
  SELECT user,
         TO_CHAR(SYSDATE, 'dd-mm-yy hh24:mi:ss') 
  FROM   dual
  ;  
--
-- ***************************************************************
-- * Erstellung der partitionierten Tabellen am Standort Bonn 
--
DROP TABLE 

CREATE TABLE

--
-- ***************************************************************
-- * Einfügung der Beispieldaten 
--
INSERT INTO 

--
-- ***************************************************************
-- * Test der Partitionierung 
--
SELECT

INSERT

DELETE

UPDATE

--
-- ***************************************************************
-- * Experimente mit dem Data Dictionary 
-- * USER_PART_TABLES, USER_TAB_PARTITIONS
--
DESCRIBE

SELECT


--
-- Systemdatum Ende
--
  SELECT user,
         TO_CHAR(SYSDATE, 'dd-mm-yy hh24:mi:ss') 
  FROM   dual
  ;  
--
spool off