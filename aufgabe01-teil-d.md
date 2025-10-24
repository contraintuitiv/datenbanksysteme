# 1: Wie kann man die Menge der Ergebnisspalten im Ergebnis einer SQL-Anfrage beeinflussen?
was hinter `SELECT` steht: `*` alles oder nach Spaltennamen aufzählen.

# 2: Wie wird in einer SQL-Anfrage zwischen Zeichenketten und numerischen Werten unterschieden?
Durch Anführungszeichen '  
string braucht ' 

# 3: Wie wird in SQL ausgedrückt, welche Tabellen in der Datenbank abzufragen sind?
Durch das Schlüsselwort `FROM`

# 4: Wie kann man in SQL mehrere logische Bedingungen kombinieren, die die Anzahl der zurückgegebenen Zeilen beeinflussen?
Mit dem Schlüsselwort `WHERE`. Für die Kombination: `AND`, `OR`, `NOT`

# 5: Wofür steht NULL?
Eine Zelle die kein Wert hat

# 6: Wie kann man in SQL nach Zeichenfolgen suchen, die innerhalb eines Textes vorkommen?
Mit `LIKE` 
z.B. nach ed
```
SELECT * FROM country
WHERE name LIKE '%ed%'
```