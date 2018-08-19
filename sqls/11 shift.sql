CREATE TABLE shift (
  id SERIAL PRIMARY KEY,
  shift_date DATE,
  employee_cf VARCHAR(16),
  session_id INTEGER,
  hour_start SMALLINT,
  hour_end SMALLINT,

  FOREIGN KEY(employee_cf) REFERENCES employee(cf)
    ON DELETE CASCADE ON UPDATE CASCADE,
  
  FOREIGN KEY(session_id) REFERENCES session(id)
    ON DELETE CASCADE ON UPDATE CASCADE,

  UNIQUE(shift_date, employee_cf),
  UNIQUE(shift_date, session_id),

  CHECK(hour_start > 0 AND hour_start < 24),
  CHECK(hour_end > 0 AND hour_ned < 24)
);
