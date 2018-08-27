-- Controllo se le date rientrano nei turni di un specifico dipendente che fa un operazione 
-- Vedere sezione  'Vincoli aggiuntivi'
-- Funzione generica, usata dai triggers per ogni tabella di interesse (es intervention)
CREATE OR REPLACE FUNCTION shift_dates_equalities_function()
  RETURNS trigger AS $$
    DECLARE
      _shift record;
    BEGIN
        IF NEW.start_at IS NOT NULL THEN
        SELECT * INTO _shift FROM shift WHERE id = NEW.maintainer_shift_id
          AND NEW.start_at BETWEEN shift_date + interval '1 hour' * hour_start AND shift_date + interval '1 hour' * hour_end;
        END IF;
  
        IF _shift IS NULL THEN
          RAISE EXCEPTION 'shift_dates_equalities_intervention_function exception. Timestamp not valid for the shift'
          USING HINT = 'Please check your shift dates and the table start_at or end_at timestamps';
        END IF;
  
        IF NEW.end_at IS NOT NULL THEN
          SELECT * INTO _shift FROM shift WHERE id = NEW.maintainer_shift_id
          AND NEW.end_at BETWEEN shift_date + interval '1 hour' * hour_start AND shift_date + interval '1 hour' * hour_end;
        END IF;
        
        IF _shift IS NULL THEN
          RAISE EXCEPTION 'shift_dates_equalities_intervention_function exception. Timestamp not valid for the shift'
          USING HINT = 'Please check your shift dates and the table start_at or end_at timestamps';
        END IF;
      RETURN NEW;
    END
$$ LANGUAGE 'plpgsql';


