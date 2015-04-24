SET 	echo on
SET 	linesize 	256
SET 	pagesize 	50
SET   escape      \
spool   ./dbv_uebung_1.log

SELECT user, TO_CHAR(SYSDATE, 'dd-mm-yy hh24:mi:ss') 
FROM   dual;  

--
-- ***************************************************************
-- * SQL-Befehle der 10 hypothetischen Datenbankafragen 
-- * (einschließlich Kommentar)  
--

-- 1.  new customer
insert into customer(..) values(..);

-- 2.  new article / bestellung vom supplier entgegennehmen
insert into article(..) values(..);

-- 3.  customer rents article
-- if(article noch nicht ausgeliehen) // wie?
insert into rent(..) values(..);

-- 4.  gibt es eine ausleihe, die bald (in unter einer woche) abläuft
SELECT ID_article, item, rentTo
FROM rent NATURAL JOIN article
WHERE ID_customer = 0
AND returnflag = 0
AND rentTo > sysdate
AND RENTTO < sysdate + 7;

-- 5.  customer zieht um
UPDATE customer
SET street='Straße 1', city='Koblenz'
WHERE ID_customer = 0;

-- 6.  customer gibt article zur�ck
UPDATE rent
SET returnflag=1
WHERE ID_customer = currentcust
AND ID_article = currentarticle
AND contract = currentcontract;

-- 7.  aktueller zustAND depot (wie viele noch nicht verliehen)
SELECT a.TYPE, count(a.ID_ARTICLE) - (
  SELECT count(ID_ARTICLE)
  FROM article NATURAL JOIN rent
  WHERE RENTFROM < sysdate
  AND RETURNFLAG = 0
) REMAINING
FROM article a
GROUP BY a.TYPE;

-- 8.  ab wann erstes vom article wieder vORhANDen
SELECT TYPE, min(RENTTO) AVAILABLE_AT
FROM article NATURAL JOIN rent
WHERE returnFlag = 0
AND RENTFROM < sysdate 
AND RENTTO > sysdate
GROUP BY TYPE;

-- 9.  Monatliche Abrechnung fuer Customer, Annahme: immer gleiche Waehrung
-- TODO: price month, week, day unterschiedlich
SELECT ID_customer, extract(month FROM sysdate) MONTH, sum(sal_rentalPriceMonth) COST
FROM rent NATURAL JOIN article
WHERE extract(month FROM rentFROM) = extract(month FROM sysdate)
--AND ID_customer = 1
GROUP BY ID_customer;

-- 10. Monatlicher Profit nach Depot, Annahme: immer gleiche Waehrung
-- TODO: price month, week, day unterschiedlich
SELECT type, sum(sal_rentalPriceMonth) PROFIT
FROM article NATURAL JOIN rent
--WHERE AND ID_depot = currentDepot
GROUP BY type;

--
-- ***************************************************************
-- * SQL-Befehle mit den Anfragen und Ergebnissen zur Selektion  
-- * der lokalen Datensätze (Fragmente) (einschließlich Kommentar)  
--

-- TODO check article wildcard
-- Bonn
-- customer
SELECT * FROM customer WHERE state = 'Germany' OR state = 'NetherlANDs';
-- depot
SELECT * FROM depot WHERE state = 'Germany';
-- rent
SELECT r.* FROM rent r inner join customer c on r.ID_customer = c.ID_customer WHERE c.state = 'Germany' OR c.state = 'NetherlANDs';
-- supplier
SELECT * FROM supplier;
-- article (resupply)
SELECT a.ID_article, a.ID_supplier, a.pur_* FROM article a;
-- article (depotverwaltung)
SELECT a.ID_article, a.ID_depot, a.dep_* FROM article a inner join depot d on a.ID_depot = d.ID_depot WHERE d.state = 'Germany';
-- article (vermietung)
SELECT a.ID_article, a.item, a.type, a.sal_* FROM article a inner join depot d on a.ID_depot = d.ID_depot WHERE d.state = 'Germany';

-- London
-- customer
SELECT * FROM customer WHERE state = 'United Kingdom';
-- depot
SELECT * FROM depot WHERE state = 'United Kingdom';
-- rent
SELECT r.* FROM rent r inner join customer c on r.ID_customer = c.ID_customer WHERE c.state = 'United Kingdom';
-- article (depotverwaltung)
SELECT a.ID_article, a.ID_depot, a.dep_* FROM article a inner join depot d on a.ID_depot = d.ID_depot WHERE d.state = 'United Kingdom';
-- article (vermietung)
SELECT a.ID_article, a.item, a.type, a.sal_* FROM article a inner join depot d on a.ID_depot = d.ID_depot WHERE d.state = 'United Kingdom';

-- NY
-- customer
SELECT * FROM customer WHERE state = 'United States' OR state = 'Canada';
-- depot
SELECT * FROM depot WHERE state = 'USA';
-- rent
SELECT r.* FROM rent r inner join customer c on r.ID_customer = c.ID_customer WHERE c.state = 'United States' OR c.state = 'Canada';
-- article (depotverwaltung)
SELECT a.ID_article, a.ID_depot, a.dep_* FROM article a inner join depot d on a.ID_depot = d.ID_depot WHERE d.state = 'USA';
-- article (vermietung)
SELECT a.ID_article, a.item, a.type, a.sal_* FROM article a inner join depot d on a.ID_depot = d.ID_depot WHERE d.state = 'USA';

--
-- Systemdatum Ende
--
SELECT user, TO_CHAR(SYSDATE, 'dd-mm-yy hh24:mi:ss') 
FROM   dual;  

--
spool off
