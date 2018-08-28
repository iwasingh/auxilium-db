 
-- Eliminare tutti gli interventi riferiti alla mansione 'ELETT_01'
DELETE FROM intervention WHERE task_name = 'ELETT_01';

-- Eliminare tutti gli allegati che si riferiscono alle risorse che hanno nel titolo la parola 'informazioni'

DELETE FROM attachment WHERE resource_id 
  IN (SELECT resource.id FROM resource WHERE resource.title LIKE '%informazioni%');
-- Eliminare tutte le città dove non c'è stato neanche un intervento e che non abbiano sedi di riferimento

DELETE FROM town WHERE cap NOT IN (
	SELECT DISTINCT town_cap FROM intervention, town WHERE town.cap = intervention.town_cap
	UNION 
	SELECT DISTINCT town_cap FROM office, town WHERE town.cap = office.town_cap
);
