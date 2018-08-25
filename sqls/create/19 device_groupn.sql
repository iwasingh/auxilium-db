CREATE TABLE device_groupn (
  device_name VARCHAR(50) NOT NULL,
  groupn_title CHAR(4) NOT NULL,  
  
  FOREIGN KEY(device_name) REFERENCES device(name)
    ON UPDATE CASCADE
    ON DELETE CASCADE,
  FOREIGN KEY(groupn_title) REFERENCES groupn(title)
    ON UPDATE CASCADE
    ON DELETE CASCADE,

  PRIMARY KEY(device_name, groupn_title)
);
