
-- Die zweite Abfrage ermittelt, welche Arztgruppe (Chefarzt / Oberarzt / Assistenzarzt) die meisten Behandlungen durchführt.

-- Ermittle rekursiv die Hierarchiebenen
WITH RECURSIVE aerzte_hierarchie AS (
    -- Anker: Alle Ärzte ohne Vorgesetzte (=Chefärzt*innen)
    SELECT
        a.mitarbeiter_id,
        1 hierarchie_ebene
    FROM arzt a
	WHERE vorgesetzen_id IS NULL
    
    UNION ALL
    
    SELECT
        a2.mitarbeiter_id,
        aeh.hierarchie_ebene + 1 hierarchie_ebene 
    FROM arzt a2
    JOIN aerzte_hierarchie aeh ON a2.vorgesetzen_id = aeh.mitarbeiter_id 
) 
SELECT 
	CASE aeh.hierarchie_ebene
		WHEN 1 THEN 'Chefärzt*innen'
		WHEN 2 THEN 'Oberärzt*innen'
		WHEN 3 THEN 'Assistenzärzt*innen'
		ELSE 'Sonstige'
	END AS arzt_kategorie,
	count(*) AS behandlungszahl 
FROM aerzte_hierarchie aeh
JOIN behandlung ON behandlung.mitarbeiter_id = aeh.mitarbeiter_id
GROUP BY aeh.hierarchie_ebene
ORDER BY aeh.hierarchie_ebene
