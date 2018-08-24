 
CREATE TABLE typology (
  type VARCHAR(6) PRIMARY KEY
);
CREATE TABLE media (
  id SERIAL PRIMARY KEY,
  source VARCHAR(255) NOT NULL,
  typology_type VARCHAR(6) NOT NULL,
  
  FOREIGN KEY(typology_type) REFERENCES typology(type)
    ON UPDATE CASCADE
    ON DELETE NO ACTION
);
CREATE TABLE resource (
  id SERIAL PRIMARY KEY,
  title VARCHAR(255) NOT NULL, 
  parent INTEGER,

  FOREIGN KEY(parent) REFERENCES resource(id)
    ON UPDATE CASCADE
    ON DELETE SET NULL
);
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
CREATE TABLE town (
  cap CHAR(5) PRIMARY KEY,
  name VARCHAR(36),

  CHECK (cap SIMILAR TO '[0-9]{5}')
);
-- Foreign key means default not null?
CREATE TABLE office (
  id SERIAL PRIMARY KEY,
  address VARCHAR(40) NOT NULL,
  mail VARCHAR(30) NOT NULL,
  phone VARCHAR(15) NOT NULL,
  town_cap CHAR(6) NOT NULL,

  FOREIGN KEY(town_cap) REFERENCES town(cap)
    ON UPDATE CASCADE
    ON DELETE NO ACTION
);
CREATE TABLE employee (
  cf CHAR(16) PRIMARY KEY,
  name VARCHAR(30),
  surname VARCHAR(30),
  office_id INTEGER,

  FOREIGN KEY (office_id) REFERENCES office(id)
    ON UPDATE CASCADE
    ON DELETE SET NULL 
);
CREATE TABLE contact (
  number VARCHAR(15) PRIMARY KEY,
  employee_cf CHAR(16) NOT NULL,

  FOREIGN KEY(employee_cf) REFERENCES employee(cf)
    ON UPDATE CASCADE
    ON DELETE CASCADE
);
CREATE TABLE message (
  timestamp TIMESTAMP(0) WITHOUT TIME ZONE DEFAULT current_timestamp,
  text TEXT,
  resource_id INTEGER,
  employee_cf CHAR(16),

  FOREIGN KEY (resource_id) REFERENCES resource(id)
    ON UPDATE CASCADE
    ON DELETE CASCADE,
  FOREIGN KEY (employee_cf) REFERENCES employee(cf)
    ON UPDATE CASCADE
    ON DELETE CASCADE, --GDPR Compliant

  PRIMARY KEY(employee_cf, timestamp)
);
CREATE TABLE session (
  id INTEGER PRIMARY KEY
);
CREATE TABLE shift (
  id SERIAL PRIMARY KEY,
  shift_date DATE NOT NULL, -- DD/MM/YYYY?
  employee_cf CHAR(16) NOT NULL,
  session_id INTEGER NOT NULL,
  hour_start SMALLINT NOT NULL,
  hour_end SMALLINT NOT NULL,

  FOREIGN KEY(employee_cf) REFERENCES employee(cf)
    ON UPDATE CASCADE
    ON DELETE CASCADE,
  FOREIGN KEY(session_id) REFERENCES session(id)
    ON UPDATE CASCADE
    ON DELETE CASCADE,

  UNIQUE(shift_date, employee_cf),
  UNIQUE(shift_date, session_id),

  CHECK(hour_start >= 0 AND hour_start < 24),
  CHECK(hour_end >= 0 AND hour_end < 24)
  --, CHECK(hour_start != hour_end)
);
CREATE TABLE maintainer (
  shift_id INTEGER PRIMARY KEY,

  FOREIGN KEY (shift_id) REFERENCES shift(id)
    ON UPDATE CASCADE
    ON DELETE CASCADE
);
CREATE TABLE dispatcher (
  shift_id INTEGER PRIMARY KEY,

  FOREIGN KEY (shift_id) REFERENCES shift(id)
    ON UPDATE CASCADE
    ON DELETE CASCADE
);
CREATE TABLE condition (
  name VARCHAR(255) PRIMARY KEY
);
CREATE TABLE device (
  name VARCHAR(255) PRIMARY KEY,
  specs TEXT
);
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
  km CHAR(2) NOT NULL,
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
CREATE TABLE inventory (
  nr INTEGER NOT NULL,
  device_name VARCHAR(255) NOT NULL, 
  description TEXT,

  FOREIGN KEY(device_name) REFERENCES device(name)
    ON UPDATE CASCADE
    ON DELETE CASCADE,
    
  PRIMARY KEY(nr, device_name)
);
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
INSERT INTO town VALUES('41123', 'Modena');
INSERT INTO town VALUES('41012', 'Carpi');
INSERT INTO town VALUES('42124', 'Reggio Emilia');
INSERT INTO town VALUES('46100', 'Mantova');
INSERT INTO office(address, mail, phone, town_cap) VALUES ('A1 AdS Secchia Ovest, 506', 'asmodena@autostrade.it', '800 108 108', 41123);
INSERT INTO office(address, mail, phone, town_cap) VALUES ('Via Fernando Fornaciari, 1', 'ascarpi@autostrade.it', '059 668253', 41012);
INSERT INTO office(address, mail, phone, town_cap) VALUES ('A1 casello di Reggio Emilia', 'asreggio@autostrade.it', '800 269 269', 42124);
INSERT INTO employee(cf, name, surname, office_id) VALUES ('ASDASDASD234325Z', 'Matteo', 'Guerzoni', 2);
INSERT INTO employee(cf, name, surname, office_id) VALUES ('SNGMT1235SFGTRFS', 'Amarjot', 'Singh', 2);
INSERT INTO employee(cf, name, surname, office_id) VALUES ('S32GMT1235SFGTRF', 'Mario', 'Rossi', 1);
INSERT INTO employee(cf, name, surname, office_id) VALUES ('SN23MT12353EGTRF', 'Luigi', 'Rossi', 1);
INSERT INTO employee(cf, name, surname, office_id) VALUES ('SRGSDFGC123SFLR5', 'Sergio', 'Ferretti', 3);
INSERT INTO employee(cf, name, surname, office_id) VALUES ('FRCNPNGSWEWE23SS', 'Francesco', 'Pannofino', 1);
INSERT INTO employee(cf, name, surname, office_id) VALUES ('ALTFAORS24DFS2RA', 'Altair', 'Mohmuz', 3);
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
INSERT INTO session(id) VALUES (1004);INSERT INTO shift(shift_date, employee_cf, session_id, hour_start, hour_end) VALUES ('2018-08-19', 'ASDASDASD234325Z', 1002, 11, 17);
INSERT INTO shift(shift_date, employee_cf, session_id, hour_start, hour_end) VALUES ('2018-08-19', 'S32GMT1235SFGTRF', 1003, 15, 20);
INSERT INTO shift(shift_date, employee_cf, session_id, hour_start, hour_end) VALUES ('2018-08-19', 'SN23MT12353EGTRF', 1004, 10, 20);
INSERT INTO shift(shift_date, employee_cf, session_id, hour_start, hour_end) VALUES ('2018-08-21', 'SNGMT1235SFGTRFS', 1000, 10, 18);
INSERT INTO shift(shift_date, employee_cf, session_id, hour_start, hour_end) VALUES ('2018-08-21', 'S32GMT1235SFGTRF', 1001, 05, 13);
INSERT INTO shift(shift_date, employee_cf, session_id, hour_start, hour_end) VALUES ('2018-08-21', 'SN23MT12353EGTRF', 1002, 06, 14);
INSERT INTO shift(shift_date, employee_cf, session_id, hour_start, hour_end) VALUES ('2018-08-21', 'SRGSDFGC123SFLR5', 1003, 10, 19);
INSERT INTO shift(shift_date, employee_cf, session_id, hour_start, hour_end) VALUES ('2018-08-22', 'ASDASDASD234325Z', 1000, 05, 13);
INSERT INTO shift(shift_date, employee_cf, session_id, hour_start, hour_end) VALUES ('2018-08-22', 'SRGSDFGC123SFLR5', 1001, 04, 10);
INSERT INTO shift(shift_date, employee_cf, session_id, hour_start, hour_end) VALUES ('2018-08-22', 'FRCNPNGSWEWE23SS', 1002, 03, 11);-- trigger no duplicate shift mantainer, dispatcher
INSERT INTO maintainer(shift_id) VALUES (1);
INSERT INTO maintainer(shift_id) VALUES (2);
INSERT INTO maintainer(shift_id) VALUES (4);
INSERT INTO maintainer(shift_id) VALUES (6);
INSERT INTO maintainer(shift_id) VALUES (9);
-- trigger no duplicate shift mantainer, dispatcher
INSERT INTO dispatcher(shift_id) VALUES (3);
INSERT INTO dispatcher(shift_id) VALUES (5);
INSERT INTO dispatcher(shift_id) VALUES (7);
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
-- use pk from resource leaf (+ trigger)
-- put description better (now redundant) or either reference to a resource content
INSERT INTO task(name, description, resource_id) VALUES ('ELETT_00', 'integrità chiusure segregazioni', 6);
INSERT INTO task(name, description, resource_id) VALUES ('ELETT_01', 'controllo danneggiamenti', 7);
INSERT INTO task(name, description, resource_id) VALUES ('ELETT_02', 'integrità targhette segnaletica sicurezza', 8);
INSERT INTO task(name, description, resource_id) VALUES ('ELETT_03', 'esame interno scariche elettriche', 9);
INSERT INTO task(name, description, resource_id) VALUES ('ELETT_04', 'infiltrazioni acqua condensa quadro', 10);
INSERT INTO task(name, description, resource_id) VALUES ('ELETT_05', 'batterie avviamento sistema ricarica', 11);
INSERT INTO task(name, description, resource_id) VALUES ('ELETT_06', 'equilibrio fasi uscita carico', 12);
-- Update concept, attribute "title" intended as group code
INSERT INTO groupn(title, damage, risk) VALUES('PE00', 3, 2);
INSERT INTO groupn(title, damage, risk) VALUES('PE01', 3, 1);
INSERT INTO groupn(title, damage, risk) VALUES('PE02', 3, 3);INSERT INTO condition_groupn (condition_name, groupn_title) VALUES('puntali protetti', 'PE00');
INSERT INTO condition_groupn (condition_name, groupn_title) VALUES('parti scoperte in tensione entro 30 cm', 'PE00');
INSERT INTO condition_groupn (condition_name, groupn_title) VALUES('puntali protetti', 'PE01');
INSERT INTO condition_groupn (condition_name, groupn_title) VALUES('parti scoperte in tensione oltre 30 cm', 'PE01');
INSERT INTO condition_groupn (condition_name, groupn_title) VALUES('puntali non protetti', 'PE02');
INSERT INTO condition_groupn (condition_name, groupn_title) VALUES('parti scoperte qualsiasi condizione', 'PE02');
INSERT INTO device_groupn (device_name, groupn_title) VALUES('guanti', 'PE00');
INSERT INTO device_groupn (device_name, groupn_title) VALUES('indumenti a norma', 'PE00');
INSERT INTO device_groupn (device_name, groupn_title) VALUES('guanti', 'PE01');
INSERT INTO device_groupn (device_name, groupn_title) VALUES('indumenti a norma', 'PE01');
INSERT INTO device_groupn (device_name, groupn_title) VALUES('guanti', 'PE02');
INSERT INTO device_groupn (device_name, groupn_title) VALUES('puntali', 'PE02');
INSERT INTO device_groupn (device_name, groupn_title) VALUES('indumenti a norma', 'PE02');
INSERT INTO task_groupn(task_name, groupn_title) VALUES ('ELETT_05', 'PE00');
INSERT INTO task_groupn(task_name, groupn_title) VALUES ('ELETT_05', 'PE01');
INSERT INTO task_groupn(task_name, groupn_title) VALUES ('ELETT_06', 'PE00');
INSERT INTO task_groupn(task_name, groupn_title) VALUES ('ELETT_06', 'PE01');
INSERT INTO task_groupn(task_name, groupn_title) VALUES ('ELETT_06', 'PE02');
INSERT INTO intervention(maintainer_shift_id, task_name, town_cap, km, description, start_at, end_at) VALUES(1, 'ELETT_01', 41012, '07', 'Esecuzione intervento di riparazione e controllo causa maltempo bollino rosso', '2018-08-19 11:23:00', '2018-08-19 13:18:00');
INSERT INTO intervention(maintainer_shift_id, task_name, town_cap, km, description, start_at, end_at) VALUES(1, 'ELETT_01', 41012, '07', 'Esecuzione intervento di riparazione e controllo causa maltempo bollino rosso', '2018-08-19 12:23:00', '2018-08-19 15:36:00');
INSERT INTO intervention(maintainer_shift_id, task_name, town_cap, km, description, start_at, end_at) VALUES(2, 'ELETT_05', 41123, '07', 'Esecuzione intervento di riparazione e controllo causa maltempo bollino rosso', '2018-08-19 16:37:00', '2018-08-19 18:24:00');
INSERT INTO intervention(maintainer_shift_id, task_name, town_cap, km, description, start_at, end_at) VALUES(4, 'ELETT_00', 41123, '11', 'Controllo di routine', '2018-08-21 11:18:00', '2018-08-21 11:43:00');
INSERT INTO intervention(maintainer_shift_id, task_name, town_cap, km, description, start_at, end_at) VALUES(4, 'ELETT_02', 41123, '11', 'Controllo di routine', '2018-08-21 15:27:00', '2018-08-21 16:08:00');
INSERT INTO intervention(maintainer_shift_id, task_name, town_cap, km, description, start_at, end_at) VALUES(6, 'ELETT_03', 41123, '11', 'Controllo di routine', '2018-08-21 06:33:00', '2018-08-21 07:24:00');
INSERT INTO intervention(maintainer_shift_id, task_name, town_cap, km, description, start_at, end_at) VALUES(6, 'ELETT_06', 41123, '11', 'Controllo di routine', '2018-08-21 12:58:00', '2018-08-21 13:21:00');
INSERT INTO intervention(maintainer_shift_id, task_name, town_cap, km, description, start_at, end_at) VALUES(9, 'ELETT_04', 42124, '09', 'Manutenzione per problemi tecnici rilevati', '2018-08-22 05:42:00', '2018-08-22 06:51:00');
INSERT INTO intervention(maintainer_shift_id, task_name, town_cap, km, description, start_at, end_at) VALUES(9, 'ELETT_06', 42124, '09', 'Regolazione carico del gruppo', '2018-08-22 10:22:00', '2018-08-22 11:13:00');
INSERT INTO inventory(nr, device_name) VALUES (1, 'puntali');
INSERT INTO inventory(nr, device_name) VALUES (2, 'puntali');
INSERT INTO inventory(nr, device_name) VALUES (3, 'puntali');
INSERT INTO inventory(nr, device_name) VALUES (4, 'puntali');
INSERT INTO inventory(nr, device_name) VALUES (1, 'guanti');
INSERT INTO inventory(nr, device_name) VALUES (2, 'guanti');
INSERT INTO inventory(nr, device_name) VALUES (3, 'guanti');
INSERT INTO inventory(nr, device_name) VALUES (4, 'guanti');
INSERT INTO inventory(nr, device_name) VALUES (1, 'maschera');
INSERT INTO inventory(nr, device_name) VALUES (2, 'maschera');
INSERT INTO inventory(nr, device_name) VALUES (1, 'indumenti a norma');
INSERT INTO inventory(nr, device_name) VALUES (2, 'indumenti a norma');
-- query per mostrare i possibili dpi richiesti
INSERT INTO borrow(inventory_nr, inventory_device_name, maintainer_shift_id, motivation, start_at, end_at) VALUES(1, 'guanti', 2, 'DPI minimale per classe di pericolo indicata PE00', '2018-08-19 16:25:00', '2018-08-19 18:38:00');
INSERT INTO borrow(inventory_nr, inventory_device_name, maintainer_shift_id, motivation, start_at, end_at) VALUES(1, 'indumenti a norma', 2, 'DPI minimale per classe di pericolo indicata PE00', '2018-08-19 16:25:00', '2018-08-19 18:38:00');
INSERT INTO borrow(inventory_nr, inventory_device_name, maintainer_shift_id, motivation, start_at, end_at) VALUES(1, 'guanti', 6, 'DPI minimale per classe di pericolo indicata PE01', '2018-08-21 12:50:00', '2018-08-21 13:30:00');
INSERT INTO borrow(inventory_nr, inventory_device_name, maintainer_shift_id, motivation, start_at, end_at) VALUES(1, 'indumenti a norma', 6, 'DPI minimale per classe di pericolo indicata PE01', '2018-08-21 12:50:00', '2018-08-21 13:30:00');
INSERT INTO borrow(inventory_nr, inventory_device_name, maintainer_shift_id, motivation, start_at, end_at) VALUES(1, 'guanti', 9, 'DPI minimale per classe di pericolo indicata PE02', '2018-08-22 10:15:00', '2018-08-22 11:28:00');
INSERT INTO borrow(inventory_nr, inventory_device_name, maintainer_shift_id, motivation, start_at, end_at) VALUES(1, 'indumenti a norma', 9, 'DPI minimale per classe di pericolo indicata PE02', '2018-08-22 10:15:00', '2018-08-22 11:28:00');
INSERT INTO borrow(inventory_nr, inventory_device_name, maintainer_shift_id, motivation, start_at, end_at) VALUES(1, 'puntali', 9, 'DPI minimale per classe di pericolo indicata PE02', '2018-08-22 10:15:00', '2018-08-22 11:28:00');
-- trigger check date & hour
INSERT INTO assistance (maintainer_shift_id, start_at, end_at) VALUES (1, '2018-08-19 13:04:11', '2018-08-19 13:27:35');
INSERT INTO assistance (maintainer_shift_id, start_at, end_at) VALUES (2, '2018-08-19 16:04:11', '2018-08-19 16:27:35');
INSERT INTO assistance (maintainer_shift_id, start_at, end_at) VALUES (4, '2018-08-21 10:58:43', '2018-08-21 11:07:12');
INSERT INTO assistance (maintainer_shift_id, start_at, end_at) VALUES (4, '2018-08-21 16:18:39', '2018-08-21 16:37:22');
INSERT INTO assistance (maintainer_shift_id, start_at, end_at) VALUES (6, '2018-08-21 10:34:25', '2018-08-21 11:13:48');
INSERT INTO assistance (maintainer_shift_id, start_at, end_at) VALUES (9, '2018-08-22 06:51:35', '2018-08-22 07:04:06');
-- check dispatcher has turn at that time
INSERT INTO attendee(assistance_ticket, dispatcher_shift_id) VALUES (1, 3);
INSERT INTO attendee(assistance_ticket, dispatcher_shift_id) VALUES (2, 3);
INSERT INTO attendee(assistance_ticket, dispatcher_shift_id) VALUES (3, 5);
INSERT INTO attendee(assistance_ticket, dispatcher_shift_id) VALUES (4, 7);
INSERT INTO attendee(assistance_ticket, dispatcher_shift_id) VALUES (5, 7);
INSERT INTO attendee(assistance_ticket, dispatcher_shift_id) VALUES (6, 8);
INSERT INTO attendee(assistance_ticket, dispatcher_shift_id) VALUES (6, 10);
 
