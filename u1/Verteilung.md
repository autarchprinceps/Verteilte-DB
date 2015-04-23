# Verteilung
## Prädikate
### horizontal
depot: state
customer: state
supplier: resupply immer von bonn aus
article: abhängig von depot
rent: abhängig von customer
### vertical
aufteilung von article:
item, type, sal_* für vermietung
depot, dep_* für depotverwaltung
supplier, pur_* für resupply
## a. 10 hypothetische Anfrage
1.  new customer
2.  new article / bestellung vom supplier entgegennehmen
3.  customer rents article
4.  customer sucht alle rents (gibt es eine ausleihe, die bald abläuft)
5.  customer zieht um
6.  customer gibt article zurück
7.  aktueller zustand depot (wie viele noch nicht verliehen)
8.  ab wann erstes vom article wieder vorhanden
9.  abrechnung per customer
10. umsatz nach depot
## b.
Ja, alle Tabellen sollten an allen drei Standorten vorhanden sein.
Alle Datensätze können direkt oder abhängig von Daten, auf die sie mit einem Fremdschlüssel verweisen, einem Standort zugeordnet werden.
Keine Datensätze sind standortunabhängig.

# Fragen

sql-Implementierung auch für vertical? select a,b,c from ...

verkaufskonzept priceMonth, priceWeek, priceDay ?! wie implementieren
currencyumrechnung ?!

# TODO
SQL fertig
JOIN
