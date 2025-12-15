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

-- kürzere Laufzeit, weil ich die vorangelegten views verwendet hab.

WITH c AS
(SELECT  count (*), parent 
FROM comments2023
WHERE dead = false AND deleted = false
GROUP BY parent 
ORDER BY count DESC 
LIMIT 10)
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



-- **leicht angepasst läuft 1,5 min.**


WITH RECURSIVE comment_tree AS (
    -- Anker: Alle Kommentare der ersten Ebene, die direkt auf eine Story verweisen
    SELECT
        c.id AS comment_id,
        c.parent AS parent_id,
        s.id AS root_story_id -- Speichere die Story-ID
    FROM comments2023 c
    JOIN stories2023 s ON c.parent = s.id -- c.parent zeigt auf die Story
    
    UNION ALL
    
    -- Rekursion: Alle Kind-Kommentare der nachfolgenden Ebenen
    SELECT
        c.id AS comment_id,
        c.parent AS parent_id,
        ct.root_story_id -- Übernehme die Story-ID vom Vorgänger
    FROM comments2023 c
    JOIN comment_tree ct ON c.parent = ct.comment_id -- c.parent zeigt auf den Kommentar im vorherigen Schritt
)
SELECT
    s.title,
    COUNT(ct.comment_id) AS total_comments
FROM stories2023 s
LEFT JOIN comment_tree ct ON s.id = ct.root_story_id -- Joine mit der finalen Story-ID
GROUP BY s.id, s.title
ORDER BY total_comments DESC
LIMIT 10;
```

# B3


