/*
* Controllo se un dipendente inserito come manutentore con un particolare shift_id non si ripeta nella tabella other_table
* other_table è un parametro, in modo da generalizzare la function a qualsiasi tabella passata in parametro.
* Per ora le tabelle di interesse sono: 'dispatcher', 'maintainer'
* Vedere sezione Vincoli Aggiuntivi
*/
CREATE OR REPLACE FUNCTION shift_overlap_employee_type ()
  RETURNS trigger AS $$
    DECLARE
      shift_id INTEGER;
      other_table text;
    BEGIN
	  other_table = TG_ARGV[0];
      EXECUTE format('SELECT shift_id FROM %I WHERE shift_id = $1', other_table) INTO shift_id USING NEW.shift_id;
        IF shift_id IS NOT NULL THEN
          RAISE EXCEPTION 'shift_overlap_employee_type(%). id Already exists', other_table
            USING HINT = 'Please check your shift id on tables';
        END IF;
      RETURN NEW;
    END
$$ LANGUAGE 'plpgsql';


