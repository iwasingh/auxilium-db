CREATE TRIGGER shift_overlap_employee_maintainer_trigger
  BEFORE INSERT OR UPDATE
  ON maintainer
  FOR EACH ROW EXECUTE PROCEDURE shift_overlap_employee_type('maintainer');

CREATE TRIGGER shift_overlap_employee_dispatcher_trigger
  BEFORE INSERT OR UPDATE
  ON dispatcher
  FOR EACH ROW EXECUTE PROCEDURE shift_overlap_employee_type('dispatcher');