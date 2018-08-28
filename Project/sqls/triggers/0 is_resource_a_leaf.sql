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
$$ LANGUAGE 'plpgsql';