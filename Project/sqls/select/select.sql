 
-- Dato un id = 4 di una risorsa mostrare i suoi figli, esclusa se stessa
WITH RECURSIVE tree AS (
  SELECT resource.id FROM resource WHERE id = 4
  UNION ALL
  SELECT r.id
  FROM resource r JOIN tree p ON p.id = r.parent
) SELECT * FROM tree WHERE id != 4;
-- Selezionare tutte le risorse che hanno almeno 1 allegato
SELECT * FROM attachment JOIN (
	SELECT n.* FROM resource n
		WHERE NOT EXISTS (
			SELECT r.parent FROM resource r WHERE r.parent = n.id)
) as leaves ON leaves.id = attachment.resource_id;
-- Data una mansione trovare tutti i dispositivi di sicurezza ad essa associati 
SELECT * FROM task_groupn, groupn, device_groupn
WHERE groupn.title = task_groupn.groupn_title 
AND device_groupn.groupn_title = groupn.title 
AND task_groupn.task_name = 'ELETT_05';
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
	GROUP BY office_id HAVING COUNT(*) >= ALL (SELECT COUNT(*) FROM employee GROUP BY office_id);
-- Data una mansione mostrare tutti i dispositivi di sicurezza
SELECT device_name FROM task_groupn as t, groupn as g, device_groupn as d
	WHERE t.groupn_title = g.title AND d.groupn_title = g.title AND task_name like 'ELETT_05';
-- Tutte le città che non hanno uffici o che non abbiano avuto più di 1 intervento
SELECT * FROM town WHERE cap IN (
	SELECT town_cap FROM intervention, town WHERE town.cap = intervention.town_cap GROUP BY town_cap HAVING COUNT(*) <= 1
) OR cap NOT IN ( 
	SELECT DISTINCT town_cap FROM office, town WHERE town.cap = office.town_cap
);
SELECT task_name, employee.name, employee.surname FROM (
  SELECT town_cap, shift_date, count(*) as intervention_count
  FROM intervention, shift
  WHERE intervention.maintainer_shift_id = shift.id
  GROUP BY town_cap, shift_date
  ORDER BY intervention_count DESC LIMIT 1
) data, intervention, shift, employee
WHERE intervention.maintainer_shift_id = shift.id
AND shift.employee_cf = employee.cf
AND data.town_cap = intervention.town_cap
AND data.shift_date = shift.shift_date;
CREATE OR REPLACE FUNCTION DATEDIFF (start_t TIMESTAMP, end_t TIMESTAMP)
    RETURNS INT AS $$
  DECLARE
    diff INT = 0;
  BEGIN
    diff = diff + DATE_PART('day', end_t - start_t) * 24;
    diff = diff + DATE_PART('hour', end_t - start_t) * 60;
    diff = diff + DATE_PART('minute', end_t - start_t);
  RETURN diff;
  END;
$$ LANGUAGE plpgsql;

SELECT employee.cf,
  op_intervention.minutes AS time_intervention,
  op_assistance.minutes AS time_assistance,
  op_attendee.minutes AS time_attendee
FROM employee
LEFT JOIN (
  SELECT employee_cf,
    SUM(DATEDIFF(intervention.start_at, intervention.end_at)) AS minutes
  FROM intervention, shift
  WHERE intervention.maintainer_shift_id = shift.id
  AND intervention.end_at IS NOT NULL
  GROUP BY employee_cf
) AS op_intervention ON op_intervention.employee_cf = employee.cf
LEFT JOIN (
  SELECT employee_cf,
    SUM(DATEDIFF(assistance.start_at, assistance.end_at)) AS minutes
  FROM assistance, shift
  WHERE assistance.maintainer_shift_id = shift.id
  AND assistance.end_at IS NOT NULL
  GROUP BY employee_cf
) AS op_assistance ON op_assistance.employee_cf = employee.cf
LEFT JOIN (
  SELECT shift.employee_cf,
    SUM(DATEDIFF(assistance.start_at, assistance.end_at)) AS minutes
  FROM assistance, attendee, shift
  WHERE attendee.assistance_ticket = assistance.ticket
  AND assistance.end_at IS NOT NULL
  AND attendee.dispatcher_shift_id = shift.id
  GROUP BY employee_cf
) AS op_attendee ON op_attendee.employee_cf = employee.cf;
