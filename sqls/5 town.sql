CREATE TABLE town (
  cap CHAR(5) PRIMARY KEY,
  name VARCHAR(36),

  CHECK (cap SIMILAR TO '[0-9]{5}')
);
