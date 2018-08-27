CREATE TABLE groupn (
  title CHAR(4) PRIMARY KEY, 
  damage SMALLINT NOT NULL,
  risk SMALLINT NOT NULL,

  CHECK (damage >= 1 AND damage <= 3),
  CHECK (risk >= 1 AND risk <= 3)
);
