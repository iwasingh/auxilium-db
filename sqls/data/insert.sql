 
INSERT INTO typology VALUES('pdf');
INSERT INTO typology VALUES('video');
INSERT INTO typology VALUES('image');
INSERT INTO media(id, source, typology_type) VALUES(1, '/assets/elettrogeno/gruppo_continuita', 'image');
INSERT INTO media(id, source, typology_type) VALUES(2, '/assets/manuale', 'pdf');
INSERT INTO resource(id, title, parent) VALUES (1, 'ciclo manutenzione elettrogeno', NULL);
INSERT INTO resource(id, title, parent) VALUES (2, 'informazioni osdcontroller', NULL);
INSERT INTO resource(id, title, parent) VALUES (3, 'informazioni barriera b680h', NULL);
INSERT INTO resource(id, title, parent) VALUES (4, 'verifiche vista controllo integrità prova carico', 1);
INSERT INTO resource(id, title, parent) VALUES (5, 'funzionamento apparecchiature strumentali', 1);
INSERT INTO resource(id, title, parent) VALUES (6, 'integrità chiusure segregazioni', 4);
INSERT INTO resource(id, title, parent) VALUES (7, 'controllo danneggiamenti', 4);
INSERT INTO resource(id, title, parent) VALUES (8, 'integrità targhette segnaletica sicurezza', 4);
INSERT INTO resource(id, title, parent) VALUES (9, 'esame interno scariche elettriche', 4);
INSERT INTO resource(id, title, parent) VALUES (10, 'infiltrazioni acqua condensa quadro', 4);
INSERT INTO resource(id, title, parent) VALUES (11, 'batterie avviamento sistema ricarica', 5);
INSERT INTO resource(id, title, parent) VALUES (12, 'equilibrio fasi uscita carico', 5);
-- trigger check isLeaf!
INSERT INTO attachment(resource_id, media_id) VALUES (2,2);
INSERT INTO attachment(resource_id, media_id) VALUES (3,2);
INSERT INTO attachment(resource_id, media_id) VALUES (7,1);
INSERT INTO attachment(resource_id, media_id) VALUES (9,1);
INSERT INTO attachment(resource_id, media_id) VALUES (10,1);INSERT INTO town VALUES('41011', 'Campogalliano');
INSERT INTO town VALUES('41033', 'Concordia sul Secchia');
INSERT INTO office(address, mail, phone, town_cap) VALUES ('Via donizzetti', 'donizzetti@gmail.com', '0522-646429', '41033');
INSERT INTO office(address, mail, phone, town_cap) VALUES ('Via J.F Kennedy', 'kennedy@usa.it', '0522-323232', '41011');
INSERT INTO employee(cf, name, surname, office_id) VALUES ('ASDASDASD234325Z', 'Matteo', 'Guerzoni', 1);
INSERT INTO employee(cf, name, surname, office_id) VALUES ('SNGMT1235SFGTRFS', 'Amarjot', 'Singh', 2);
INSERT INTO employee(cf, name, surname, office_id) VALUES ('S32GMT1235SFGTRF', 'Mario', 'Rossi', 1);
INSERT INTO employee(cf, name, surname, office_id) VALUES ('SN23MT12353EGTRF', 'Luigi', 'Rossi', 2);
INSERT INTO employee(cf, name, surname, office_id) VALUES ('SRGSDFGC123SFLR5', 'Sergio', 'Ferretti', 1);
INSERT INTO employee(cf, name, surname, office_id) VALUES ('FRCNPNGSWEWE23SS', 'Francesco', 'Pannofino', 2);
INSERT INTO employee(cf, name, surname, office_id) VALUES ('ALTFAORS24DFS2RA', 'Altair', 'Mohmuz', 1);
-- change "number" in create table
INSERT INTO contact("number", employee_cf) VALUES ('1234567894', 'ASDASDASD234325Z');
INSERT INTO contact("number", employee_cf) VALUES ('1234523224', 'SNGMT1235SFGTRFS');
INSERT INTO contact("number", employee_cf) VALUES ('0231313432', 'S32GMT1235SFGTRF');
INSERT INTO contact("number", employee_cf) VALUES ('1212121212', 'SN23MT12353EGTRF');
INSERT INTO message("timestamp", text, resource_id, employee_cf) VALUES ('2018-08-22 17:40:40', 'batterie avviamento sistema ricarica', 11, 'ASDASDASD234325Z');
INSERT INTO message("timestamp", text, resource_id, employee_cf) VALUES ('2018-08-22 17:41:11', 'ciclo manutenzione elettrogeno', 1, 'ASDASDASD234325Z');
INSERT INTO message("timestamp", text, resource_id, employee_cf) VALUES ('2018-08-22 17:41:18', 'verifiche vista controllo integrità prova carico', 4, 'ASDASDASD234325Z');
INSERT INTO message("timestamp", text, resource_id, employee_cf) VALUES ('2018-08-22 17:41:27', 'integrità chiusure segregazioni', 6, 'ASDASDASD234325Z');
INSERT INTO message("timestamp", text, resource_id, employee_cf) VALUES ('2018-08-22 17:41:36', 'equilibrio fasi uscita carico', 12, 'ASDASDASD234325Z');

