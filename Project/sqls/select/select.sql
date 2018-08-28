 
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
-- Data una mansione trovare tutti i dispositivi di sicurezza ad essa associati 
SELECT * FROM task_groupn, groupn, device_groupn
WHERE groupn.title = task_groupn.groupn_title AND device_groupn.groupn_title = groupn.title AND task_groupn.task_name = 'ELETT_05'
-- Mostrare tutti i dipendenti che sono stati o solo manutentori o solo centralinisti
(
  SELECT employee_cf FROM shift, dispatcher  WHERE shift.id = dispatcher.shift_id 
  EXCEPT
  SELECT employee_cf FROM shift, maintainer WHERE maintainer.shift_id = id
)
UNION
(
  SELECT employee_cf FROM shift, maintainer WHERE maintainer.shift_id = id
  EXCEPT
  SELECT employee_cf FROM shift, dispatcher WHERE shift.id = dispatcher.shift_id
);

-- Selezionare l'ufficio col maggior numero di dipendenti

SELECT office_id 
	FROM employee 
	GROUP BY office_id HAVING COUNT(*) >= ALL (SELECT COUNT(*) FROM employee GROUP BY office_id)
-- Data una mansione mostrare tutti i dispositivi di sicurezza

SELECT device_name FROM task_groupn as t, groupn as g, device_groupn as d
	WHERE t.groupn_title = g.title AND d.groupn_title = g.title AND task_name like 'ELETT_05'
-- Tutte le città che non hanno uffici o che non abbiano avuto più di 1 intervento
SELECT * FROM town WHERE cap IN (
	SELECT town_cap FROM intervention, town WHERE town.cap = intervention.town_cap GROUP BY town_cap HAVING COUNT(*) <= 1
) OR cap NOT IN ( 
	SELECT DISTINCT town_cap FROM office, town WHERE town.cap = office.town_cap
);

