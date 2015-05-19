-- ***************************************************************
-- * File Name:                  test_global_fk_database.sql     *
-- * File Creator:               Knolle                          *
-- * CreationDate:               18. Mai 2015                    *
-- *                                                             *
-- * <ChangeLogDate>             <ChangeLogText>                 *
-- ***************************************************************
--
-- ***************************************************************
-- * Verteilte Datenbanksysteme SS 2015
-- * Übung 5 
-- * Referentielle Integritaet
--
-- ***************************************************************
-- * SQL*plus Job Control Section
--
set 	echo 		on
set 	linesize 	256
set 	pagesize 	50
set     escape      \
spool   ./test_global_fk_database.log

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
-- * Globale Einfuegevorgaenge (pro globaler Tabelle)  
--

INSERT INTO ...

--
-- ***************************************************************
-- * Globale Loeschvorgaenge (pro globaler Tabelle)
--

DELETE FROM ...
--
-- ***************************************************************
-- * Globale Aenderungsvorgänge (pro globaler Tabelle)
--

UPDATE SET ...

--
-- Systemdatum Ende
--
  SELECT user,
         TO_CHAR(SYSDATE, 'dd-mm-yy hh24:mi:ss') 
  FROM   dual
  ;  
--
spool off