-- Selezionare l'ufficio col maggior numero di dipendenti
SELECT office_id 
	FROM employee 
	GROUP BY office_id HAVING COUNT(*) >= ALL (SELECT COUNT(*) FROM employee GROUP BY office_id);
