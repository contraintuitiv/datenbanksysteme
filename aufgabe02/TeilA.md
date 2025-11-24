# A1: Finde die Anzahl der Städte pro Land.
select country.name, count(city.*) from country, city
where code = countrycode
group by country.name
order by country.name


# A2: Finde die Anzahl der kleinen Städte (Bevölkerungszahl geringer 10.000) pro Land.
select country.name, count(city.*) as KleinStaedte from country, city
where city.population < 10000 AND countrycode = code
group by country.name
order by country.name asc

# A3: Auf welchem Kontinent befinden sich die Länder aus der Aufgabe A2? Erweitern Sie entsprechend die Abfrage A2.
select country.name,  country.continent, count(city.*) as KleinStaedte from country, city
where city.population < 10000 AND city.countrycode = country.code
group by country.name, country.continent
order by country.name asc

# A4: Finde die Namen aller Länder, in denen es weder eine offizielle noch eine andere Sprache gibt.
SELECT co.name, lg.language
FROM country co
LEFT OUTER JOIN countrylanguage lg ON co.code = lg.countrycode
WHERE lg.language IS NULL

# A5: Finde heraus, welcher Staatschef für die meisten Länder verantwortlich ist und für wie viele.
select headofstate, count(*) from country
group by headofstate
order by count desc
limit 1

# A6: Was ist die meistgesprochene Sprache in dem Land mit der höchsten Lebenserwartung der Welt?
select country.name, countrylanguage.language,
country.lifeexpectancy, countrylanguage.percentage
from countrylanguage join country
on countrycode = code
where country.lifeexpectancy = (
select max(lifeexpectancy) from country
)
order by countrylanguage.percentage desc
# A7: Wieviele Menschen sprechen die zehn Meistgesprochenen sprachen der Welt und welche Sprachen sind es?
select lg.language, Round(sum(lg.percentage * co.population))
from countrylanguage lg, country co
where countrycode = code
group by lg.language
order by 2 desc
limit 10
# A8: Wie lautet der Name der Hauptstadt des Landes mit den meisten inoffziellen Sprachen?
select co.name, ci.name
from country co join city ci
on ci.id = co.capital
where co.Code = (
select lg.countrycode from countrylanguage lg
where lg.isofficial = false
group by lg.countrycode
order by count(*) desc
limit 1
)

# A9: Bearbeiten Sie die Abfrage A8 so dass es keine LIMIT bzw. ORDER BY Klausel beinhaltet. // nicht richtig beantwortet
select  ci.name, count(lg.*)
from city ci
join countrylanguage lg
on ci.countrycode = lg.countrycode join
country co on ci.id = co.capital
where isofficial= false
group by ci.name
having count(lg.*) > 10

# A10: Welches Land mit welcher Hauptstadt wurde zuerst unabhängig und in welchem Jahr geschah dies?s

select co.name, ci.name
from country co join city ci
on co.capital = ci.id
where co.indepyear =(
select min(indepyear) from country
)