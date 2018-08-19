-- Update concept, attribute "title" intended as group code
-- Integer => SmallInt or Numeric
CREATE TABLE groupn (
  title CHAR(4) PRIMARY KEY, 
  damage INTEGER, -- NOT NULL
  risk INTEGER, -- NOT NULL

  CHECK (damage >= 1 AND damage <= 3),
  CHECK (risk >= 1 AND risk <= 3)
);
