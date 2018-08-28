 
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


/*
* Controllo se la risorsa in questione fa riferimento a un nodo dell'albero di tipo foglia
*/
CREATE OR REPLACE FUNCTION is_resource_a_leaf ()
  RETURNS trigger AS $$
    DECLARE
      resource_tb record;
    BEGIN
      IF NEW.resource_id IS NOT NULL THEN
        SELECT resource.id INTO resource_tb FROM resource WHERE resource.parent = NEW.resource_id;
        IF resource_tb IS NOT NULL THEN
          RAISE EXCEPTION 'is_resource_a_leaf (%). resource_id is not a leaf', NEW.resource_id
            USING HINT = 'Please check your resource table';
        END IF;
      END IF;
      RETURN NEW;
    END
$$ LANGUAGE 'plpgsql';/*
* Controllo se le date rientrano nei turni di un specifico dipendente che fa un operazione 
* Vedere sezione  'Vincoli aggiuntivi'
* Funzione generica, usata dai triggers per ogni tabella di interesse (es intervention)
*/
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
          RAISE EXCEPTION 'shift_dates_equalities_function exception. Timestamp not valid for the shift'
          USING HINT = 'Please check your shift dates and the table start_at or end_at timestamps';
        END IF;
  
        IF NEW.end_at IS NOT NULL THEN
          SELECT * INTO _shift FROM shift WHERE id = NEW.maintainer_shift_id
          AND NEW.end_at BETWEEN shift_date + interval '1 hour' * hour_start AND shift_date + interval '1 hour' * hour_end;
        END IF;
        
        IF _shift IS NULL THEN
          RAISE EXCEPTION 'shift_dates_equalities_function exception. Timestamp not valid for the shift'
          USING HINT = 'Please check your shift dates and the table start_at or end_at timestamps';
        END IF;
      RETURN NEW;
    END
$$ LANGUAGE 'plpgsql';


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


/*
* Controllo se la risorsa in questione fa riferimento a un nodo dell'albero di tipo foglia
*/
CREATE OR REPLACE FUNCTION is_resource_a_leaf ()
  RETURNS trigger AS $$
    DECLARE
      resource_tb record;
    BEGIN
      IF NEW.resource_id IS NOT NULL THEN
        SELECT resource.id INTO resource_tb FROM resource WHERE resource.parent = NEW.resource_id;
        IF resource_tb IS NOT NULL THEN
          RAISE EXCEPTION 'is_resource_a_leaf (%). resource_id is not a leaf', NEW.resource_id
            USING HINT = 'Please check your resource table';
        END IF;
      END IF;
      RETURN NEW;
    END
$$ LANGUAGE 'plpgsql';/*
* Controllo se le date rientrano nei turni di un specifico dipendente che fa un operazione 
* Vedere sezione  'Vincoli aggiuntivi'
* Funzione generica, usata dai triggers per ogni tabella di interesse (es intervention)
*/
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
          RAISE EXCEPTION 'shift_dates_equalities_function exception. Timestamp not valid for the shift'
          USING HINT = 'Please check your shift dates and the table start_at or end_at timestamps';
        END IF;
  
        IF NEW.end_at IS NOT NULL THEN
          SELECT * INTO _shift FROM shift WHERE id = NEW.maintainer_shift_id
          AND NEW.end_at BETWEEN shift_date + interval '1 hour' * hour_start AND shift_date + interval '1 hour' * hour_end;
        END IF;
        
        IF _shift IS NULL THEN
          RAISE EXCEPTION 'shift_dates_equalities_function exception. Timestamp not valid for the shift'
          USING HINT = 'Please check your shift dates and the table start_at or end_at timestamps';
        END IF;
      RETURN NEW;
    END
$$ LANGUAGE 'plpgsql';


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


/*
* Controllo se la risorsa in questione fa riferimento a un nodo dell'albero di tipo foglia
*/
CREATE OR REPLACE FUNCTION is_resource_a_leaf ()
  RETURNS trigger AS $$
    DECLARE
      resource_tb record;
    BEGIN
      IF NEW.resource_id IS NOT NULL THEN
        SELECT resource.id INTO resource_tb FROM resource WHERE resource.parent = NEW.resource_id;
        IF resource_tb IS NOT NULL THEN
          RAISE EXCEPTION 'is_resource_a_leaf (%). resource_id is not a leaf', NEW.resource_id
            USING HINT = 'Please check your resource table';
        END IF;
      END IF;
      RETURN NEW;
    END
