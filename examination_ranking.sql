/* Есть таблица examination с двумя полями: id (id абитуриента), scores 
(кол-во набранных баллов дополнительного вступительного испытания от 0 до 100).
Требуется реализовать запрос, который создаёт колонку с позицией абитуриента в общем рейтинге. */

ALTER TABLE examination ADD COLUMN rank_position INT;

UPDATE examination e
SET rank_position = ranked.rank_val
FROM (
    SELECT 
        id,
        DENSE_RANK() OVER (ORDER BY scores DESC) AS rank_val
    FROM 
        examination
) ranked
WHERE e.id = ranked.id;
