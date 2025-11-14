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