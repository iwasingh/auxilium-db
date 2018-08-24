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
)
