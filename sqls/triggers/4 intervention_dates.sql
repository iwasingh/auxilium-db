CREATE TRIGGER shift_dates_equalities_intervention_trigger
  BEFORE INSERT OR UPDATE
  ON intervention
  FOR EACH ROW EXECUTE PROCEDURE shift_dates_equalities_function();

