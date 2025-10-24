# 1: Wie viele Länder sind in der Datenbank enthalten?
`SELECT count(*) FROM country`
Ergebnis: `239`

# 2: Wie viele Sprachen werden weltweit gesprochen?
`SELECT DISTINCT count(language) FROM countrylanguage`
Ergebnis: `984`

# 3: Wie kann man die Namen aller Städte ermitteln, die in Deutschland liegen?
`SELECT name FROM city WHERE countrycode = 'DEU'`

# 4: Wie kann man die Namen und die genaue Anzahl der Einwohner für alle Städte ermitteln, die mehr als 5 Millionen Einwohner haben?
`SELECT name, population FROM city WHERE population > 5000000`

# 5: Wie kann man die Namen aller Städte ermitteln, die mit dem Buchstaben "B" beginnen und in den USA liegen?
`SELECT name FROM city WHERE countrycode = 'USA' AND name LIKE 'B%'`

# 6. Für wie viele Länder liegen keine offiziellen Daten zur Lebenserwartung vor?
`SELECT count(*) FROM country WHERE lifeexpectancy IS NULL`
`17`

# 7. Wie viele Länder haben keine Einwohner?
`SELECT count(*) FROM country WHERE population = 0`
`7`

# 8. Nenne je ein Beispiel für eine am wenigsten und eine am häufigsten gesprochene Amtssprache (isofficial).
```
SELECT language, count(*) FROM countrylanguage WHERE isofficial 
GROUP BY language
ORDER BY count DESC```

most: English, Arabic
least: Tadzhik, Xhosa