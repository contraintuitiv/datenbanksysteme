-- ==========================================================
-- 1. ÄRZTE 
-- ==========================================================
-- IDs werden automatisch 1 bis 12
INSERT INTO Arzt (name, fachrichtung, email_adresse, vorgesetzen_id) VALUES
('Dr. Hans Müller', 'Kardiologie', 'h.mueller@klinik.de', NULL), -- ID 1
('Dr. Sarah Schmidt', 'Neurologie', 's.schmidt@klinik.de', NULL), -- ID 2
('Dr. Elena Fischer', 'Chirurgie', 'e.fischer@klinik.de', NULL), -- ID 3
('Dr. Mark Weber', 'Pädiatrie', 'm.weber@klinik.de', NULL),      -- ID 4
('Dr. Julia Meyer', 'Orthopädie', 'j.meyer@klinik.de', NULL),     -- ID 5
('Dr. Tom Wagner', 'Kardiologie', 't.wagner@klinik.de', 1),       -- ID 6
('Dr. Lisa Becker', 'Neurologie', 'l.becker@klinik.de', 2),       -- ID 7
('Dr. Jan Schulz', 'Chirurgie', 'j.schulz@klinik.de', 3),         -- ID 8
('Dr. Anna Hoffmann', 'Pädiatrie', 'a.hoffmann@klinik.de', 4),    -- ID 9
('Dr. Lars Koch', 'Orthopädie', 'l.koch@klinik.de', 5),          -- ID 10
('Dr. Christian Berg', 'Kardiologie', 'c.berg@klinik.de', 1),     -- ID 11
('Dr. Nina Vogt', 'Chirurgie', 'n.vogt@klinik.de', 3),            -- ID 12
('Dr. Tim Neumann', 'Kardiologie', 't.neumann@klinik.de', 6),      -- ID 13
('Dr. Sophie Lange', 'Kardiologie', 's.lange@klinik.de', 11),     -- ID 14
('Dr. Marc Keller', 'Neurologie', 'm.keller@klinik.de', 7),       -- ID 15
('Dr. Laura Jung', 'Chirurgie', 'l.jung@klinik.de', 8),           -- ID 16
('Dr. Simon Wolf', 'Chirurgie', 's.wolf@klinik.de', 12),          -- ID 17
('Dr. Lea Scholz', 'Pädiatrie', 'l.scholz@klinik.de', 9),         -- ID 18
('Dr. Felix Krämer', 'Orthopädie', 'f.kraemer@klinik.de', 10),    -- ID 19
('Dr. Hanna Voss', 'Kardiologie', 'h.voss@klinik.de', 6),         -- ID 20
('Dr. Erik Horn', 'Chirurgie', 'e.horn@klinik.de', 8),            -- ID 21
('Dr. Mia Bauer', 'Neurologie', 'm.bauer@klinik.de', 7);          -- ID 22
-- ==========================================================
-- 2. ABTEILUNGEN
-- ==========================================================
-- IDs werden automatisch 1 bis 10
INSERT INTO Abteilung (name, budget, leitung, Hauptabteilung_id) VALUES
('Zentrum für Innere Medizin', 1000000.00, 1, NULL), -- ID 1
('Chirurgische Klinik', 1500000.00, 3, NULL),        -- ID 2
('Kardiologie Station A', 400000.00, 6, 1),          -- ID 3
('Kardiologie Station B', 350000.00, 11, 1),         -- ID 4
('Neurologie Sektor', 600000.00, 2, NULL),           -- ID 5
('Unfallchirurgie', 500000.00, 8, 2),                -- ID 6
('Kinderstation', 300000.00, 4, NULL),               -- ID 7
('Orthopädie Praxis', 450000.00, 5, NULL),           -- ID 8
('Gastroenterologie', 280000.00, 1, 1),              -- ID 9
('Notaufnahme', 900000.00, 3, NULL);                 -- ID 10

