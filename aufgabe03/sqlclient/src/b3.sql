-- Finde die Top 10 Stories mit dem tiefsten Kommentarbaum (maximale Verschachtelungstiefe).

WITH RECURSIVE comment_depth AS 
    -- Anker: Alle Kommentare der ersten Ebene, die direkt auf eine Story verweisen
	(SELECT 
		c.id comment_id,
		s.id root_story_id,
		1 level
	FROM comments c
	JOIN stories s ON c.parent = s.id

	UNION ALL

    -- Rekursion: Alle Kind-Kommentare der nachfolgenden Ebenen
	SELECT c.id comment_id,
	cd.root_story_id,
	cd.level + 1 level
	-- erhöht die Verschachtelungstiefe um 1
	FROM comments c
	JOIN comment_depth cd ON c.parent = cd.comment_id)
SELECT 
	s.title, 
	MAX(cd.level) AS max_depth
	FROM stories s
	JOIN comment_depth cd ON s.id = cd.root_story_id
	GROUP BY s.id, s.title
	ORDER BY max_depth DESC
	LIMIT 10;