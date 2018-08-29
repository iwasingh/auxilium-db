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