INSERT INTO message("timestamp", text, resource_id, employee_cf) VALUES ('2018-08-22 17:41:42', 'ciclo manutenzione elettrogeno', 1, 'SNGMT1235SFGTRFS');
INSERT INTO message("timestamp", text, resource_id, employee_cf) VALUES ('2018-08-22 17:41:45', 'funzionamento apparecchiature strumentali', 5, 'SNGMT1235SFGTRFS');
INSERT INTO message("timestamp", text, resource_id, employee_cf) VALUES ('2018-08-22 17:41:48', 'batterie avviamento sistema ricarica', 11, 'SNGMT1235SFGTRFS');
-- key like cap
INSERT INTO session(id) VALUES (1000);
INSERT INTO session(id) VALUES (1001);
INSERT INTO session(id) VALUES (1002);
INSERT INTO session(id) VALUES (1003);
INSERT INTO session(id) VALUES (1004);-- 2018-08-19
INSERT INTO shift(shift_date, employee_cf, session_id, hour_start, hour_end) VALUES ('2018-08-19', 'ASDASDASD234325Z', 1002, 11, 17);
INSERT INTO shift(shift_date, employee_cf, session_id, hour_start, hour_end) VALUES ('2018-08-19', 'S32GMT1235SFGTRF', 1003, 15, 20);
INSERT INTO shift(shift_date, employee_cf, session_id, hour_start, hour_end) VALUES ('2018-08-19', 'SN23MT12353EGTRF', 1004, 19, 23);

-- 2018-08-21
INSERT INTO shift(shift_date, employee_cf, session_id, hour_start, hour_end) VALUES ('2018-08-21', 'SNGMT1235SFGTRFS', 1000, 09, 18);
INSERT INTO shift(shift_date, employee_cf, session_id, hour_start, hour_end) VALUES ('2018-08-21', 'S32GMT1235SFGTRF', 1001, 13, 20);
INSERT INTO shift(shift_date, employee_cf, session_id, hour_start, hour_end) VALUES ('2018-08-21', 'SN23MT12353EGTRF', 1002, 06, 14);
INSERT INTO shift(shift_date, employee_cf, session_id, hour_start, hour_end) VALUES ('2018-08-21', 'SRGSDFGC123SFLR5', 1003, 15, 21);

-- 2018-08-22
INSERT INTO shift(shift_date, employee_cf, session_id, hour_start, hour_end) VALUES ('2018-08-22', 'ASDASDASD234325Z', 1000, 09, 18);
INSERT INTO shift(shift_date, employee_cf, session_id, hour_start, hour_end) VALUES ('2018-08-22', 'SRGSDFGC123SFLR5', 1001, 04, 11);
INSERT INTO shift(shift_date, employee_cf, session_id, hour_start, hour_end) VALUES ('2018-08-22', 'FRCNPNGSWEWE23SS', 1002, 06, 11);-- trigger no duplicate shift mantainer, dispatcher
INSERT INTO maintainer(shift_id) VALUES (1);
INSERT INTO maintainer(shift_id) VALUES (2);
INSERT INTO maintainer(shift_id) VALUES (4);
INSERT INTO maintainer(shift_id) VALUES (6);
INSERT INTO maintainer(shift_id) VALUES (7);
INSERT INTO maintainer(shift_id) VALUES (9);
-- trigger no duplicate shift mantainer, dispatcher
INSERT INTO dispatcher(shift_id) VALUES (3);
INSERT INTO dispatcher(shift_id) VALUES (5);
INSERT INTO dispatcher(shift_id) VALUES (8);
INSERT INTO dispatcher(shift_id) VALUES (10);INSERT INTO condition(name) VALUES ('puntali protetti');
INSERT INTO condition(name) VALUES ('puntali non protetti');
INSERT INTO condition(name) VALUES ('parti scoperte in tensione entro 30 cm');
INSERT INTO condition(name) VALUES ('parti scoperte in tensione oltre 30 cm');
INSERT INTO condition(name) VALUES ('parti scoperte qualsiasi condizione');
INSERT INTO device(name, specs) VALUES ('guanti', 'gialli - ad uso lavorativo');
INSERT INTO device(name, specs) VALUES ('puntali', '0.9m');
INSERT INTO device(name) VALUES ('maschera');
INSERT INTO device(name) VALUES ('indumenti a norma');
CREATE TABLE task (
  name VARCHAR(20) PRIMARY KEY,
  description TEXT NOT NULL,
  resource_id INTEGER,
  
  FOREIGN KEY(resource_id) REFERENCES resource(id)
    ON UPDATE CASCADE
    ON DELETE SET NULL
);
-- Update concept, attribute "title" intended as group code
CREATE TABLE groupn (
  title CHAR(4) PRIMARY KEY, 
  damage SMALLINT, -- NOT NULL
  risk SMALLINT, -- NOT NULL

  CHECK (damage >= 1 AND damage <= 3),
  CHECK (risk >= 1 AND risk <= 3)
);
CREATE TABLE condition_groupn (
  condition_name VARCHAR(255) NOT NULL,
  groupn_title CHAR(4) NOT NULL,  
  
  FOREIGN KEY(condition_name) REFERENCES condition(name)
    ON UPDATE CASCADE
    ON DELETE CASCADE,
  FOREIGN KEY(groupn_title) REFERENCES groupn(title)
    ON UPDATE CASCADE
    ON DELETE CASCADE
);
CREATE TABLE device_groupn (
  device_name VARCHAR(255) NOT NULL,
  groupn_title CHAR(4) NOT NULL,  
  
  FOREIGN KEY(device_name) REFERENCES device(name)
    ON UPDATE CASCADE
    ON DELETE CASCADE,
  FOREIGN KEY(groupn_title) REFERENCES groupn(title)
    ON UPDATE CASCADE
    ON DELETE CASCADE
);
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
CREATE TABLE intervention (
  maintainer_shift_id INTEGER NOT NULL,
  task_name VARCHAR(20) NOT NULL, 
  town_cap CHAR(6) NOT NULL,
  address VARCHAR(40) NOT NULL,
  description TEXT,
  start_at TIMESTAMP(0) WITHOUT TIME ZONE NOT NULL,
  end_at TIMESTAMP(0) WITHOUT TIME ZONE,

  FOREIGN KEY(maintainer_shift_id) REFERENCES maintainer(shift_id)
    ON UPDATE CASCADE
    ON DELETE CASCADE,
  FOREIGN KEY(task_name) REFERENCES task(name)
    ON UPDATE CASCADE
    ON DELETE NO ACTION,
  FOREIGN KEY(town_cap) REFERENCES town(cap)
    ON UPDATE CASCADE
    ON DELETE NO ACTION,

  PRIMARY KEY(maintainer_shift_id, start_at),

  CHECK(end_at > start_at)
);
INSERT INTO inventory(device_name) VALUES ('puntali');
INSERT INTO inventory(device_name) VALUES ('puntali');
INSERT INTO inventory(device_name) VALUES ('puntali');
INSERT INTO inventory(device_name) VALUES ('puntali');

