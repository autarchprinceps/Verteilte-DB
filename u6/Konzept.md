# Replikationskonzept
## depot & supplier
Echtzeit: Master(Bonn)-Slave(*)
* Vorteile:
	- Referentielle Integrität über lokale depot & supplier tabelle (für neue article)
		* Echtzeit
	- Seltene Änderungen: Insert kann ruhig zentral in Bonn passieren
		* Einfacher als Master-Master (Kohärenzprotokoll nötig)
## customer, rent & article
Use-Case?:
* Accounting: Snapshot
	- Leicht veraltete Daten akzeptabel
* Häufig Write auch von Bonn aus: Echtzeit Master-Master
* Vielleicht auch verschiedene Verfahren für verschiedene Tabellen
	- z.B. Snapshot für Article (ändert sich seltener) - aber Master-Slave für Rent (immer neuste Billinginformationen)

# Antworten auf Fragen
## 1.1
### c) Warum erscheinen Datensätze in Views nicht mehrfach?
union
### d) Primärschlüsselsequenzen?
?
## 1.2
### b) Änderungshäufigkeit
Täglich, vllt wöchentlich?
### c) Anpassung Views?
?
### d) Warum müssen trigger nicht angepasst werden?
materialized view kümmert sich automatisch um Snapshots für lesenden Zugriff, Trigger sind nur für schreibenden Zugriff (aber schreibender Zugriff durch Snapshots nicht beeinflusst)