-- ==========================================================
-- 3. ARZT_ABTEILUNG (n:m Beziehung - Viele Zuweisungen)
-- ==========================================================
INSERT INTO Arzt_Abteilung (Mitarbeiter_id, abteilung_id, Zuordnungsdatum) VALUES
(1, 1, '2023-01-01'), (1, 3, '2023-01-01'), (1, 9, '2023-01-01'), -- Dr. Müller
(6, 3, '2023-02-01'), (11, 4, '2023-02-01'),                     -- Kardiologen
(2, 5, '2023-03-01'), (7, 5, '2023-03-01'), (2, 10, '2023-03-01'), -- Neurologen
(3, 2, '2023-04-01'), (8, 6, '2023-04-01'), (12, 2, '2023-04-01'), -- Chirurgen
(3, 10, '2023-04-01'),                                           -- Fischer in Notaufnahme
(4, 7, '2023-05-01'), (9, 7, '2023-05-01'),                      -- Pädiatrie
(5, 8, '2023-06-01'), (10, 8, '2023-06-01');                     -- Orthopädie

-- ==========================================================
-- 4. PATIENTEN (10 Einträge)
-- ==========================================================
-- IDs 1 bis 10
INSERT INTO Patient (Name, Geburtsdatum, Geschlecht, email) VALUES
('Max Mustermann', '1980-05-12', 'M', 'max@mail.de'),
('Erika Musterfrau', '1992-08-21', 'W', 'erika@mail.de'),
('Alex Doe', '2000-01-01', 'D', 'alex@mail.de'),
('Hans Georg', '1955-11-30', 'M', 'hans@mail.de'),
('Lisa Berg', '1988-03-15', 'W', 'lisa@mail.de'),
('Kevin Schulze', '1995-07-04', 'M', 'kevin@mail.de'),
('Sarah Jung', '2010-12-12', 'W', 'sarah@mail.de'),
('Bernd Brot', '1970-04-01', 'M', 'bernd@mail.de'),
('Maria Kurz', '1963-09-09', 'W', 'maria@mail.de'),
('Chris Cross', '1999-02-28', 'D', 'chris@mail.de');

-- ==========================================================
-- 5. MEDIKAMENTE (10 Einträge)
-- ==========================================================
-- IDs 1 bis 10
INSERT INTO Medikamente (Name, Wirkstoff, Dosierung) VALUES
('Aspirin', 'ASS', '100mg'),        -- 1
('Ibu 600', 'Ibuprofen', '600mg'),  -- 2
('Novalgin', 'Metamizol', '500mg'), -- 3
('Ramipril', 'Ramipril', '5mg'),    -- 4
('Pantozol', 'Pantoprazol', '40mg'), -- 5
('Amoxi', 'Antibiotikum', '1000mg'), -- 6
('Metoprolol', 'Betablocker', '50mg'),-- 7
('Diclo', 'Diclofenac', '75mg'),     -- 8
('Tavor', 'Lorazepam', '1mg'),       -- 9
('Simva', 'Simvastatin', '20mg');    -- 10

