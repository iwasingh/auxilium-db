-- Dato un id  = 4 di una risorsa mostrare i suoi figli, esclusa se stessa
WITH RECURSIVE tree AS (
          SELECT resource.id FROM resource WHERE id = 4
          UNION ALL
          SELECT r.id
          FROM resource r JOIN tree p ON p.id = r.parent
        ) SELECT * FROM tree WHERE id != 4

-- Selezionare tutte le risorse che hanno almeno 1 allegato

SELECT * FROM attachment JOIN (
	SELECT n.* FROM resource n
		WHERE NOT EXISTS (
			SELECT r.parent FROM resource r WHERE r.parent = n.id )
) as leaves ON leaves.id = attachment.resource_id 

--
