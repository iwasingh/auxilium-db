-- Data una mansione mostrare tutti i dispositivi di sicurezza

SELECT device_name FROM task_groupn as t, groupn as g, device_groupn as d
	WHERE t.groupn_title = g.title AND d.groupn_title = g.title AND task_name like 'ELETT_05'