CREATE OR REPLACE FUNCTION shift_overlap_employee_type ()
  RETURNS trigger AS $$
    DECLARE
      shift_id INTEGER;
      other_table text;
    BEGIN
	  other_table = TG_ARGV[0];
      EXECUTE format('SELECT shift_id FROM %I WHERE shift_id = $1', other_table) INTO shift_id USING NEW.shift_id;
        IF shift_id IS NOT NULL THEN
          RAISE EXCEPTION 'shift_overlap_employee_type(%). id Already exists', other_table
            USING HINT = 'Please check your shift id on tables';
        END IF;
      RETURN NEW;
    END
$$ LANGUAGE 'plpgsql';


-- Controllo se le date rientrano nei turni di un specifico dipendente che fa un operazione 

CREATE OR REPLACE FUNCTION shift_dates_equalities_function()
  RETURNS trigger AS $$
    DECLARE
      _shift record;
    BEGIN
        IF NEW.start_at IS NOT NULL THEN
        SELECT * INTO _shift FROM shift WHERE id = NEW.maintainer_shift_id
          AND NEW.start_at BETWEEN shift_date + interval '1 hour' * hour_start AND shift_date + interval '1 hour' * hour_end;
        END IF;
  
        IF _shift IS NULL THEN
          RAISE EXCEPTION 'shift_dates_equalities_intervention_function exception. Timestamp not valid for the shift'
          USING HINT = 'Please check your shift dates and the table start_at or end_at timestamps';
        END IF;
  
        IF NEW.end_at IS NOT NULL THEN
          SELECT * INTO _shift FROM shift WHERE id = NEW.maintainer_shift_id
          AND NEW.end_at BETWEEN shift_date + interval '1 hour' * hour_start AND shift_date + interval '1 hour' * hour_end;
        END IF;
        
        IF _shift IS NULL THEN
          RAISE EXCEPTION 'shift_dates_equalities_intervention_function exception. Timestamp not valid for the shift'
          USING HINT = 'Please check your shift dates and the table start_at or end_at timestamps';
        END IF;
      RETURN NEW;
    END
