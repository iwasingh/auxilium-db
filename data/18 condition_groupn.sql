CREATE TABLE condition_groupn (
  condition_name VARCHAR(20) NOT NULL,
  groupn_title CHAR(4) NOT NULL,  
  
  FOREIGN KEY(condition_name) REFERENCES condition(name)
    ON UPDATE CASCADE
    ON DELETE CASCADE,
  FOREIGN KEY(groupn_title) REFERENCES groupn(title)
    ON UPDATE CASCADE
    ON DELETE CASCADE
);
