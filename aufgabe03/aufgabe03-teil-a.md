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