# B1
-- B1: Finde die Titel der Top 10 Stories mit den meisten (count()) direkt zugeordneten, nicht gelöschten (deleted) und nicht toten (dead) Kommentaren.
```
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
```


# B2

chatgpt-lösung (läuft unendlich)
```
WITH RECURSIVE comment_tree AS (
    -- Anchor: alle Kommentare, die direkt an Stories hängen
    SELECT
        c.id AS comment_id,
        c.parent AS parent_id,
        s.id AS story_id
    FROM comments2023 c
    JOIN stories2023 s ON c.parent = s.id

    UNION ALL

    -- Rekursion: alle Kinder-Kommentare
    SELECT
        c.id AS comment_id,
        c.parent AS parent_id,
        ct.story_id
    FROM comments2023 c
    JOIN comment_tree ct ON c.parent = ct.comment_id
)
SELECT
    s.title,
    COUNT(ct.comment_id) AS total_comments
FROM stories2023 s
LEFT JOIN comment_tree ct ON s.id = ct.story_id
GROUP BY s.id, s.title
ORDER BY total_comments DESC
LIMIT 10;
```