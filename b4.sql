WITH RECURSIVE comment_hierarchy AS (
    SELECT 
        c.id, 
        c."by" AS user_id, 
        c.parent AS story_id -- Das ist die ID der Story
    FROM comments c
    JOIN stories s ON c.parent = s.id
    UNION ALL
    SELECT 
        c.id, 
        c."by" AS user_id, 
        ch.story_id -- Wir geben die ursprüngliche Story-ID "nach unten" weiter
    FROM comments c
    JOIN comment_hierarchy ch ON c.parent = ch.id
)
SELECT 
    s.title, 
    COUNT(DISTINCT ch.user_id) AS unique_commenters
FROM comment_hierarchy ch
JOIN stories s ON ch.story_id = s.id
GROUP BY s.id, s.title
ORDER BY unique_commenters DESC
LIMIT 10;