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
-- * (einschlieﬂlich Kommentar)  
--

-- 1.  new customer
-- works
insert into customer(id_customer, company, address, zip, city, state) values((select max(id_customer) from customer)+1, 'Hollow Sword Blade Company', 'Square 1', 'EC1A1AH', 'City of London', 'United Kingdom');

-- 2.  new article / bestellung vom supplier entgegennehmen
-- works
insert into article(id_article, item, type, id_supplier,
	pur_baseprice, pur_currency, pur_purchasedate,
	sal_rentalpricemonth, sal_rentalpriceweek, sal_rentalpriceday, sal_currency,
	id_depot, dep_location, dep_weightkg, dep_heightcm, dep_lengthcm, dep_breadthcm)
values((select max(id_article) from article)+1,'Nova','Wrecking Ball',
1,1,'Euro',sysdate,30,7,1,'Pound',2,10,1,1,1,1);

-- 3.  customer rents article
-- works
insert into rent(id_customer, id_article, contract, rentfrom, rentto, returnflag) values(1,7,(select max(contract) from rent) + 1,sysdate,sysdate + interval '1' day,0);

-- 4.  gibt es eine ausleihe, die bald (in unter einer woche) abl‰uft
SELECT ID_article, item, rentTo
FROM rent NATURAL JOIN article
WHERE ID_customer = 0
AND returnflag = 0
AND rentTo > sysdate
AND RENTTO < sysdate + 7;

-- 5.  customer zieht um
-- works
UPDATE customer
SET address='Platz 1', city='Koblenz', zip=12345
WHERE ID_customer = 1;

-- 6.  customer gibt article zur¸ck
-- works
UPDATE rent
SET returnflag=1
WHERE ID_customer = 1
AND ID_article = 7
AND contract = 1;

-- 7.  aktueller zustand depot (wie viele noch nicht verliehen)
-- works
SELECT TYPE, count(ID_ARTICLE) - (
  SELECT count(ID_ARTICLE)
  FROM article NATURAL JOIN rent
  WHERE RENTFROM < sysdate
  AND RETURNFLAG = 0
) REMAINING
FROM article
GROUP BY TYPE;

-- 8.  ab wann erstes vom article wieder vorhanden
SELECT TYPE, min(RENTTO) AVAILABLE_AT
FROM article NATURAL JOIN rent
WHERE returnFlag = 0
AND RENTFROM < sysdate 
AND RENTTO > sysdate
GROUP BY TYPE;

-- 9.  Gesamtabrechnung fuer Customer 1
SELECT 
  ID_article, TYPE,
  DAYS, DAYS*SAL_RENTALPRICEDAY PRICE_FOR_DAYS,
  WEEKS, WEEKS*SAL_RENTALPRICEWEEK PRICE_FOR_WEEKS,
  MONTHS, MONTHS*SAL_RENTALPRICEMONTH PRICE_FOR_MONTHS,
  DAYS*SAL_RENTALPRICEDAY+WEEKS*SAL_RENTALPRICEWEEK+MONTHS*SAL_RENTALPRICEMONTH TOTAL
FROM(
  SELECT ID_article, SUM(rentTO - rentFROM) DAYS
  FROM rent
  WHERE (rentTO - rentFROM) < 7
  AND ID_customer = 1
  GROUP BY ID_article
) NATURAL JOIN (
  SELECT ID_article, SUM(trunc((rentTO - rentFROM)/7)) WEEKS
  FROM rent
  WHERE (rentTO - rentFROM) < 30
  AND ID_customer = 1
  GROUP BY ID_article
) NATURAL JOIN (
  SELECT ID_article, SUM(trunc((rentTO - rentFROM)/30)) MONTHS
  FROM rent
  WHERE (rentTO - rentFROM) >= 30
  AND ID_customer = 1
  GROUP BY ID_article
) NATURAL JOIN article;

-- 10. Monatliche Einnahmen nach Depot, nach Artikel
SELECT 
  ID_article, TYPE,
  DAYS, DAYS*SAL_RENTALPRICEDAY PRICE_FOR_DAYS,
  WEEKS, WEEKS*SAL_RENTALPRICEWEEK PRICE_FOR_WEEKS,
  MONTHS, MONTHS*SAL_RENTALPRICEMONTH PRICE_FOR_MONTHS,
  DAYS*SAL_RENTALPRICEDAY+WEEKS*SAL_RENTALPRICEWEEK+MONTHS*SAL_RENTALPRICEMONTH TOTAL
