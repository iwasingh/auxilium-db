CREATE TABLE intervention (
  maintainer_shift_id INTEGER NOT NULL,
  task_name VARCHAR(20) NOT NULL, 
  town_cap CHAR(6) NOT NULL,
  address VARCHAR(40) NOT NULL,
  description TEXT,
  start_at TIMESTAMP(0) WITHOUT TIME ZONE NOT NULL,
  end_at TIMESTAMP(0) WITHOUT TIME ZONE,

  FOREIGN KEY(maintainer_shift_id) REFERENCES maintainer(shift_id)
    ON UPDATE CASCADE
    ON DELETE CASCADE,
  FOREIGN KEY(task_name) REFERENCES task(name)
    ON UPDATE CASCADE
    ON DELETE NO ACTION,
  FOREIGN KEY(town_cap) REFERENCES town(cap)
    ON UPDATE CASCADE
    ON DELETE NO ACTION,

  PRIMARY KEY(maintainer_shift_id, start_at),

  CHECK(end_at > start_at)
);
