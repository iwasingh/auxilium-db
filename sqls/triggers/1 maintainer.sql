CREATE TRIGGER shift_overlap_employee_type_trigger
  BEFORE INSERT OR UPDATE
  ON maintainer
  FOR EACH ROW EXECUTE PROCEDURE shift_overlap_employee_type('dispatcher')
