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
-- * �bung 3 
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

DROP SYNONYM supplier;
DROP SYNONYM depot;

DROP VIEW rent;
DROP VIEW article;
DROP VIEW customer;

DROP DATABASE LINK london;
DROP DATABASE LINK bonn;

--
-- ***************************************************************
-- * Erstellung  
--

CREATE DATABASE LINK london using 'ORACLEDB_LONDON';
CREATE DATABASE LINK bonn using 'ORACLEDB_BONN';

CREATE SYNONYM supplier for supplier@bonn;
CREATE SYNONYM depot for depot@bonn;

CREATE VIEW customer as
select * from ldn_customer@london
union all
select * from bnn_customer@bonn
union all
select * from nyk_customer; 
CREATE VIEW article as
select * from ldn_article@london
union all
select * from bnn_article@bonn
union all
select * from nyk_article;
CREATE VIEW rent as
select * from ldn_rent@london
union all
select * from bnn_rent@bonn
union all
select * from nyk_rent;

--
-- ***************************************************************
-- * Test der zehn Anwendungsfaelle  
--

-- 1.  new customer
-- cannot work
-- insert into customer(id_customer, company, address, zip, city, state) values((select max(id_customer) from customer)+1, 'Hollow Sword Blade Company', 'Square 1', 'EC1A1AH', 'City of London', 'United Kingdom');

-- 2.  new article / bestellung vom supplier entgegennehmen
-- cannot work
-- insert into article(id_article, item, type, id_supplier,
--	pur_baseprice, pur_currency, pur_purchasedate,
--	sal_rentalpricemonth, sal_rentalpriceweek, sal_rentalpriceday, sal_currency,
--	id_depot, dep_location, dep_weightkg, dep_heightcm, dep_lengthcm, dep_breadthcm)
--values((select max(id_article) from article)+1,'Nova','Wrecking Ball',1,1,'Euro',sysdate,30,7,1,'Pound',2,10,1,1,1,1);

-- 3.  customer rents article
-- cannot work
--insert into rent(id_customer, id_article, contract, rentfrom, rentto, returnflag) values(1,7,(select max(contract) from rent) + 1,sysdate,sysdate + interval '1' day,0);

-- 4.  gibt es eine ausleihe, die bald (in unter einer woche) abl�uft
SELECT ID_article, item, rentTo
FROM rent NATURAL JOIN article
WHERE ID_customer = 310
AND returnflag = 0
AND rentTo > sysdate
AND RENTTO < sysdate + 7;

-- 5.  customer zieht um
-- cannot work
-- UPDATE customer
-- SET address='Platz 1', city='Koblenz', zip=12345
-- WHERE ID_customer = 11;

-- 6.  customer gibt article zur�ck
-- cannot work
-- UPDATE rent
-- SET returnflag=1
-- WHERE ID_customer = 11
-- AND ID_article = 17
-- AND contract = 1;

-- 7.  aktueller zustand depot (wie viele noch nicht verliehen)
SELECT TYPE, count(ID_ARTICLE) - (
  SELECT count(ID_ARTICLE)
  FROM article NATURAL JOIN rent
  WHERE RENTFROM < sysdate
  AND RETURNFLAG = 0
  and id_depot = 3
) REMAINING
FROM article
where id_depot = 3
GROUP BY TYPE;

-- 8.  ab wann erstes vom article wieder vorhanden
SELECT TYPE, min(RENTTO) AVAILABLE_AT
FROM article NATURAL JOIN rent
WHERE returnFlag = 0
AND RENTFROM < sysdate 
AND RENTTO > sysdate
and id_depot = 3 -- optimize: use nyk_article ?
GROUP BY TYPE;

-- 9.  Monatsabrechnung für Customer 10
SELECT 
  a.ID_article, a.TYPE,
  nvl(d.DAYS, 0), nvl(d.DAYS, 0) * a.SAL_RENTALPRICEDAY PRICE_FOR_DAYS,
  nvl(w.WEEKS, 0), nvl(w.WEEKS, 0) * a.SAL_RENTALPRICEWEEK PRICE_FOR_WEEKS,
  nvl(m.MONTHS, 0), nvl(m.MONTHS, 0) * a.SAL_RENTALPRICEMONTH PRICE_FOR_MONTHS,
  nvl(d.DAYS, 0) * a.SAL_RENTALPRICEDAY + nvl(w.WEEKS, 0) * a.SAL_RENTALPRICEWEEK + nvl(m.MONTHS, 0) * a.SAL_RENTALPRICEMONTH TOTAL
