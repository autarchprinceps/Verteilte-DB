-- ***************************************************************
-- * File Name:                  newyork_global_database.sql     *
-- * File Creator:               Knolle                          *
-- * CreationDate:               04. May 2015                    *
-- *                                                             *
-- * <ChangeLogDate>             <ChangeLogText>                 *
-- ***************************************************************
--
-- ***************************************************************
-- * Verteilte Datenbanken SS 2015
-- * Übung 3 
-- * Globales Schema
--
-- ***************************************************************
-- * SQL*plus Job Control Section
--
set 	echo 		on
set 	linesize 	256
set 	pagesize 	50
set     escape      \
spool   ./newyork_global_database.log

--
-- Systemdatum Start
--
  SELECT user,
         TO_CHAR(SYSDATE, 'dd-mm-yy hh24:mi:ss') 
  FROM   dual
  ;  
--
-- ***************************************************************
-- * Das globale Schema fuer den Standort New York  
--

--
-- ***************************************************************
-- * Initialisierung  
--

DROP SYNONYM ...

DROP VIEW ...

DROP DATABASE LINK ...

--
-- ***************************************************************
-- * Erstellung  
--

CREATE DATABASE LINK ...

CREATE VIEW ...

CREATE SYNONYM ...

--
-- ***************************************************************
-- * Test der zehn Anwendungsfaelle  
--

SELECT ...

--
-- Systemdatum Ende
--
  SELECT user,
         TO_CHAR(SYSDATE, 'dd-mm-yy hh24:mi:ss') 
  FROM   dual
  ;  
--
spool off