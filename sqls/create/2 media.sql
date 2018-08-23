CREATE TABLE media (
  id SERIAL PRIMARY KEY,
  source VARCHAR(255) NOT NULL,
  typology_type VARCHAR(6) NOT NULL,
  
  FOREIGN KEY(typology_type) REFERENCES typology(type)
    ON UPDATE CASCADE
    ON DELETE NO ACTION
);
