# B1
-- B1: Finde die Titel der Top 10 Stories mit den meisten (count()) direkt zugeordneten, nicht gelöschten (deleted) und nicht toten (dead) Kommentaren.
WITH c AS (
	SELECT count(*), parent
	FROM comments
	WHERE dead=false AND deleted=false
	GROUP BY parent
	ORDER BY count DESC
	LIMIT 10
)
SELECT * FROM c
JOIN stories as s ON c.parent=s.id


# B2