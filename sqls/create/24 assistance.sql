CREATE TABLE assistance (
  maintainer_shift_id INTEGER,
  ticket SERIAL PRIMARY KEY,
  start_at TIMESTAMP(0) WITHOUT TIME ZONE NOT NULL,
  end_at TIMESTAMP(0) WITHOUT TIME ZONE,

  FOREIGN KEY(maintainer_shift_id) REFERENCES maintainer(shift_id)
    ON UPDATE CASCADE
    ON DELETE SET NULL,

  CHECK(end_at > start_at)
);
