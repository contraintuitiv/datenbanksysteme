#Definieren Sie eine Menge von CREATE TABLE - Statements, welche dem entwickelten relationalen Schema entsprechen. Definieren sie dabei auch sinnvolle Constraints für das Löschen und Aktualisieren von Datensätzen. Führen Sie die CREATE TABLE -Statements auf der PostgreSQL-Datenbank aus.

CREATE TABLE Arzt (
Mitarbeiter_id serial PRIMARY KEY,
name varchar(100) NOT NULL,
fachrichtung varchar(50) NOT NULL,
email_adresse VARCHAR(50) NOT NULL UNIQUE,
Eintrittsdatum DATE DEFAULT CURRENT_DATE,
vorgesetzen_id INT 
DEFAULT NULL
REFERENCES Arzt(Mitarbeiter_id) 
ON UPDATE CASCADE
ON DELELTE SET NULL

);
CREATE INDEX idx_arzt_hierarchie ON Arzt(vorgesetzen_id) using btree;

CREATE TABLE Abteilung (
abteilung_id VARCHAR(20) PRIMARY KEY,
name character(30) NOT NULL UNIQUE,
budget Decimal(12,2) NOT NULL, 
leitung INT ,
Hauptabteilung_id VARCHAR(20),

CONSTRAINT fk_ltng FOREIGN KEY (leitung) 
REFERENCES Arzt(Mitarbeiter_id)
ON DELETE set NULL
ON UPDATE CASCADE,

CONSTRAINT fk_Hauptabteilung FOREIGN KEY (Hauptabteilung_id)
REFERENCES Abteilung(abteilung_id)
ON DELETE SET NULL
ON UPDATE CASCADE
);
CREATE INDEX idx_abteilung_Hauptabteilung ON Abteilung(Hauptabteilung_id) using btree;

CREATE TABLE Abteilung_Zuordnung(
Mitarbeiter_id INT,
Abteilung_id VARCHAR(20),
Zuordnungsdatum DATE DEFAULT CURRENT_DATE,

PRIMARY KEY(Mitarbeiter_id, Abteilung_id),

CONSTRAINT fk_arzt
FOREIGN KEY (Mitarbeiter_id)
REFERENCES arzt(Mitarbeiter_id)
ON DELETE CASCADE,

CONSTRAINT fk_abteilung
FOREIGN KEY (Abteilung_id)
REFERENCES Abteilung(Abteilung_id)
ON DELETE CASCADE
);
CREATE INDEX idx_Abteilungzuordnung ON Abteilung_Zuordnung(Abteilung_id) using btree;

CREATE TABLE Patient (
patient_id VARCHAR(20) NOT NULL PRIMARY KEY,
Name VARCHAR(150) DEFAULT CONCAT('Unbekannt-', TO_CHAR(CURRENT_TIMESTAMP,'YYYY-MM-DD-HH24:MI:SS')) ,
Geburtsdatum TIMESTAMP, 
Geschlecht CHAR(1) CHECK (Geschlecht IN('M','W','D')),
email VARCHAR(50),
telefon VARCHAR(20)

);
CREATE TABLE Behandlung (
Behandlung_id VARCHAR(20) primary key,
patient_id VARCHAR(20) NOT NULL,
Mitarbeiter_id INT NOT NULL,
Zeit TIMESTAMP DEFAULT CURRENT_TIMESTAMP, 
Abteilung_id VARCHAR(20) NOT NULL,
Diagnose Text,
Status VARCHAR(50),

CONSTRAINT fk_bndl_abtl FOREIGN KEY (Abteilung_id)
REFERENCES Abteilung(Abteilung_id)
ON DELETE SET NULL
ON UPDATE CASCADE,

CONSTRAINT fk_arz FOREIGN KEY (Mitarbeiter_id)
REFERENCES Arzt(Mitarbeiter_id)
ON DELETE SET 'DELETED'
ON UPDATE CASCADE,

CONSTRAINT fk_PZNT FOREIGN KEY (patient_id)
REFERENCES Patient(patient_id)
ON DELETE CASCADE
ON UPDATE CASCADE
);
CREATE INDEX idx_Behandlung_Pnt ON Behandlung(Patient_id ) using btree;
CREATE INDEX idx_Behandlung_arz ON Behandlung(Mitarbeiter_id ) using btree;

CREATE TABLE Medikamente (
Med_id VARCHAR(20) NOT NULL Primary key,
Name VARCHAR(100),
Wirkstoff VARCHAR(255),
Dosierung VARCHAR(50)
);
CREATE TABLE MedikamentRezpte (
Med_id VARCHAR(20) NOT NULL,
behandlung_id VARCHAR(20), 
Vorschriebene_Dosierung VARCHAR(50),
Einnahmehaeufigkeit VARCHAR(20),
Dauer_taege VARCHAR(20),
besondere_Anweisung Text,

PRIMARY KEY (behandlung_id, Med_id),

CONSTRAINT fk_med_rzpt
FOREIGN KEY (Med_id)
REFERENCES Medikamente(Med_id)
ON UPDATE CASCADE,

CONSTRAINT fk_behandlung_med
FOREIGN KEY (behandlung_id)
REFERENCES Behandlung(behandlung_id)
ON DELETE CASCADE 
-- NOT SURE for cascading delete when behandlung deleted!
);

CREATE TABLE Geraete (
Seriennummer VARCHAR(50) NOT NULL PRIMARY KEY,
Bezeichnung VARCHAR(100) NOT NULL,
Anschaffungsdatum TIMESTAMP,
Wartungsintervall VARCHAR(20),
Aktuell_Abteilung_id VARCHAR(20), 

CONSTRAINT fk_geraet_abteilung
FOREIGN KEY (Aktuell_abteilung_id)
REFERENCES abteilung(abteilung_id)
ON DELETE SET NULL
ON UPDATE CASCADE
);