$$ LANGUAGE 'plpgsql';


CREATE OR REPLACE FUNCTION shift_overlap_employee_type ()
  RETURNS trigger AS $$
    DECLARE
      shift_id INTEGER;
      other_table text;
    BEGIN
	  other_table = TG_ARGV[0];
      EXECUTE format('SELECT shift_id FROM %I WHERE shift_id = $1', other_table) INTO shift_id USING NEW.shift_id;
        IF shift_id IS NOT NULL THEN
          RAISE EXCEPTION 'shift_overlap_employee_type(%). id Already exists', other_table
            USING HINT = 'Please check your shift id on tables';
        END IF;
      RETURN NEW;
    END
$$ LANGUAGE 'plpgsql';


-- Controllo se le date rientrano nei turni di un specifico dipendente che fa un operazione 

CREATE OR REPLACE FUNCTION shift_dates_equalities_function()
  RETURNS trigger AS $$
    DECLARE
      _shift record;
    BEGIN
        IF NEW.start_at IS NOT NULL THEN
        SELECT * INTO _shift FROM shift WHERE id = NEW.maintainer_shift_id
          AND NEW.start_at BETWEEN shift_date + interval '1 hour' * hour_start AND shift_date + interval '1 hour' * hour_end;
        END IF;
  
        IF _shift IS NULL THEN
          RAISE EXCEPTION 'shift_dates_equalities_intervention_function exception. Timestamp not valid for the shift'
          USING HINT = 'Please check your shift dates and the table start_at or end_at timestamps';
        END IF;
  
        IF NEW.end_at IS NOT NULL THEN
          SELECT * INTO _shift FROM shift WHERE id = NEW.maintainer_shift_id
          AND NEW.end_at BETWEEN shift_date + interval '1 hour' * hour_start AND shift_date + interval '1 hour' * hour_end;
        END IF;
        
        IF _shift IS NULL THEN
          RAISE EXCEPTION 'shift_dates_equalities_intervention_function exception. Timestamp not valid for the shift'
          USING HINT = 'Please check your shift dates and the table start_at or end_at timestamps';
        END IF;
      RETURN NEW;
    END
