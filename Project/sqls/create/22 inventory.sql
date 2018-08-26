CREATE TABLE inventory (
  nr INTEGER NOT NULL,
  device_name VARCHAR(50) NOT NULL, 
  description TEXT,

  FOREIGN KEY(device_name) REFERENCES device(name)
    ON UPDATE CASCADE
    ON DELETE CASCADE,
    
  PRIMARY KEY(nr, device_name)
);
