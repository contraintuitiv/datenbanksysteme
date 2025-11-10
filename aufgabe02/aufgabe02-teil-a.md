
# A1: Finde die Anzahl der Städte pro Land.  

```
SELECT country.name, count(city.*)
FROM country
JOIN city ON city.countrycode = country.code
GROUP BY country.name
ORDER BY country.name

```

# A2: Finde die Anzahl der kleinen Städte (Bevölkerungszahl geringer 10.000) pro Land.


```
SELECT country.name, count(city.*)
FROM country
LEFT OUTER JOIN city ON city.countrycode = country.code AND city.population < 10000
GROUP BY country.name
ORDER BY country.name

```


# A3: Auf welchem Kontinent befinden sich die Länder aus der Aufgabe A2? Erweitern Sie entsprechend die Abfrage A2.
```
SELECT country.name, country.continent, count(city.*)
FROM country
LEFT OUTER JOIN city ON city.countrycode = country.code AND city.population < 10000
GROUP BY country.name, country.continent
ORDER BY country.name
```


# A4: Finde die Namen aller Länder, in denen es weder eine offizielle noch eine andere Sprache gibt.

```
SELECT co.name, lg.language
FROM country co
LEFT OUTER JOIN countrylanguage lg ON co.code = lg.countrycode
WHERE lg.language IS NULL
```


# A5: Finde heraus, welcher Staatschef für die meisten Länder verantwortlich ist und für wie viele.
```
SELECT headofstate, count(*) FROM country
GROUP BY headofstate
ORDER BY count DESC
``` 


# A6: Was ist die meistgesprochene Sprache in dem Land mit der höchsten Lebenserwartung der Welt?
```
SELECT co.name, lg.language, lifeexpectancy, percentage
FROM country co, countrylanguage lg
WHERE co.code = lg.countrycode AND co.lifeexpectancy IS NOT NULL
ORDER BY co.lifeexpectancy DESC, lg.percentage DESC
LIMIT 1
```


# A7: Wieviele Menschen sprechen die zehn Meistgesprochenen sprachen der Welt und welche Sprachen sind es?
```
SELECT lg.language, round(sum(lg.percentage * co.population)) as speakers
FROM countrylanguage lg
JOIN country co ON co.code=lg.countrycode
GROUP BY lg.language
ORDER BY speakers DESC;
```

# A8: Wie lautet der Name der Hauptstadt des Landes mit den meisten inoffziellen Sprachen?
```
-- A8: Wie lautet der Name der Hauptstadt des Landes mit den meisten inoffziellen Sprachen?

SELECT ci.name, count(lg.language)
FROM city ci
JOIN countrylanguage lg ON ci.countrycode=lg.countrycode
JOIN country co ON co.capital=ci.id
WHERE lg.isofficial=false
GROUP BY ci.name
ORDER BY count DESC
LIMIT 5
```

# A9: Bearbeiten Sie die Abfrage A8 so dass es keine LIMIT bzw. ORDER BY Klausel beinhaltet. 

```
SELECT ci.name, count(lg.language)
FROM city ci
JOIN countrylanguage lg ON ci.countrycode=lg.countrycode
JOIN country co ON co.capital=ci.id
WHERE lg.isofficial=false
GROUP BY ci.name
HAVING count(lg.language)=(
	SELECT max(count) FROM (SELECT count(lg.language)
	FROM city ci
	JOIN countrylanguage lg ON ci.countrycode=lg.countrycode
	JOIN country co ON co.capital=ci.id
	WHERE lg.isofficial=false
	GROUP BY ci.name));

```

A10: Welches Land mit welcher Hauptstadt wurde zuerst unabhängig und in welchem Jahr geschah dies?


