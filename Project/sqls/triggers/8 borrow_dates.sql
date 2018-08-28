CREATE TRIGGER shift_dates_equalities_borrow_trigger
  BEFORE INSERT OR UPDATE
  ON borrow
  FOR EACH ROW EXECUTE PROCEDURE shift_dates_equalities_function();
