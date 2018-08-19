CREATE TABLE task_groupn (
  task_name VARCHAR(20) NOT NULL,
  groupn_title CHAR(4) NOT NULL,  
  
  FOREIGN KEY(task_name) REFERENCES task(name)
    ON UPDATE CASCADE
    ON DELETE CASCADE,
  FOREIGN KEY(groupn_title) REFERENCES groupn(title)
    ON UPDATE CASCADE
    ON DELETE CASCADE
);
