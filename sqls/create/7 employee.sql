CREATE TABLE employee (
  cf CHAR(16) PRIMARY KEY,
  name VARCHAR(30),
  surname VARCHAR(30),
  office_id INTEGER,

  FOREIGN KEY (office_id) REFERENCES office(id)
    ON UPDATE CASCADE
    ON DELETE SET NULL 
);