$$ LANGUAGE 'plpgsql';


CREATE TRIGGER shift_overlap_employee_type_trigger
  BEFORE INSERT OR UPDATE
  ON maintainer
  FOR EACH ROW EXECUTE PROCEDURE shift_overlap_employee_type('dispatcher');
CREATE TRIGGER shift_overlap_employee_type_trigger
  BEFORE INSERT OR UPDATE
  ON dispatcher
  FOR EACH ROW EXECUTE PROCEDURE shift_overlap_employee_type('maintainer');
CREATE OR REPLACE FUNCTION media_is_resource_a_leaf ()
  RETURNS trigger AS $$
    DECLARE
      resource_tb record;
    BEGIN
        WITH RECURSIVE tree AS (
          SELECT resource.id FROM resource WHERE id = NEW.resource_id
          UNION ALL

          SELECT r.id
          FROM resource r JOIN tree p ON p.id = r.parent
        ) SELECT * INTO resource_tb FROM tree WHERE id != NEW.resource_id;

        IF resource_tb IS NOT NULL THEN
          RAISE EXCEPTION 'media_is_resource_a_leaf (%). resource_id is not a leaf', NEW.resource_id
            USING HINT = 'Please check your resource table';
        END IF;
      RETURN NEW;
    END
$$ LANGUAGE 'plpgsql';

