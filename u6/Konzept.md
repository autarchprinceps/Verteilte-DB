# Replikationskonzept
## depot & supplier
Echtzeit: Master(Bonn)-Slave(*)
* Vorteile:
	- Referentielle Integrität über lokale depot & supplier tabelle (für neue article)
		* Echtzeit
	- Seltene Änderungen: Insert kann ruhig zentral in Bonn passieren
		* Einfacher als Master-Master (Kohärenzprotokoll nötig)
## customer, rent & article
Use-Case: Bonn macht analytics: d.h. Read-only, d.h. Master(*)-Slave(Bonn)

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


# Umsetzung
insert:
	depot, supplier:
		bonn:
			gen_id, insert bnn, insert ldn, insert nyk
		ldn/nyk:
			block oder weiterleitung insert_trigger bnn
	customer, rent, article:
		bonn:
			if(state = Deutschland)
				so wie vorher
			else
				weiterleitung an lokale insert_trigger
		ldn/nyk:
			if(state)
				gen_id, insert local, insert bnn
			else
				weiterleitung
update:
	depot, supplier:
		id: block?
		bonn:
			update ldn, nyk, bnn
		ldn/nyk:
			weiterleitung trigger bnn
	customer, rent, article:
		global foreign key?
		id: block?
		if(state changed) //
			migration
				* abhängige Daten müssen auch migriert werden! 
		else
			bonn:
				if(state)
					update local
				else
					weiterleitung globaler oder lokaler trigger?
			ldn,nyk:
				if(state)
					update bnn, update local
				else
					weiterleitung
				
delete:
	depot, supplier:
		bonn:
			delete ldn, delete nyk, delete bnn (global foreign key?)
		ldn/nyk:
			block oder weiterleitung globaler trigger (global foreign key dann lokaler trigger)
	customer, rent, article:
		bonn:
			if(state)
				wie vorher
			else
				weiterleitung globaler trigger
		ldn/nyk:
			if(state)
				wie vorher
			else
				weiterleitung globaler trigger
	
	
