CREATE TABLE contact (
    number INTEGER(12) PRIMARY KEY,
    employee_cf VARCHAR(16) NOT NULL,

    FOREIGN KEY(employee_cf) REFERENCES employee(cf)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);