CREATE TRIGGER media_is_resource_a_leaf_trigger
  BEFORE INSERT OR UPDATE
  ON attachment
  FOR EACH ROW EXECUTE PROCEDURE media_is_resource_a_leaf();
CREATE TRIGGER shift_dates_equalities_intervention_trigger
  BEFORE INSERT OR UPDATE
  ON intervention
  FOR EACH ROW EXECUTE PROCEDURE shift_dates_equalities_function();

CREATE TRIGGER shift_dates_equalities_borrow_trigger
  BEFORE INSERT OR UPDATE
  ON borrow
  FOR EACH ROW EXECUTE PROCEDURE shift_dates_equalities_function();

-- Un manutentore non può fare altri interventi (indipendentemente dalla mansione) una volta che ha iniziato un determinato intervento

CREATE OR REPLACE FUNCTION maintainer_is_already_occupied_intervention()
  RETURNS trigger AS $$
    DECLARE
      _intervents record;
    BEGIN
      SELECT maintainer_shift_id INTO _intervents FROM intervention WHERE maintainer_shift_id = NEW.maintainer_shift_id AND end_at IS NULL;
      IF _intervents IS NOT NULL THEN
        RAISE EXCEPTION 'maintainer_is_already_occupied_intervention exception. The maintaner had to finish others intervention first!'
        USING HINT = 'Please check intervetions';
      END IF;
      RETURN NEW;
    END
