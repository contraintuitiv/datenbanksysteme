# C1: Berechnen Sie die Anzahl der Verbrechen pro Tag für die Zeit von Januar 2001 bis August 2024.
# Benutzen Sie den Graph Visualizer von pgAdmin Tool, um die Zeitreihe zu visualisieren. Welchen
# Trend kann man in den Daten erkennen?

select occured::date as day, count(*) from crimes
where occured >= '2001-01-01' AND
occured <= '2024-09-01'
group by day
order by day asc

# C2: Finden Sie die Top-5-Verbrechensorte (block) mit dem höchsten Prozentsatz an Verhaftungen (arrest).
# Als Ergebnis sollen die Location (block) und der dazugehörige Prozentsatz der Verbrechen mit Verhaftung 
# zurückgegeben werden.
select block, count(*) as total,
sum(CASE WHEN arrest=true then 1 ELSE 0 END)/ count(*)::float  As arrest_Percentage
from crimes
group by block
having count(*) > 0
order by 3 desc


# C3: Finden Sie den Wochentag und die Stunde (z. B.: Montag um 15 Uhr), an denen die meisten Verbrechen
# registriert (occured) wurden. Betrachten Sie dafür die Jahre 2020 bis 2023 (inklusive).
select to_char(occured, 'Day') as Weekday,
to_char(occured, 'HH24') as Hour,
count(*) as reg_crimes
from crimes
WHERE occured::date
BETWEEN '2020-01-01'
AND '2024-12-31'
group by weekday, hour
order by 3 desc

# C4: Vergleichen Sie die Zahl der Verbrechen, bei denen eine Verhaftung (arrest) stattgefunden hat, mit
# der Zahl, bei denen keine Verhaftung stattfand, pro Wochentag und Stunde für die Jahre 2010–2020. Als
# Ausgabe soll pro Zeile der Wochentag (Montag, Dienstag, etc...) und die Stunde (00, 01, 02, ...), 
# die Zahl der Verbrechen mit Verhaftung und die Zahl der Verbrechen ohne Verhaftung stehen. Die Zeilen
# sollen nach Wochentag und Stunde sortiert sein. Messen Sie die Zeit die Sie gebraucht haben um die Abfrage
# zu entwickeln.
select to_char(occured, 'Day') AS weekday,
to_char(occured, 'HH24') as hour,
sum(case when arrest = true then 1 else 0 end) as arr_crimes,
sum(case when arrest = false then 1 else 0 end) as not_arr_crimes1
from crimes
WHERE occured::date
BETWEEN '2010-01-01'
AND '2020-12-31'
group by weekday, hour
order by 1,2 asc
/*Es hat etwa 10 Minuten gedaurt ,*/

# C5: Finden Sie den Tag (z.B: 5. October 2014) mit den meisten Verbrechen (occured). Wie viele Fälle mehr
# wurden an diesem Tag registriert im Vergleich zur durchschnittlichen Anzahl der Fälle im gleichen Jahr? 
# Berechnen Sie den Wert in einer Anfrage. Geben Sie alle vier Werte in einer Zeile zurück: (1) Tag, (2) 
# Anzahl der Verbrechen an diesem Tag, (3) durchschnittliche Anzahl der Fälle im gleichen Jahr, (4) 
# prozentualer Unterschied zwischen (2) und (3).

