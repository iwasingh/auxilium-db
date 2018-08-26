CREATE TABLE shift (
  id SERIAL PRIMARY KEY,
  shift_date DATE NOT NULL,
  employee_cf CHAR(16) NOT NULL,
  session_id INTEGER NOT NULL,
  hour_start SMALLINT NOT NULL,
  hour_end SMALLINT NOT NULL,

  FOREIGN KEY(employee_cf) REFERENCES employee(cf)
    ON UPDATE CASCADE
    ON DELETE CASCADE,
  FOREIGN KEY(session_id) REFERENCES session(id)
    ON UPDATE CASCADE
    ON DELETE CASCADE,

  UNIQUE(shift_date, employee_cf),
  UNIQUE(shift_date, session_id),

  CHECK(hour_start >= 0 AND hour_start < 24),
  CHECK(hour_end >= 0 AND hour_end < 24),
  CHECK(hour_end > hour_start)
);
