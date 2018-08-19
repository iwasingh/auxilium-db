-- Composite PK means default not null?
CREATE TABLE attachment (
  resource_id INTEGER NOT NULL,
  media_id INTEGER NOT NULL,

  FOREIGN KEY(resource_id) REFERENCES resource(id)
    ON UPDATE CASCADE
    ON DELETE CASCADE,
  FOREIGN KEY(media_id) REFERENCES media(id)
    ON UPDATE CASCADE
    ON DELETE CASCADE,

  PRIMARY KEY(resource_id, media_id)
);