-- ==========================================================
-- 6. BEHANDLUNGEN (12 Einträge)
-- ==========================================================
-- IDs 1 bis 12
INSERT INTO Behandlung (patient_id, Mitarbeiter_id, abteilung_id, Diagnose, Status) VALUES
(1, 6, 3, 'Herzrhythmusstörung', 'Abgeschlossen'), -- Pat 1 bei Dr Wagner
(2, 8, 6, 'Trümmerbruch Schienbein', 'Laufend'),    -- Pat 2 bei Dr Schulz
(3, 2, 5, 'Migräne chronisch', 'Abgeschlossen'),   -- Pat 3 bei Dr Schmidt
(4, 1, 1, 'Bluthochdruck', 'Abgeschlossen'),       -- Pat 4 bei Dr Müller
(5, 10, 8, 'Bandscheibenvorfall', 'Laufend'),      -- Pat 5 bei Dr Koch
(6, 4, 7, 'Akute Bronchitis', 'Abgeschlossen'),    -- Pat 6 bei Dr Weber
(7, 12, 2, 'Gallenstein OP', 'Abgeschlossen'),     -- Pat 7 bei Dr Vogt
(8, 3, 10, 'Schnittwunde tief', 'Abgeschlossen'),  -- Pat 8 bei Dr Fischer
(9, 7, 5, 'V.a. Epilepsie', 'Laufend'),            -- Pat 9 bei Dr Becker
(10, 11, 4, 'Herzinsuffizienz', 'Abgeschlossen'),  -- Pat 10 bei Dr Berg
(1, 1, 9, 'Gastritis', 'Laufend'),                 -- Pat 1 wieder bei Dr Müller
(2, 12, 6, 'Nachsorge OP', 'Abgeschlossen'),       -- Pat 2 wieder bei Dr Vogt,
(3, 13, 3, 'Verdacht auf Schlaganfall', 'Laufend'),      -- Dr. Lange
(5, 14, 4, 'Scharlach Infektion', 'Abgeschlossen'),     -- Dr. Kurz
(8, 15, 5, 'Knie-Arthroskopie', 'Abgeschlossen'),       -- Dr. Groß
(2, 16, 1, 'Chronische Gastritis', 'Laufend'),          -- Dr. Frei
(4, 17, 2, 'Blinddarmentzündung', 'Abgeschlossen'),     -- Dr. Stein
(6, 18, 3, 'Multiple Sklerose Schub', 'Laufend'),       -- Dr. Weiß
(9, 19, 4, 'Frühkindliches Asthma', 'Abgeschlossen'),   -- Dr. Jung
(10, 20, 5, 'Hüftdysplasie', 'Abgeschlossen'),          -- Dr. Wolf
(1, 21, 6, 'Allgemeine Vorsorge', 'Abgeschlossen'),     -- Dr. Kraft
(7, 22, 10, 'Röntgen Thorax Befund', 'Laufend'),        -- Dr. Reuter
(3, 12, 2, 'Leberzirrhose', 'Abgeschlossen'),           -- Dr. Vogt
(5, 11, 1, 'Vorhofflimmern', 'Laufend'),                -- Dr. Berg
(2, 15, 8, 'Wirbelbruch', 'Abgeschlossen'),             -- Dr. Groß
(8, 17, 7, 'Leistenbruch', 'Abgeschlossen'),            -- Dr. Stein
(4, 21, 9, 'Grippaler Infekt', 'Abgeschlossen'),        -- Dr. Kraft
(6, 14, 4, 'Mittelohrentzündung', 'Abgeschlossen'),     -- Dr. Kurz
(1, 13, 3, 'Epileptischer Anfall', 'Laufend'),          -- Dr. Lange
(10, 16, 1, 'Eisenmangelanämie', 'Abgeschlossen'),      -- Dr. Frei
(9, 18, 3, 'Gürtelrose', 'Laufend'),                    -- Dr. Weiß
(7, 20, 5, 'Schulterluxation', 'Abgeschlossen');        -- Dr. Wolf

-- ==========================================================
-- 7. BEHANDLUNG_MEDIKAMENTE (Viele Verknüpfungen)
-- ==========================================================
INSERT INTO Behandlung_Medikamente (behandlung_id, Med_id, Vorschriebene_Dosierung) VALUES
(1, 1, '1-0-0'), (1, 7, '1-0-1'), -- Behandlung 1 bekommt Aspirin & Betablocker
(2, 2, '1-1-1'), (2, 5, '1-0-0'), -- Behandlung 2 bekommt Ibu & Pantozol
(3, 3, '0-0-1'), (3, 9, '0-0-1'), -- Behandlung 3 bekommt Novalgin & Tavor
(4, 4, '1-0-0'), (4, 10, '0-0-1'),-- Behandlung 4 bekommt Ramipril & Simva
(6, 6, '1-1-1'),                 -- Behandlung 6 bekommt Amoxi
(7, 2, '1-1-1'), (7, 5, '1-0-0'), -- Behandlung 7 (Galle)
(10, 1, '1-0-0'), (10, 4, '1-0-0'), -- Behandlung 10
(11, 5, '1-0-0');                 -- Behandlung 11