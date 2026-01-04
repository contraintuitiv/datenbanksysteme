# C1
```
-- C1: Berechnen Sie die Anzahl der Verbrechen pro Tag für die Zeit von Januar 2001 
-- bis August 2024. Benutzen Sie den Graph Visualizer von pgAdmin Tool, 
-- um die Zeitreihe zu visualisieren. Welchen Trend kann man in den Daten erkennen?


SELECT CAST(occured AS DATE), count(*) FROM crimes 
WHERE occured >= '2001-01-01' AND occured < '2024-09-01'
GROUP BY CAST(occured AS DATE)
ORDER BY occured
```

Zahl sinkt

# C2
```
--- C2: Finden Sie die Top-5-Verbrechensorte (block) mit dem höchsten Prozentsatz an 
--- Verhaftungen (arrest). Als Ergebnis sollen die Location (block) und der 
--- dazugehörige Prozentsatz der Verbrechen mit Verhaftung zurückgegeben werden.

SELECT block, count(*) as total, (sum(CASE WHEN arrest=true THEN 1 ELSE 0 END)::float  / count(*)::float)*100 AS arrestPercentage FROM crimes 
GROUP BY block
ORDER BY total DESC
LIMIT 5


```
Variante (noch nicht funktoiniert)

```

SELECT block, count(*) as total,  ((SELECT count(*) FROM crimes WHERE arrest=true)::float / count(*)::float) as percentage
FROM crimes
GROUP BY block 
ORDER BY total DESC

```


# C3
```
--- C3: Finden Sie den Wochentag und die Stunde (z. B.: Montag um 15 Uhr), an denen die meisten Verbrechen registriert (occured) wurden. 
--- Betrachten Sie dafür die Jahre 2020 bis 2023 (inklusive).

SELECT count(*), TO_CHAR(occured, 'Day HH24') as dayAndHour 
FROM crimes 
WHERE occured >= '2020-01-01' AND occured < '2024-01-01'
GROUP BY dayAndHour
ORDER BY count DESC
```
Sunday at midnight

# C4
/* C4: 	Vergleichen Sie die Zahl der Verbrechen, bei denen eine Verhaftung (arrest) stattgefunden hat, mit der Zahl, 
		bei denen keine Verhaftung stattfand, pro Wochentag und Stunde für die Jahre 2010–2020. Als Ausgabe soll pro Zeile 
		der Wochentag (Montag, Dienstag, etc...) und die Stunde (00, 01, 02, ...), die Zahl der Verbrechen mit Verhaftung 
		und die Zahl der Verbrechen ohne Verhaftung stehen. Die Zeilen sollen nach Wochentag und Stunde sortiert sein. 
		Messen Sie die Zeit die Sie gebraucht haben um die Abfrage zu entwickeln. */
-- 10:15


SELECT TO_CHAR(occured, 'D Dy HH24') as dayAndHour, 
	SUM(CASE WHEN arrest='true' THEN 1 ELSE 0 END) as arrested,
	SUM(CASE WHEN arrest='false' THEN 1 ELSE 0 END) as notArrested
FROM crimes 
WHERE occured >= '2010-01-01' AND occured < '2020-01-01'
GROUP BY dayAndHour
ORDER BY dayAndHour


## C5-Variante mehr an den Folien orientiert

```
SELECT TO_CHAR(occured, 'D Dy HH24') as dayAndHour, 
	count(*) FILTER (WHERE arrest='T') as arrested,
	count(*) FILTER (WHERE arrest='F') as notArrested
FROM crimes 
WHERE occured >= '2010-01-01' AND occured < '2020-01-01'
GROUP BY dayAndHour
ORDER BY dayAndHour

```

-- 10:34 19 Minuten Entwicklungszeit


# C5

```
/* C5: Finden Sie den Tag (z.B: 5. October 2014) mit den meisten Verbrechen (occured). 
 Wie viele Fälle mehr wurden an diesem Tag registriert im Vergleich zur durchschnittlichen Anzahl der 
 Fälle im gleichen Jahr? Berechnen Sie den Wert in einer Anfrage. 
 Geben Sie alle vier Werte in einer Zeile zurück:
 (1) Tag, (2) Anzahl der Verbrechen an diesem Tag, 
 (3) durchschnittliche Anzahl der Fälle im gleichen Jahr, 
 (4) prozentualer Unterschied zwischen (2) und (3). */

WITH 
daycrimes AS 
	(SELECT occured::date AS daymonth, 
	TO_CHAR(occured, 'YYYY') as year, 
	count(*) as amount 
	FROM crimes
	GROUP BY 1, 2),
average AS
	(SELECT avg(amount) as yearaverage, year
	FROM daycrimes
	GROUP BY year)
SELECT 
	daymonth, 
	amount,
	yearaverage, 
	(amount/yearaverage)*100 as percentage
FROM daycrimes
JOIN average ON daycrimes.year=average.year
WHERE amount = (SELECT max(amount) FROM daycrimes)

```