-- Die erste Abfrage ermittelt, in welcher Abteilung – unabhängig von der Hierarchieebene – 
-- die meisten Ärztinnen und Ärzte arbeiten.

-- Abfrage: Zahl der Ärzt*innen pro Abteilung
SELECT abteilung.name, count(*) as zahl_der_aerzte
FROM arzt_abteilung, abteilung
WHERE abteilung.abteilung_id=arzt_abteilung.abteilung_id
GROUP BY arzt_abteilung.abteilung_id, abteilung.name
ORDER BY count(*) DESC;

-- Kombinierte Abfrage, um Abteilung mit meisten Ärzt*innen herauszufinden
SELECT * FROM abteilung 
WHERE abteilung_id=(
	SELECT abteilung_id 
	FROM arzt_abteilung 
	GROUP BY abteilung_id 
	ORDER BY count(*) DESC 
	LIMIT 1);
