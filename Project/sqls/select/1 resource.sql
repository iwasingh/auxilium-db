-- Dato un id = 4 di una risorsa mostrare i suoi figli, esclusa se stessa
WITH RECURSIVE tree AS (
  SELECT resource.id FROM resource WHERE id = 4
  UNION ALL
  SELECT r.id
  FROM resource r JOIN tree p ON p.id = r.parent
) SELECT * FROM tree WHERE id != 4;
