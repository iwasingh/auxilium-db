CREATE TABLE assistance (
  ticket SERIAL PRIMARY KEY,
  maintainer_shift_id INTEGER,
  start_at TIMESTAMP(0) WITHOUT TIME ZONE NOT NULL,
  end_at TIMESTAMP(0) WITHOUT TIME ZONE,

  FOREIGN KEY(maintainer_shift_id) REFERENCES maintainer(shift_id)
    ON UPDATE CASCADE
    ON DELETE SET NULL,

  -- UNIQUE(maintainer_shift_id, start_at),
  -- handle on trigger, check same date as with shift entity (turno)

  CHECK(end_at > start_at)
);
