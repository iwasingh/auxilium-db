CREATE TABLE media (
  id INTEGER PRIMARY KEY AUTO INCREMENT,
  source VARCHAR(30),
  typology_type VARCHAR(6),
  
  FOREIGN KEY(typology_type) REFERENCES typology(type)
    ON DELETE SET NULL 
    ON UPDATE CASCADE
);
