
WITH RECURSIVE comment_depth AS (
    -- Anker: Alle Kommentare der ersten Ebene, die direkt auf eine Story verweisen
    SELECT
        c.id AS comment_id,
        s.id AS root_story_id,
		1 AS level
       
    FROM comments2023 c 
    JOIN stories2023 s ON c.parent = s.id 
    
    UNION ALL
    
    -- Rekursion: Alle Kind-Kommentare der nachfolgenden Ebenen
    SELECT
        c.id AS comment_id,
        cd.root_story_id,
		cd.level + 1 AS level, 
		--erhöht die Verschachtelungstiefe um 1
		FROM comments2023 c
		JOIN comment_depth cd ON c.parent = cd.comment_id 
		)
		SELECT 
		s.titel, 
		COALESCE(MAX(cd.level), 0) AS max_depth
		FROM stories2023 s
		LEFT JOIN comment_depth cd ON s.id = cd.root_story_id
		GROUp BY s.id, s.title 
		ORDER BY max_depth DESC 
		LIMIT 10;