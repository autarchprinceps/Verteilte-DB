-- ***************************************************************
-- * File Name:                  dbv_uebung_1.sql                *
-- * File Creator:               Knolle                          *
-- * CreationDate:               12. April 2015                  *
-- *                                                             *
-- * <ChangeLogDate>             <ChangeLogText>                 *
-- ***************************************************************
--
-- ***************************************************************
-- * Verteilte Datenbanksysteme SS 2015
-- * Übung 1 
-- * Analysephase - Fragmentierung
--
-- ***************************************************************
-- * SQL*plus Job Control Section
--
set 	echo 		on
set 	linesize 	256
set 	pagesize 	50
set     escape      \
spool   ./dbv_uebung_1.log

--
-- Systemdatum Start
--
  SELECT user,
         TO_CHAR(SYSDATE, 'dd-mm-yy hh24:mi:ss') 
  FROM   dual
  ;  
--
-- ***************************************************************
-- * SQL-Befehle der 10 hypothetischen Datenbankafragen 
-- * (einschließlich Kommentar)  
--

-- Ziel des Befehls
--
-- TODO replace current*
-- 1.  new customer
insert into customer(..) values(..);

-- 2.  new article / bestellung vom supplier entgegennehmen
insert into article(..) values(..);

-- 3.  customer rents article
-- if(article noch nicht ausgeliehen) // wie?
insert into rent(..) values(..);

-- 4.  gibt es eine ausleihe, die bald (in unter einer woche) abläuft
-- works
select a.ID_article, a.item, r.rentTo
from rent r, article a
where r.ID_customer = currentcust and r.ID_article = a.ID_article and r.returnflag = 0 and r.rentTo > sysdate and r.RENTTO < sysdate + 7;

-- 5.  customer zieht um
update customer set street=..,city=.. where ID_customer = currentcust;

-- 6.  customer gibt article zurück
update rent set returnflag=1 where ID_customer = currentcust and ID_article = currentarticle and contract = currentcontract;

-- 7.  aktueller zustand depot (wie viele noch nicht verliehen)
-- works
select b.TYPE, count(b.ID_ARTICLE) - (
  select count(r.ID_ARTICLE)
  from article a, rent r
  where a.TYPE = b.TYPE and a.ID_ARTICLE = r.ID_ARTICLE and r.RENTFROM < sysdate and r.RETURNFLAG = 0
) remaining
from article b
group by b.TYPE;

-- 8.  ab wann erstes vom article wieder vorhanden
-- works
select a.type, min(r.RENTTO)
from article a, rent r
where a.ID_article = r.ID_article and r.returnFlag = 0 and r.RENTFROM < sysdate and r.RENTTO > sysdate
group by a.type;

-- 9.  abrechnung per customer
-- TODO: price month, week, day unterschiedlich
select count(r.ID_article) * a.sal_price
from rent r, article a
where r.ID_article = a.ID_article and extract(month from r.rentFrom) = extract(month from sysdate);

-- 10. profit nach depot
-- TODO: price month, week, day unterschiedlich
select a.type, count(a.ID_article) * a.sal_price
from article a, rent r
where a.ID_article = r.ID_article and ID_depot = currentDepot
group by a.type;

--
-- ***************************************************************
-- * SQL-Befehle mit den Anfragen und Ergebnissen zur Selektion  
-- * der lokalen Datensätze (Fragmente) (einschließlich Kommentar)  
--

-- Fragment xxx für den Standort XXX
--

SELECT ... 
FROM ... 
WHERE
;
-- Fragment yyy für den Standort YYY
--

SELECT ... 
FROM ... 
WHERE
;
-- Fragment zzz für den Standort ZZZ
--

SELECT ... 
FROM ... 
WHERE
;

--
-- Systemdatum Ende
--
  SELECT user,
         TO_CHAR(SYSDATE, 'dd-mm-yy hh24:mi:ss') 
  FROM   dual
  ;  
--
spool off
