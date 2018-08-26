CREATE TABLE borrow (
  maintainer_shift_id INTEGER,
  inventory_nr INTEGER NOT NULL,
  inventory_device_name VARCHAR(50) NOT NULL, 
  motivation TEXT,
  start_at TIMESTAMP(0) WITHOUT TIME ZONE NOT NULL,
  end_at TIMESTAMP(0) WITHOUT TIME ZONE,

  FOREIGN KEY(inventory_nr, inventory_device_name) REFERENCES inventory(nr, device_name)
    ON UPDATE CASCADE
    ON DELETE NO ACTION,
  FOREIGN KEY(maintainer_shift_id) REFERENCES maintainer(shift_id)
    ON UPDATE CASCADE
    ON DELETE SET NULL,

  PRIMARY KEY(inventory_nr, inventory_device_name, start_at),

  CHECK(end_at > start_at)
);
