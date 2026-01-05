C1: Welche INSERT-Anweisungen kommen vor, und was bedeuten diese?
INSERT INTO bewohner (name, dorfnr, geschlecht, beruf, gold, status) VALUES ('Fremder', 1, '?', '?', 0, '?')
INSERT INTO gegenstand (gegenstand, besitzer) VALUES ('Schwert', 20)
C2: Welche UPDATE-Anweisungen kommen vor, und was bedeuten diese?
1. UPDATE gegenstand SET besitzer = 20 WHERE gegenstand = 'Kaffeetasse'
2. UPDATE gegenstand SET besitzer = 20 WHERE besitzer is null
3. update gegenstand
set besitzer = 15
where gegenstand = 'Ring' or gegenstand = 'Teekanne';
4. UPDATE bewohner SET gold = gold + 120 WHERE bewohnernr = 20;
5. Update bewohner
   set name = 'Bob' where name = 'Fremder';
6. UPDATE bewohner SET gold = gold + 100 - 150 WHERE bewohnernr = 20
7. UPDATE bewohner SET status = 'friedlich' WHERE bewohnernr = 8;
8. UPDATE bewohner SET status = 'friedlich' WHERE bewohnernr = 8;
C3: Welche DELETE-Anweisungen kommen vor, und was bedeuten diese?
   DELETE FROM bewohner WHERE name = 'Dirty Dieter'
   DELETE FROM bewohner WHERE GESCHlecht = 'w'