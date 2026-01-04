# A1:
-- Finde heraus, welcher Verbrechenstyp den größten Anstieg in der Anzahl der Verbrechen
-- von Jahr zu Jahr hatte, unabhängig davon, welche zwei aneinanderliegenden Jahre es sind. 
-- Gib den Verbrechenstyp, die beiden Jahre und die Anzahl der Verbrechen in beiden Jahren aus.

with yearly_count AS(
select primary_type, year,
count(*) as crime_count
from crimes
group by primary_type, year
),
year_comparison AS(
select y1.primary_type,
y1.year as year1,
y2.year as year2,
y1.crime_count as crimes_y1,
y2.crime_count as crimes_y2,
(y2.crime_count - y1.crime_count ) as increase
from yearly_count as y1 inner join yearly_count as y2
on y1.primary_type = y2.primary_type
and y2.year = y1.year +1
)
select primary_type,
year1, year2, crimes_y1, crimes_y2
increase
from year_comparison
order by increase desc
limit 1;
# A2: 
Donald Trump behauptet, in Chicago sei die Kriminalität im Aufmarsch und in den letzten
Jahren deutlich gestiegen. Finde heraus, ob das stimmt. Berechne den Trend der 10 häufigsten
Verbrechen in Chicago über alle Jahre. Finde heraus, ob die Zahl der Verbrechen im Durchschnitt
pro Jahr steigt oder fällt, indem du den Graph Visualizer von pgAdmin benutzt. Um die Ausreißer
zu glätten, berechne den gleitenden Durchschnitt über 3 Jahre. Basierend auf den Daten mit
gleitenden Durchschnitt über 3 Jahre finde heraus ob es Verbrechenstypen gibt, bei denen der
Trend eindeutig steigend oder fallend ist -- benutze dafür Lineare Regression - die Funktion regr_slope(y, x).

with highest_crime as (
select primary_type, count(*)
as crime_count
from crimes
group by primary_type
order by crime_count  desc
limit 10
),
yearly_count as(

select c.primary_type, c.year,
count(*) as ycount from crimes c
inner join highest_crime hc
on hc.primary_type = c.primary_type
group by c.primary_type, year
),
moving_avg as(

select primary_type, year,
ycount, avg(ycount)
over (partition by primary_type
order by year
rows between 1 preceding and 1 following)
as moving_avg_y3
from yearly_count

)
select primary_type,
ROUND(regr_slope(moving_avg_y3, year)::numeric, 2) as trend_slope
from moving_avg
group by primary_type
order by 2 desc;


# A3:
Finde heraus, welche Blöcke (block) in Chicago jedes Jahr mindestens fünf Verbrechen pro Monat hatten.
Betrachte die Jahre 2013 bis 2023. Für die ermittelten Blöcke berechne, ob der Trend regr_slope(y, x)
für die Anzahl der Verbrechen in diesem Zeitraum steigend oder fallend ist. Überprüfe den Trend mit 
Graph Visualizer, indem du die Anzahl der Verbrechen für die ermittelten Blöcke pro Monat darstellst.

with monthly_crimes as (

select block,
make_date(
cast(EXTRACT(YEAR FROM occured) AS integer),
cast(EXTRACT(MONTH FROM occured) AS integer),
1
) as month_year,

extract(month from occured) as month,
cast(extract(year from occured)as integer) as year,
count(*) as crime_count
from crimes
where year between 2013 and 2023
group by block,
extract(month from occured),
cast(extract(year from occured) as integer)
),
block_min_crimes as(

select block, year,
min(crime_count) as min_monthly_crime
from monthly_crimes
group by block, year
having min(crime_count) >= 5
),
qualified_blocks as(

select block
from block_min_crimes
group by block
having count(distinct year) = 11
),
block_monthly_data as(
select
mc.block,
mc.month,
mc.crime_count,
CAST(
(EXTRACT(YEAR FROM mc.month_year) - 2013) * 12 + EXTRACT(MONTH FROM mc.month_year)
AS int
) as month_sequence
from monthly_crimes mc
inner join qualified_blocks qb on mc.block = qb.block
)
SELECT
block,
ROUND(CAST(regr_slope(crime_count, month_sequence) AS numeric), 4) as trend_slope,
CASE
WHEN regr_slope(crime_count, month_sequence) > 0 THEN 'steigend'
WHEN regr_slope(crime_count, month_sequence) < 0 THEN 'fallend'
ELSE 'konstant'
END as trend
FROM block_monthly_data
GROUP BY block
ORDER BY ABS(regr_slope(crime_count, month_sequence)) DESC;


for the graph
WITH monthly_crimes AS (
SELECT
block,
DATE_TRUNC('month', occured) as month,
EXTRACT(YEAR FROM occured) as year,
COUNT(*) as crime_count
FROM public.crimes
WHERE occured IS NOT NULL
AND block IS NOT NULL
AND EXTRACT(YEAR FROM occured) BETWEEN 2013 AND 2023
GROUP BY block, DATE_TRUNC('month', occured), EXTRACT(YEAR FROM occured)
),
blocks_with_min_crimes AS (
SELECT
block,
year,
MIN(crime_count) as min_monthly_crimes
FROM monthly_crimes
GROUP BY block, year
HAVING MIN(crime_count) >= 5
),
qualifying_blocks AS (
SELECT block
FROM blocks_with_min_crimes
GROUP BY block
HAVING COUNT(DISTINCT year) = 11
),
block_monthly_data AS (
SELECT
mc.block,
mc.month,
mc.crime_count,
((EXTRACT(YEAR FROM mc.month) - 2013) * 12 + EXTRACT(MONTH FROM mc.month))::integer as month_sequence
FROM monthly_crimes mc
INNER JOIN qualifying_blocks qb ON mc.block = qb.block
),
top_trending_blocks AS (
SELECT
block,
ABS(regr_slope(crime_count, month_sequence)) as abs_slope
FROM block_monthly_data
GROUP BY block
ORDER BY abs_slope DESC
LIMIT 5
)
SELECT
bmd.block,
bmd.month,
bmd.crime_count
FROM block_monthly_data bmd
INNER JOIN top_trending_blocks ttb ON bmd.block = ttb.block
ORDER BY bmd.block, bmd.month;