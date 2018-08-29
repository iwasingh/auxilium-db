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
