# A1: Finde heraus, welcher Verbrechenstyp den größten Anstieg in der Anzahl der Verbrechen von Jahr zu Jahr hatte, unabhängig davon, welche zwei aneinanderliegenden Jahre es sind. Gib den Verbrechenstyp, die beiden Jahre und die Anzahl der Verbrechen in beiden Jahren aus.

-- Finde heraus, welcher Verbrechenstyp den größten Anstieg in der Anzahl der Verbrechen
-- von Jahr zu Jahr hatte, unabhängig davon, welche zwei aneinanderliegenden Jahre es sind. 
-- Gib den Verbrechenstyp, die beiden Jahre und die Anzahl der Verbrechen in beiden Jahren aus.

WITH yearly_count AS(
	SELECT primary_type, year,
	COUNT(*) AS crime_count
	FROM crimes
	GROUP BY primary_type, year
),
year_comparison AS
	(SELECT y1.primary_type,
	y1.year as year1,
	y2.year as year2,
	y1.crime_count as crimes_y1,
	y2.crime_count as crimes_y2,
	(y2.crime_count - y1.crime_count ) as increase
	FROM yearly_count as y1 INNER JOIN yearly_count as y2
	ON y1.primary_type = y2.primary_type
	AND y2.year = y1.year + 1)
	
SELECT 
	primary_type,
	year1, 
	year2, 
	crimes_y1, 
	crimes_y2,
	increase
FROM year_comparison
ORDER BY increase DESC
LIMIT 1;

# A2
moving average graph:
```

WITH mycrime AS 
	(SELECT
	occured::date AS daymonth,
	count(*) AS crimes
	FROM crimes
	WHERE occured::date
	BETWEEN '2010-07-30'
	AND '2024-07-30'
	GROUP BY 1 )
SELECT daymonth, crimes,
avg(crimes) OVER ( ) AS all_avg,
avg(crimes) OVER ( ORDER BY
daymonth RANGE BETWEEN '1 month'
PRECEDING AND '1 month' FOLLOWING) as mvg_avg
FROM mycrime
```

# A3 Finde heraus, welche Blöcke (block) in Chicago jedes Jahr mindestens fünf Verbrechen pro Monat hatten. Betrachte die Jahre 2013 bis 2023. Für die ermittelten Blöcke berechne, ob der Trend regr_slope(y, x) für die Anzahl der Verbrechen in diesem Zeitraum steigend oder fallend ist. Überprüfe den Trend mit Graph Visualizer, indem du die Anzahl der Verbrechen für die ermittelten Blöcke pro Monat darstellst.