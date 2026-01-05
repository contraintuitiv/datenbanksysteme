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
