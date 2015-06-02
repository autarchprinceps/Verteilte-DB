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
