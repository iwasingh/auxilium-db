CREATE TRIGGER task_is_resource_a_leaf_trigger
  BEFORE INSERT OR UPDATE
  ON task
  FOR EACH ROW EXECUTE PROCEDURE is_resource_a_leaf();
