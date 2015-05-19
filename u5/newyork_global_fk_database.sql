-- ***************************************************************
-- * File Name:                  newyork_global_fk_database.sql  *
-- * File Creator:               Knolle                          *
-- * CreationDate:               18. Mai 2015                    *
-- *                                                             *
-- * <ChangeLogDate>             <ChangeLogText>                 *
-- ***************************************************************
--
-- ***************************************************************
-- * Verteilte Datenbanksysteme SS 2015
-- * �bung 5 
-- * Referentielle Integritaet
--
-- ***************************************************************
-- * SQL*plus Job Control Section
--
set 	echo 		on
set 	linesize 	256
set 	pagesize 	50
set     escape      \
spool   ./newyork_global_fk_database.log

--
-- Systemdatum Start
--
  SELECT user,
         TO_CHAR(SYSDATE, 'dd-mm-yy hh24:mi:ss') 
  FROM   dual
  ;  
-- ***************************************************************
-- * Erstellung der referentiellen Integrit�t f�r den 
-- * Standort New York
-- * Anpassung der vorhandenen Trigger aus der Uebung 4 
--

CREATE OR REPLACE TRIGGER ...

--
-- Systemdatum Ende
--
  SELECT user,
         TO_CHAR(SYSDATE, 'dd-mm-yy hh24:mi:ss') 
  FROM   dual
  ;  
--
spool off