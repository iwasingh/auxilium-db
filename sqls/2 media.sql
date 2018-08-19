CREATE TABLE media (
  id SERIAL PRIMARY KEY,
  source VARCHAR(30),
  typology_type VARCHAR(6),
  
  FOREIGN KEY(typology_type) REFERENCES typology(type)
    ON DELETE SET NULL 
    ON UPDATE CASCADE
);
