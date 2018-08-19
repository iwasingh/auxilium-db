-- Foreign key means default not null?
CREATE TABLE office (
    id INTEGER PRIMARY KEY AUTO INCREMENT,
    address VARCHAR(40) NOT NULL,
    mail VARCHAR(30) NOT NULL,
    phone INTEGER(12) NOT NULL,
    town_cap INTEGER(6) NOT NULL,

    FOREIGN KEY(town_cap) REFERENCES town(cap)
        ON UPDATE CASCADE
        ON DELETE NO ACTION
);