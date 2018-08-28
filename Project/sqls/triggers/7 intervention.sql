-- Un manutentore non può fare altri interventi (indipendentemente dalla mansione) una volta che ha iniziato un determinato intervento

CREATE OR REPLACE FUNCTION maintainer_is_already_occupied_intervention()
  RETURNS trigger AS $$
    DECLARE
      _intervents record;
    BEGIN
      SELECT maintainer_shift_id INTO _intervents FROM intervention WHERE maintainer_shift_id = NEW.maintainer_shift_id AND end_at IS NULL;
      IF _intervents IS NOT NULL THEN
        RAISE EXCEPTION 'maintainer_is_already_occupied_intervention exception. The maintaner had to finish others intervention first!'
        USING HINT = 'Please check intervetions';
      END IF;
      RETURN NEW;
    END
$$ LANGUAGE 'plpgsql';

CREATE TRIGGER maintainer_is_already_occupied_intervention_trigger
  BEFORE INSERT
  ON intervention
  FOR EACH ROW EXECUTE PROCEDURE maintainer_is_already_occupied_intervention();

