# Verteilung
## Prädikate
### Horizontal
* depot: state
* customer: state
* supplier: resupply immer von bonn aus
* article: abhängig von depot (Fragment vermietung & depot), in Bonn (Fragment resupply)
* rent: abhängig von customer

### Vertikal
aufteilung von article:
* item, type, sal_ für vermietung
* depot, dep_ für depotverwaltung
* supplier, pur_ für resupply
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
Wir sind davon ausgegangen, dass ein Resupply/Einkauf zentral in Bonn bestimmt wird, daher ist die Tabelle Supplier und das Fragment article_resupply nur dort vorhanden. Ansonsten wird horizontal fragmentiert (mit der Möglichkeit, dass an jedem Standort Zeilen aus jeder Tabelle vorkommen).
