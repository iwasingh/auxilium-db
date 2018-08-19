CREATE TABLE employee (
    cf VARCHAR(16) PRIMARY KEY,
    name VARCHAR(36),
    surname VARCHAR(36),
    office_id INTEGER,
    FOREIGN KEY (office_id) REFERENCES office(id)
      ON DELETE SET NULL ON UPDATE CASCADE
);
