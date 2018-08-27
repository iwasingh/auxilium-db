-- Tutte le città che non hanno uffici o che non abbiano avuto più di 1 intervento
SELECT * FROM town WHERE cap IN (
	SELECT town_cap FROM intervention, town WHERE town.cap = intervention.town_cap GROUP BY town_cap HAVING COUNT(*) <= 1
) OR cap NOT IN ( 
	SELECT DISTINCT town_cap FROM office, town WHERE town.cap = office.town_cap
);

