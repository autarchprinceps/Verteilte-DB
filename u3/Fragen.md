# a)
## i. Wieviele Sichten müssen erstellt werden?
Je Standort:
Je eine für jede horizontal fragmentierte Originaltabelle (d.h. bei uns 3)
View/Synonym für nicht fragmentierte Tabellen, die nicht lokal existiert (bei uns: ¬bonn → supplier ^ depot)
## ii. Welche Auswirkungen ergeben sich jeweils für die lokalen Katalogverwaltungen?
Vorteile | Nachteile
---------|----------
Lastverteilte Verwaltung | auch kleinere Änderungen am globalen Schema müssen an allen Standorten durchgeführt werden
Kein SPoF | 

# b)
## i. Diskutieren Sie die Vor- und Nachteile der zentralisierten Katalogverwaltung.
Vorteile | Nachteile
---------|----------
Änderungen des View müssen nur an einer Stelle gemacht werden|SPoF
|Zum Zugriff auf View muss zentrale DB angesprochen werden, die dann unter Umständen eine lokale DB anspricht (doppelte Latenz)
## ii. Welche Auswirkungen ergeben sich jeweils für die Katalogverwaltungen?
?
# c)
## a. Diskutieren Sie die Vor- und Nachteile einer replizierten Katalogverwaltung mittels Sichten gegenüber der zentralisierten Katalogverwaltung mittels Sichten und Synonymen
repliziert | zentralisiert
-----------|--------------
schwer|einfach zu ändern
verteilt|zentral/SPoF

## b. Begründen Sie die von Ihnen favorisierte Variante
Variante 1: Katalogreplizierung, kein SPoF, keine doppelte Latenz, Änderungen an Views eher selten nötig

# d) Anwendungsspezifischer Test Ihrer globalen Datenbank
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
