CREATE TABLE message (
  timestamp TIMESTAMP(0) WITHOUT TIME ZONE DEFAULT current_timestamp,
  text TEXT,
  resource_id INTEGER,
  employee_cf CHAR(16),

  FOREIGN KEY (resource_id) REFERENCES resource(id)
    ON UPDATE CASCADE
    ON DELETE CASCADE,
  FOREIGN KEY (employee_cf) REFERENCES employee(cf)
    ON UPDATE CASCADE
    ON DELETE CASCADE, --GDPR Compliant

  PRIMARY KEY(employee_cf, timestamp)
);
