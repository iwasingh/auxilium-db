-- Eliminare tutte le città dove non c'è stato neanche un intervento e che non abbiano sedi di riferimento

DELETE FROM town WHERE cap NOT IN (
	SELECT DISTINCT town_cap FROM intervention, town WHERE town.cap = intervention.town_cap
	UNION 
	SELECT DISTINCT town_cap FROM office, town WHERE town.cap = office.town_cap
);
