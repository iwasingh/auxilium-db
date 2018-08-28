CREATE TRIGGER media_is_resource_a_leaf_trigger
  BEFORE INSERT OR UPDATE
  ON attachment
  FOR EACH ROW EXECUTE PROCEDURE is_resource_a_leaf();