INSERT INTO inventory(device_name) VALUES ('guanti');
INSERT INTO inventory(device_name) VALUES ('guanti');
INSERT INTO inventory(device_name) VALUES ('guanti');
INSERT INTO inventory(device_name) VALUES ('guanti');

INSERT INTO inventory(device_name) VALUES ('maschera');
INSERT INTO inventory(device_name) VALUES ('maschera');
INSERT INTO inventory(device_name) VALUES ('maschera');
INSERT INTO inventory(device_name) VALUES ('maschera');

INSERT INTO inventory(device_name) VALUES ('indumenti a norma');
INSERT INTO inventory(device_name) VALUES ('indumenti a norma');
INSERT INTO inventory(device_name) VALUES ('indumenti a norma');
INSERT INTO inventory(device_name) VALUES ('indumenti a norma');

CREATE TABLE borrow (
  inventory_nr INTEGER NOT NULL,
  inventory_device_name VARCHAR(255) NOT NULL, 
  maintainer_shift_id INTEGER,
  motivation TEXT,
  start_at TIMESTAMP(0) WITHOUT TIME ZONE NOT NULL,
  end_at TIMESTAMP(0) WITHOUT TIME ZONE,

  FOREIGN KEY(inventory_nr, inventory_device_name) REFERENCES inventory(nr, device_name)
    ON UPDATE CASCADE
    ON DELETE NO ACTION,
  FOREIGN KEY(maintainer_shift_id) REFERENCES maintainer(shift_id)
    ON UPDATE CASCADE
    ON DELETE SET NULL,

  PRIMARY KEY(inventory_nr, inventory_device_name, start_at),

  CHECK(end_at > start_at)
);
CREATE TABLE assistance (
  ticket SERIAL PRIMARY KEY,
  maintainer_shift_id INTEGER,
  start_at TIMESTAMP(0) WITHOUT TIME ZONE NOT NULL,
  end_at TIMESTAMP(0) WITHOUT TIME ZONE,

  FOREIGN KEY(maintainer_shift_id) REFERENCES maintainer(shift_id)
    ON UPDATE CASCADE
    ON DELETE SET NULL,

  -- UNIQUE(maintainer_shift_id, start_at),
  -- handle on trigger, check same date as with shift entity (turno)

  CHECK(end_at > start_at)
);
CREATE TABLE attendee (
  assistance_ticket INTEGER NOT NULL,
  dispatcher_shift_id INTEGER NOT NULL,

  FOREIGN KEY(assistance_ticket) REFERENCES assistance(ticket)
    ON UPDATE CASCADE
    ON DELETE CASCADE,
  FOREIGN KEY(dispatcher_shift_id) REFERENCES dispatcher(shift_id)
    ON UPDATE CASCADE
    ON DELETE CASCADE,

  PRIMARY KEY(assistance_ticket, dispatcher_shift_id)
);
