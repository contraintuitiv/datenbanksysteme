# Entwickeln Sie ein E-R-Diagramm, das die folgenden Anforderungen an das Datenschema für ein Krankenhaus abbildet. Erläutern Sie das Diagramm im Abnahmegespräch.

- Das Krankenhaus besteht aus verschiedenen Abteilungen (z. B. Innere Medizin, Chirurgie, Radiologie). Abteilungen können Unterabteilungen haben (z. B. Intensivstation unter Innere Medizin). Eine Unterabteilung kann wiederum weitere Unterabteilungen enthalten. Jede Abteilung hat einen eindeutigen Namen und eine Abteilungsleitung sowie ein Budget in EUR.
- Jede Ärztin und jeder Arzt ist einem oder mehreren Abteilungen zugeordnet. Ein Arzt hat eine eindeutige Mitarbeiter-ID, Name, Fachrichtung, E-Mail-Adresse und Eintrittsdatum ins Krankenhaus.
- Jeder Arzt kann einen direkten Vorgesetzten haben (z. B. Oberarzt unter Chefarzt, Assistenzarzt unter Oberarzt, Praktikant unter Assistenzarzt). Ärzte ohne Vorgesetzten sind in der Hierarchie ganz oben (z. B. Chefarzt).
- Jeder Patient hat eine eindeutige Patienten-ID, Name, Geburtsdatum, Geschlecht und Kontaktinformationen. Patienten können Behandlungen in verschiedenen Abteilungen erhalten.
- Jede Behandlung ist einem Patienten, einer Abteilung und einem behandelnden Arzt zugeordnet und hat ein Behandlungsdatum, eine Diagnosebeschreibung und ggf. einen Behandlungsstatus.
- Für jede Behandlung können Medikamente verschrieben werden. Ein Medikament hat eine eindeutige ID, Name, Wirkstoff und Dosierung. Ein Medikament kann bei mehreren Behandlungen eingesetzt werden, und eine Behandlung kann mehrere Medikamente umfassen.
- Jede Abteilung kann Geräte besitzen (z. B. MRT, Beatmungsgeräte). Ein Gerät hat eine eindeutige Seriennummer, Bezeichnung, Anschaffungsdatum und Wartungsintervall. Geräte können zwischen Unterabteilungen verschoben werden.
- Löschen einer Abteilung löscht nicht automatisch die zugeordneten Ärzte oder Patienten; die Zuordnungen können auf „nicht zugeordnet“ gesetzt werden.
- Löschen eines Patienten löscht automatisch alle Behandlungsdatensätze dieses Patienten.
Treffen Sie für die unten aufgeführten Teilaufgaben ggf. eigene sinnvolle Annahmen. Das Ziel der Aufgabe ist es, möglichst viel der obigen Anforderungen direkt im DBMS zu realisieren (z. B. durch rekursive Beziehungen für Unterabteilungen, Teilbehandlungen oder Arzt-Hierarchien) und nicht auszuprogrammieren.

