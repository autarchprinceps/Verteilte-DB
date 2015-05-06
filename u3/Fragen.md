# a)
## i.
Je Standort:
Je eine für jede horizontal fragmentierte Originaltabelle (d.h. bei uns 3)
View/Synonym für nicht fragmentierte Tabellen, die nicht lokal existiert (bei uns: ¬bonn → supplier ^ depot)
## ii.
Vorteile | Nachteile
---------|----------
Lastverteilte Verwaltung | auch kleinere Änderungen am globalen Schema müssen an allen Standorten durchgeführt werden
Kein SPoF | 

# b)
## i.
Vorteile | Nachteile
---------|----------
Änderungen des View müssen nur an einer Stelle gemacht werden|SPoF
|Zum Zugriff auf View muss zentrale DB angesprochen werden, die dann unter Umständen eine lokale DB anspricht (doppelte Latenz)
## ii.
?
# c)
## a.
repliziert | zentralisiert
-----------|--------------
schwer|einfach zu ändern
verteilt|zentral/SPoF

## b.
Variante 1: Katalogreplizierung, kein SPoF, keine doppelte Latenz, Änderungen an Views eher selten nötig

# d)
## Use-Cases
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

## i. Welche Use-Cases funktionieren auch lokal?
4., 7., 8., 9., 10.

## ii. Welche Use-Cases zeigen zu wenig Daten an?
## iii. Welche Use-Cases erzeugen Fehlermeldungen?
Insert, Update funktionieren nicht auf Views: 1., 2., 3., 5., 6.
