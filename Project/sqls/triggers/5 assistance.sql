-- Un manutentore non può fare altre assistenze fino a quando non ha terminato quella presente

CREATE OR REPLACE FUNCTION maintainer_is_already_occupied_assistance()
  RETURNS trigger AS $$
    DECLARE
      _assistances record;
    BEGIN
      SELECT maintainer_shift_id INTO _assistances FROM assistance WHERE maintainer_shift_id = NEW.maintainer_shift_id AND end_at IS NULL;
      IF _assistances IS NOT NULL THEN
        RAISE EXCEPTION 'maintainer_is_already_occupied_assistance exception. The maintaner had to finish others assistance first!'
        USING HINT = 'Please check assistance';
      END IF;
      RETURN NEW;
    END
$$ LANGUAGE 'plpgsql';

CREATE TRIGGER maintainer_is_already_occupied_assistance_trigger
  BEFORE INSERT
  ON assistance
  FOR EACH ROW EXECUTE PROCEDURE maintainer_is_already_occupied_assistance();