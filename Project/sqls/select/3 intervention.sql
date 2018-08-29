-- Data una mansione trovare tutti i dispositivi di sicurezza ad essa associati 
SELECT * FROM task_groupn, groupn, device_groupn
WHERE groupn.title = task_groupn.groupn_title 
AND device_groupn.groupn_title = groupn.title 
AND task_groupn.task_name = 'ELETT_05';