$$ LANGUAGE 'plpgsql';/*
* Controllo se le date rientrano nei turni di un specifico dipendente che fa un operazione 
* Vedere sezione  'Vincoli aggiuntivi'
* Funzione generica, usata dai triggers per ogni tabella di interesse (es intervention)
*/
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
          RAISE EXCEPTION 'shift_dates_equalities_function exception. Timestamp not valid for the shift'
          USING HINT = 'Please check your shift dates and the table start_at or end_at timestamps';
        END IF;
  
        IF NEW.end_at IS NOT NULL THEN
          SELECT * INTO _shift FROM shift WHERE id = NEW.maintainer_shift_id
          AND NEW.end_at BETWEEN shift_date + interval '1 hour' * hour_start AND shift_date + interval '1 hour' * hour_end;
        END IF;
        
        IF _shift IS NULL THEN
          RAISE EXCEPTION 'shift_dates_equalities_function exception. Timestamp not valid for the shift'
          USING HINT = 'Please check your shift dates and the table start_at or end_at timestamps';
        END IF;
      RETURN NEW;
    END
$$ LANGUAGE 'plpgsql';


CREATE TRIGGER media_is_resource_a_leaf_trigger
  BEFORE INSERT OR UPDATE
  ON attachment
  FOR EACH ROW EXECUTE PROCEDURE is_resource_a_leaf();
CREATE TRIGGER task_is_resource_a_leaf_trigger
  BEFORE INSERT OR UPDATE
  ON task
  FOR EACH ROW EXECUTE PROCEDURE is_resource_a_leaf();
CREATE TRIGGER shift_overlap_employee_maintainer_trigger
  BEFORE INSERT OR UPDATE
  ON maintainer
  FOR EACH ROW EXECUTE PROCEDURE shift_overlap_employee_type('maintainer');

CREATE TRIGGER shift_overlap_employee_dispatcher_trigger
  BEFORE INSERT OR UPDATE
  ON dispatcher
  FOR EACH ROW EXECUTE PROCEDURE shift_overlap_employee_type('dispatcher');CREATE TRIGGER shift_dates_equalities_assistance_trigger
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
  FOR EACH ROW EXECUTE PROCEDURE dispatcher_shift_equalities_function();-- Un manutentore non può fare altre assistenze fino a quando non ha terminato quella presente

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
  FOR EACH ROW EXECUTE PROCEDURE maintainer_is_already_occupied_assistance();CREATE TRIGGER shift_dates_equalities_intervention_trigger
  BEFORE INSERT OR UPDATE
  ON intervention
  FOR EACH ROW EXECUTE PROCEDURE shift_dates_equalities_function();

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

CREATE TRIGGER shift_dates_equalities_borrow_trigger
  BEFORE INSERT OR UPDATE
  ON borrow
  FOR EACH ROW EXECUTE PROCEDURE shift_dates_equalities_function();
-- Un manutentore non può prendere in prestito un oggetto non ancora restituito.

CREATE OR REPLACE FUNCTION maintainer_borrow_not_available_object()
  RETURNS trigger AS $$
    DECLARE
      _borrow record;
    BEGIN
      SELECT maintainer_shift_id INTO _borrow FROM borrow WHERE maintainer_shift_id = NEW.maintainer_shift_id 
        AND end_at IS NULL AND inventory_nr = NEW.inventory_nr AND inventory_device_name = NEW.inventory_device_name;
      IF _borrow IS NOT NULL THEN
        RAISE EXCEPTION 'maintainer_borrow_not_available_object exception. The Object is not available!'
        USING HINT = 'Please check objects restitution date';
      END IF;
      RETURN NEW;
    END
$$ LANGUAGE 'plpgsql';

CREATE TRIGGER maintainer_borrow_not_available_object_trigger
  BEFORE INSERT
  ON borrow
  FOR EACH ROW EXECUTE PROCEDURE maintainer_borrow_not_available_object();
