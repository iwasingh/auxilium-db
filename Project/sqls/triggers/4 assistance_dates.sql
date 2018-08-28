CREATE TRIGGER shift_dates_equalities_assistance_trigger
  BEFORE INSERT OR UPDATE
  ON assistance
  FOR EACH ROW EXECUTE PROCEDURE shift_dates_equalities_function();

CREATE OR REPLACE FUNCTION dispatcher_shift_equalities_function()
  RETURNS trigger AS $$
    DECLARE
      _shift record;
    BEGIN

      SELECT shift.* INTO _shift FROM shift, assistance WHERE NEW.assistance_ticket = assistance.ticket
        AND shift.id = NEW.dispatcher_shift_id
        AND assistance.start_at BETWEEN shift_date + interval '1 hour' * hour_start AND shift_date + interval '1 hour' * hour_end;
  
      IF _shift IS NULL THEN
        RAISE EXCEPTION 'dispatcher_shift_equalities_function exception. Shift or Timestamp not valid'
        USING HINT = 'Please check your shift dates and the table start_at or end_at timestamps';
      END IF;
  
      SELECT shift.* INTO _shift FROM shift, assistance WHERE NEW.assistance_ticket = assistance.ticket
        AND shift.id = NEW.dispatcher_shift_id
        AND (assistance.end_at IS NULL OR assistance.end_at BETWEEN shift_date + interval '1 hour' * hour_start 
          AND shift_date + interval '1 hour' * hour_end);

      IF _shift IS NULL THEN
        RAISE EXCEPTION 'dispatcher_shift_equalities_function exception. Shift or Timestamp not valid'
        USING HINT = 'Please check your shift dates and the table start_at or end_at timestamps';
      END IF;
      RETURN NEW;
    END
$$ LANGUAGE 'plpgsql';

CREATE TRIGGER dispatcher_shift_equalities_assistance_trigger
  BEFORE INSERT OR UPDATE
  ON attendee
  FOR EACH ROW EXECUTE PROCEDURE dispatcher_shift_equalities_function();