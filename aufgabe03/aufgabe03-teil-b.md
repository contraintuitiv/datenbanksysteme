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

## Laufzeiten B1
-- Materialized Views: Laufzeit 3,161s 
-- gesamt: 27,665s


# B2
-- Finde die Titel der Top 10 Stories mit den meisten (count()) Kommentaren. Benutze die rekursive CTE, um alle Kommentare (inklusive verschachtelte Kommentare) zu zählen.

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



--leicht angepasst läuft 1,5 min.--


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

## Laufzeiten B2
-- Materialized Views: Laufzeit 1:40.853
-- gesamt: timeout nach >10min


# B3

-- Finde die Top 10 Stories mit dem tiefsten Kommentarbaum (maximale Verschachtelungstiefe).

WITH RECURSIVE comment_depth AS 
    -- Anker: Alle Kommentare der ersten Ebene, die direkt auf eine Story verweisen
	(SELECT 
		c.id comment_id,
		s.id root_story_id,
		1 level
	FROM comments2023 c
	JOIN stories2023 s ON c.parent = s.id

	UNION ALL

    -- Rekursion: Alle Kind-Kommentare der nachfolgenden Ebenen
	SELECT c.id comment_id,
	cd.root_story_id,
	cd.level + 1 level
	-- erhöht die Verschachtelungstiefe um 1
	FROM comments2023 c
	JOIN comment_depth cd ON c.parent = cd.comment_id)
SELECT 
	s.title, 
	MAX(cd.level) AS max_depth
	FROM stories2023 s
	JOIN comment_depth cd ON s.id = cd.root_story_id
	GROUP BY s.id, s.title
	ORDER BY max_depth DESC
	LIMIT 10;
```

## Laufzeiten B3
-- Materialized Views: Laufzeit 1:41.252
-- gesamt: nicht versucht..


# B4 
```
WITH RECURSIVE comment_hierarchy AS (
    -- 1. Teil: Finde alle Kommentare, die direkt unter einer Story hängen
    SELECT 
        c.id, 
        c."by" AS user_id, 
        c.parent AS story_id -- Das ist die ID der Story
    FROM comments2023 c
    JOIN stories2023 s ON c.parent = s.id
    UNION ALL
    -- 2. Rekursiver Teil: Finde alle Kinder-Kommentare der bereits gefundenen Kommentare
    SELECT 
        c.id, 
        c."by" AS user_id, 
        ch.story_id -- Wir geben die ursprüngliche Story-ID "nach unten" weiter
    FROM comments2023 c
    JOIN comment_hierarchy ch ON c.parent = ch.id
)
-- 3. Endergebnis: Gruppieren nach Story und Zählen der eindeutigen Nutzer
SELECT 
    s.title, 
    COUNT(DISTINCT ch.user_id) AS unique_commenters
FROM comment_hierarchy ch
JOIN stories2023 s ON ch.story_id = s.id
GROUP BY s.id, s.title
ORDER BY unique_commenters DESC
LIMIT 10;
```

## Laufzeiten B4
-- Materialized Views: Laufzeit 00:01:45.740
-- gesamt: nicht versucht..

Ergebnis:

"title"	"unique_commenters"
"Apple Vision Pro: Apple s first spatial computer"	1557
"OpenAI's board has fired Sam Altman"	1530
"GPT-4"	1347
"Bob Lee  former CTO of Square  has died after being stabbed in San Francisco"	1253
"Ask HN: Most interesting tech you built for just yourself?"	1214
"iPhone 15 and iPhone 15 Plus"	1125
"Joint statement by the Department of the Treasury  Federal Reserve  and FDIC"	1114
"We have reached an agreement in principle for Sam to return to OpenAI as CEO"	1091
"Ask HN: Something you ve done your whole life that you realized is wrong?"	999

