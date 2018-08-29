-- Selezionare tutte le risorse che hanno almeno 1 allegato
SELECT * FROM attachment JOIN (
	SELECT n.* FROM resource n
		WHERE NOT EXISTS (
			SELECT r.parent FROM resource r WHERE r.parent = n.id)
) as leaves ON leaves.id = attachment.resource_id;