FROM(
  SELECT a.ID_article, SUM(r.rentto - r.rentFROM) DAYS
  FROM article a left join rent r on a.ID_article = r.ID_article
  WHERE (r.rentTO - r.rentFROM) < 7
  AND extract(month FROM r.rentFROM) = extract(month FROM sysdate)
  and r.ID_customer = 310
  GROUP BY a.ID_article
) d full outer join (
  SELECT a.ID_article, SUM(trunc((r.rentto - r.rentFROM)/7)) WEEKS
  FROM article a left join rent r on a.ID_article = r.ID_article
  WHERE (r.rentTO - r.rentFROM) < 30
  AND extract(month FROM r.rentFROM) = extract(month FROM sysdate)
  and r.ID_customer = 310
  GROUP BY a.ID_article
) w on d.ID_article = w.ID_article
full outer join (
  SELECT a.ID_article, SUM(trunc((r.rentto - r.rentFROM)/30)) MONTHS
  FROM article a left join rent r on a.ID_article = r.ID_article
  WHERE (r.rentTO - r.rentFROM) >= 30
  AND extract(month FROM r.rentFROM) = extract(month FROM sysdate)
  and r.ID_customer = 310
  GROUP BY a.ID_article
) m on w.ID_article = m.ID_article
inner join article a on d.ID_article = a.ID_article or w.ID_article = a.ID_article or m.ID_article = a.ID_article;

-- 10. Monatliche Einnahmen von Depot nach Artikel
SELECT 
  a.ID_article, a.TYPE,
  nvl(d.DAYS, 0), nvl(d.DAYS, 0) * a.SAL_RENTALPRICEDAY PRICE_FOR_DAYS,
  nvl(w.WEEKS, 0), nvl(w.WEEKS, 0) * a.SAL_RENTALPRICEWEEK PRICE_FOR_WEEKS,
  nvl(m.MONTHS, 0), nvl(m.MONTHS, 0) * a.SAL_RENTALPRICEMONTH PRICE_FOR_MONTHS,
  nvl(d.DAYS, 0) * a.SAL_RENTALPRICEDAY + nvl(w.WEEKS, 0) * a.SAL_RENTALPRICEWEEK + nvl(m.MONTHS, 0) * a.SAL_RENTALPRICEMONTH TOTAL
FROM(
  SELECT a.ID_article, SUM(r.rentto - r.rentFROM) DAYS
  FROM article a left join rent r on a.ID_article = r.ID_article
  WHERE (r.rentTO - r.rentFROM) < 7
  AND extract(month FROM r.rentFROM) = extract(month FROM sysdate)
  and a.ID_depot = 3
  GROUP BY a.ID_article
) d full outer join (
  SELECT a.ID_article, SUM(trunc((r.rentto - r.rentFROM)/7)) WEEKS
  FROM article a left join rent r on a.ID_article = r.ID_article
  WHERE (r.rentTO - r.rentFROM) < 30
  AND extract(month FROM r.rentFROM) = extract(month FROM sysdate)
  and a.ID_depot = 3
  GROUP BY a.ID_article
) w on d.ID_article = w.ID_article
full outer join (
  SELECT a.ID_article, SUM(trunc((r.rentto - r.rentFROM)/30)) MONTHS
  FROM article a left join rent r on a.ID_article = r.ID_article
  WHERE (r.rentTO - r.rentFROM) >= 30
  AND extract(month FROM r.rentFROM) = extract(month FROM sysdate)
  and a.ID_depot = 3
  GROUP BY a.ID_article
) m on w.ID_article = m.ID_article
right join article a on d.ID_article = a.ID_article or w.ID_article = a.ID_article or m.ID_article = a.ID_article
where a.ID_depot = 3;

--
-- Systemdatum Ende
--
  SELECT user,
         TO_CHAR(SYSDATE, 'dd-mm-yy hh24:mi:ss') 
  FROM   dual
  ;  
--
spool off