$$ LANGUAGE 'plpgsql';

CREATE TRIGGER maintainer_is_already_occupied_intervention_trigger
  BEFORE INSERT
  ON intervention
  FOR EACH ROW EXECUTE PROCEDURE maintainer_is_already_occupied_intervention();

CREATE TRIGGER shift_dates_equalities_assistance_trigger
  BEFORE INSERT OR UPDATE
  ON assistance
  FOR EACH ROW EXECUTE PROCEDURE shift_dates_equalities_function();

-- Un manutentore non può prendere in prestito un oggetto non ancora restituito.

CREATE OR REPLACE FUNCTION maintainer_borrow_not_available_object()
  RETURNS trigger AS $$
    DECLARE
      _borrow record;
    BEGIN
      SELECT maintainer_shift_id INTO _borrow FROM borrow WHERE maintainer_shift_id = NEW.maintainer_shift_id 
        AND end_at IS NULL AND inventory_nr = NEW.inventory_nr AND inventory_device_name = NEW.inventory_device_name;
      IF _borrow IS NOT NULL THEN
        RAISE EXCEPTION 'maintainer_borrow_not_available_object exception. The Object is not available!'
        USING HINT = 'Please check objects restitution date';
      END IF;
      RETURN NEW;
    END
$$ LANGUAGE 'plpgsql';

CREATE TRIGGER maintainer_borrow_not_available_object_trigger
  BEFORE INSERT
  ON borrow
  FOR EACH ROW EXECUTE PROCEDURE maintainer_borrow_not_available_object();
