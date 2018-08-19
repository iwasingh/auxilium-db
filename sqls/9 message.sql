CREATE TABLE message (
  timestamp TIMESTAMP DEFAULT current_timestamp,
  text TEXT,
  resource_id INTEGER,
  employee_cf VARCHAR(16),
  FOREIGN KEY (resource_id) REFERENCES resource(id),
    ON DELETE SET NULL ON UPDATE CASCADE
  FOREIGN KEY (employee_cf) REFERENCES employee(cf),
    ON DELETE SET NULL ON UPDATE CASCADE

  PRIMARY KEY(employee_cf, timestamp)
);