FROM(
  SELECT ID_article, SUM(sysdate - rentFROM) DAYS
  FROM rent
  WHERE (rentTO - rentFROM) < 7
  AND extract(month FROM rentFROM) = extract(month FROM sysdate)
  GROUP BY ID_article
) NATURAL JOIN (
  SELECT ID_article, SUM(trunc((sysdate - rentFROM)/7)) WEEKS
  FROM rent
  WHERE (rentTO - rentFROM) < 30
  AND extract(month FROM rentFROM) = extract(month FROM sysdate)
  GROUP BY ID_article
) NATURAL JOIN (
  SELECT ID_article, SUM(trunc((sysdate - rentFROM)/30)) MONTHS
  FROM rent
  WHERE (rentTO - rentFROM) >= 30
  AND extract(month FROM rentFROM) = extract(month FROM sysdate)
  GROUP BY ID_article
) NATURAL JOIN article;

--
-- ***************************************************************
-- * SQL-Befehle mit den Anfragen und Ergebnissen zur Selektion  
-- * der lokalen Datens√§tze (Fragmente) (einschlieﬂlich Kommentar)  
--

-- Bonn
-- customer
-- works
SELECT * FROM customer WHERE state = 'Germany' OR state = 'Netherlands';
-- depot
-- works
SELECT * FROM depot WHERE state = 'Germany';
-- rent
-- works
SELECT r.* FROM rent r inner join customer c on r.ID_customer = c.ID_customer WHERE c.state = 'Germany' OR c.state = 'Netherlands';
-- supplier
-- works
SELECT * FROM supplier;
-- article (resupply)
-- works
SELECT a.ID_article, a.ID_supplier, a.pur_baseprice, a.pur_currency, a.pur_purchasedate FROM article a;
-- article (depotverwaltung)
-- works
SELECT a.ID_article, a.ID_depot, a.dep_location, a.dep_weightkg, a.dep_heightcm, a.dep_lengthcm, a.dep_breadthcm FROM article a inner join depot d on a.ID_depot = d.ID_depot WHERE d.state = 'Germany';
-- article (vermietung)
-- works
SELECT a.ID_article, a.item, a.type, a.sal_rentalpricemonth, a.sal_rentalpriceweek, a.sal_rentalpriceday, a.sal_currency FROM article a inner join depot d on a.ID_depot = d.ID_depot WHERE d.state = 'Germany';

-- London
-- customer
-- works
SELECT * FROM customer WHERE state = 'United Kingdom';
-- depot
-- works
SELECT * FROM depot WHERE state = 'United Kingdom';
-- rent
-- works
SELECT r.* FROM rent r inner join customer c on r.ID_customer = c.ID_customer WHERE c.state = 'United Kingdom';
-- article (depotverwaltung)
-- works
SELECT a.ID_article, a.ID_depot, a.dep_location, a.dep_weightkg, a.dep_heightcm, a.dep_lengthcm, a.dep_breadthcm FROM article a inner join depot d on a.ID_depot = d.ID_depot WHERE d.state = 'United Kingdom';
-- article (vermietung)
-- works
SELECT a.ID_article, a.item, a.type, a.sal_rentalpricemonth, a.sal_rentalpriceweek, a.sal_rentalpriceday, a.sal_currency FROM article a inner join depot d on a.ID_depot = d.ID_depot WHERE d.state = 'United Kingdom';

-- NY
-- customer
-- works
SELECT * FROM customer WHERE state = 'United States' OR state = 'Canada';
-- depot
-- works
SELECT * FROM depot WHERE state = 'USA';
-- rent
-- works
SELECT r.* FROM rent r inner join customer c on r.ID_customer = c.ID_customer WHERE c.state = 'United States' OR c.state = 'Canada';
-- article (depotverwaltung)
-- works
SELECT a.ID_article, a.ID_depot, a.dep_location, a.dep_weightkg, a.dep_heightcm, a.dep_lengthcm, a.dep_breadthcm FROM article a inner join depot d on a.ID_depot = d.ID_depot WHERE d.state = 'USA';
-- article (vermietung)
-- works
SELECT a.ID_article, a.item, a.type, a.sal_rentalpricemonth, a.sal_rentalpriceweek, a.sal_rentalpriceday, a.sal_currency FROM article a inner join depot d on a.ID_depot = d.ID_depot WHERE d.state = 'USA';

--
-- Systemdatum Ende
--
SELECT user, TO_CHAR(SYSDATE, 'dd-mm-yy hh24:mi:ss') 
FROM   dual;  

--
spool off
