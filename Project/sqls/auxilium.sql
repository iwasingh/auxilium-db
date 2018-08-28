 
CREATE TABLE typology (
  type VARCHAR(6) PRIMARY KEY
);
CREATE TABLE media (
  id SERIAL PRIMARY KEY,
  source VARCHAR(80) NOT NULL,
  typology_type VARCHAR(6) NOT NULL,
  
  FOREIGN KEY(typology_type) REFERENCES typology(type)
    ON UPDATE CASCADE
    ON DELETE NO ACTION
);
CREATE TABLE resource (
  id SERIAL PRIMARY KEY,
  title VARCHAR(100) NOT NULL, 
  parent INTEGER,

  FOREIGN KEY(parent) REFERENCES resource(id)
    ON UPDATE CASCADE
    ON DELETE SET NULL
);
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
  name VARCHAR(40) NOT NULL,

  CHECK (cap SIMILAR TO '[0-9]{5}')
);
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
  name VARCHAR(30) NOT NULL,
  surname VARCHAR(30) NOT NULL,
  address VARCHAR(40) NOT NULL,
  town_cap CHAR(6) NOT NULL,
  office_id INTEGER NOT NULL,

  FOREIGN KEY(town_cap) REFERENCES town(cap)
    ON UPDATE CASCADE
    ON DELETE NO ACTION,
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
  resource_id INTEGER NOT NULL,
  employee_cf CHAR(16) NOT NULL,

  FOREIGN KEY (resource_id) REFERENCES resource(id)
    ON UPDATE CASCADE
    ON DELETE CASCADE,
  FOREIGN KEY (employee_cf) REFERENCES employee(cf)
    ON UPDATE CASCADE
    ON DELETE CASCADE,

  PRIMARY KEY(employee_cf, timestamp)
);
CREATE TABLE session (
  id INTEGER PRIMARY KEY
);
CREATE TABLE shift (
  id SERIAL PRIMARY KEY,
  shift_date DATE NOT NULL,
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
  CHECK(hour_end >= 0 AND hour_end < 24),
  CHECK(hour_end > hour_start)
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
  name VARCHAR(50) PRIMARY KEY
);
CREATE TABLE device (
  name VARCHAR(50) PRIMARY KEY,
  specs TEXT
);
CREATE TABLE task (
  name CHAR(8) PRIMARY KEY,
  description TEXT NOT NULL,
  resource_id INTEGER,
  
  FOREIGN KEY(resource_id) REFERENCES resource(id)
    ON UPDATE CASCADE
    ON DELETE SET NULL
);
CREATE TABLE groupn (
  title CHAR(4) PRIMARY KEY, 
  damage SMALLINT NOT NULL,
  risk SMALLINT NOT NULL,

  CHECK (damage >= 1 AND damage <= 3),
  CHECK (risk >= 1 AND risk <= 3)
);
CREATE TABLE condition_groupn (
  condition_name VARCHAR(50) NOT NULL,
  groupn_title CHAR(4) NOT NULL,  
  
  FOREIGN KEY(condition_name) REFERENCES condition(name)
    ON UPDATE CASCADE
    ON DELETE CASCADE,
  FOREIGN KEY(groupn_title) REFERENCES groupn(title)
    ON UPDATE CASCADE
    ON DELETE CASCADE,

  PRIMARY KEY(condition_name, groupn_title)
);
CREATE TABLE device_groupn (
  device_name VARCHAR(50) NOT NULL,
  groupn_title CHAR(4) NOT NULL,  
  
  FOREIGN KEY(device_name) REFERENCES device(name)
    ON UPDATE CASCADE
    ON DELETE CASCADE,
  FOREIGN KEY(groupn_title) REFERENCES groupn(title)
    ON UPDATE CASCADE
    ON DELETE CASCADE,

  PRIMARY KEY(device_name, groupn_title)
);
CREATE TABLE task_groupn (
  task_name CHAR(8) NOT NULL,
  groupn_title CHAR(4) NOT NULL,  
  
  FOREIGN KEY(task_name) REFERENCES task(name)
    ON UPDATE CASCADE
    ON DELETE CASCADE,
  FOREIGN KEY(groupn_title) REFERENCES groupn(title)
    ON UPDATE CASCADE
    ON DELETE CASCADE,

  PRIMARY KEY(task_name, groupn_title)
);
CREATE TABLE intervention (
  maintainer_shift_id INTEGER NOT NULL,
  task_name CHAR(8) NOT NULL, 
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
CREATE TABLE inventory (
  nr INTEGER NOT NULL,
  device_name VARCHAR(50) NOT NULL, 
  description TEXT,

  FOREIGN KEY(device_name) REFERENCES device(name)
    ON UPDATE CASCADE
    ON DELETE CASCADE,
    
  PRIMARY KEY(nr, device_name)
);
CREATE TABLE borrow (
  maintainer_shift_id INTEGER,
  inventory_nr INTEGER NOT NULL,
  inventory_device_name VARCHAR(50) NOT NULL, 
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
  maintainer_shift_id INTEGER,
  ticket SERIAL PRIMARY KEY,
  start_at TIMESTAMP(0) WITHOUT TIME ZONE NOT NULL,
  end_at TIMESTAMP(0) WITHOUT TIME ZONE,

  FOREIGN KEY(maintainer_shift_id) REFERENCES maintainer(shift_id)
    ON UPDATE CASCADE
    ON DELETE SET NULL,

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
 
INSERT INTO typology (type) VALUES ('pdf');
INSERT INTO typology (type) VALUES ('video');
INSERT INTO typology (type) VALUES ('image');
INSERT INTO media (id, source, typology_type) VALUES (1, '/assets/elettrogeno/gruppo_continuita', 'image');
INSERT INTO media (id, source, typology_type) VALUES (2, '/assets/manuale', 'pdf');
INSERT INTO resource (id, title, parent) VALUES (1, 'ciclo manutenzione elettrogeno', NULL);
INSERT INTO resource (id, title, parent) VALUES (2, 'informazioni osdcontroller', NULL);
INSERT INTO resource (id, title, parent) VALUES (3, 'informazioni barriera b680h', NULL);
INSERT INTO resource (id, title, parent) VALUES (4, 'verifiche vista controllo integrità prova carico', 1);
INSERT INTO resource (id, title, parent) VALUES (5, 'funzionamento apparecchiature strumentali', 1);
INSERT INTO resource (id, title, parent) VALUES (6, 'integrità chiusure segregazioni', 4);
INSERT INTO resource (id, title, parent) VALUES (7, 'controllo danneggiamenti', 4);
INSERT INTO resource (id, title, parent) VALUES (8, 'integrità targhette segnaletica sicurezza', 4);
INSERT INTO resource (id, title, parent) VALUES (9, 'esame interno scariche elettriche', 4);
INSERT INTO resource (id, title, parent) VALUES (10, 'infiltrazioni acqua condensa quadro', 4);
INSERT INTO resource (id, title, parent) VALUES (11, 'batterie avviamento sistema ricarica', 5);
INSERT INTO resource (id, title, parent) VALUES (12, 'equilibrio fasi uscita carico', 5);
INSERT INTO attachment (resource_id, media_id) VALUES (2, 2);
INSERT INTO attachment (resource_id, media_id) VALUES (3, 2);
INSERT INTO attachment (resource_id, media_id) VALUES (7, 1);
INSERT INTO attachment (resource_id, media_id) VALUES (9, 1);
INSERT INTO attachment (resource_id, media_id) VALUES (10, 1);
INSERT INTO town (cap, name) VALUES ('41011', 'Campogalliano');
INSERT INTO town (cap, name) VALUES ('41033', 'Concordia sul Secchia');
INSERT INTO town (cap, name) VALUES ('41123', 'Modena');
INSERT INTO town (cap, name) VALUES ('41012', 'Carpi');
INSERT INTO town (cap, name) VALUES ('42124', 'Reggio Emilia');
INSERT INTO town (cap, name) VALUES ('46100', 'Mantova');
INSERT INTO office (id, address, mail, phone, town_cap) VALUES (1, 'A1 AdS Secchia Ovest, 506', 'asmodena@autostrade.it', '800 108 108', '41123');
INSERT INTO office (id, address, mail, phone, town_cap) VALUES (2, 'Via Fernando Fornaciari, 1', 'ascarpi@autostrade.it', '059 668253', '41012');
INSERT INTO office (id, address, mail, phone, town_cap) VALUES (3, 'A1 casello di Reggio Emilia', 'asreggio@autostrade.it', '800 269 269', '42124');
INSERT INTO employee (cf, name, surname, address, town_cap, office_id) VALUES ('GRZMTT83G40F230E', 'Matteo', 'Guerzoni', 'Via Donizzetti, 5', '41012', 2);
INSERT INTO employee (cf, name, surname, address, town_cap, office_id) VALUES ('SNGMJT80L08F257P', 'Amarjot', 'Singh', 'Via della pace, 18', '41012', 2);
INSERT INTO employee (cf, name, surname, address, town_cap, office_id) VALUES ('RSSMRA77P03D150X', 'Mario', 'Rossi', 'Via Mazzini, 4', '41011', 1);
INSERT INTO employee (cf, name, surname, address, town_cap, office_id) VALUES ('BNCLGU91C23G224S', 'Luigi', 'Bianchi', 'Via Diazzi, 3', '41123', 1);
INSERT INTO employee (cf, name, surname, address, town_cap, office_id) VALUES ('SRGFRT89C10H223C', 'Sergio', 'Ferretti', 'Via della libertà, 2', '46100', 3);
INSERT INTO employee (cf, name, surname, address, town_cap, office_id) VALUES ('PNFFNC84D07I462B', 'Francesco', 'Panofino', 'Strada Martini, 9', '42124', 1);
INSERT INTO employee (cf, name, surname, address, town_cap, office_id) VALUES ('LTRCRL94P15B819G', 'Carlo', 'Altero', 'Via martiri della libertà, 5', '42124', 3);
INSERT INTO contact (number, employee_cf) VALUES ('+39 3425786932', 'GRZMTT83G40F230E');
INSERT INTO contact (number, employee_cf) VALUES ('+39 059 415622', 'GRZMTT83G40F230E');
INSERT INTO contact (number, employee_cf) VALUES ('+39 3319692342', 'SNGMJT80L08F257P');
INSERT INTO contact (number, employee_cf) VALUES ('+39 0642 25428', 'RSSMRA77P03D150X');
INSERT INTO contact (number, employee_cf) VALUES ('+39 3459611329', 'BNCLGU91C23G224S');
INSERT INTO message ("timestamp", text, resource_id, employee_cf) VALUES ('2018-08-22 17:40:40', 'batterie avviamento sistema ricarica', 11, 'GRZMTT83G40F230E');
INSERT INTO message ("timestamp", text, resource_id, employee_cf) VALUES ('2018-08-22 17:41:11', 'ciclo manutenzione elettrogeno', 1, 'GRZMTT83G40F230E');
INSERT INTO message ("timestamp", text, resource_id, employee_cf) VALUES ('2018-08-22 17:41:18', 'verifiche vista controllo integrità prova carico', 4, 'GRZMTT83G40F230E');
INSERT INTO message ("timestamp", text, resource_id, employee_cf) VALUES ('2018-08-22 17:41:27', 'integrità chiusure segregazioni', 6, 'GRZMTT83G40F230E');
INSERT INTO message ("timestamp", text, resource_id, employee_cf) VALUES ('2018-08-22 17:41:36', 'equilibrio fasi uscita carico', 12, 'GRZMTT83G40F230E');
INSERT INTO message ("timestamp", text, resource_id, employee_cf) VALUES ('2018-08-22 17:41:42', 'ciclo manutenzione elettrogeno', 1, 'SNGMJT80L08F257P');
INSERT INTO message ("timestamp", text, resource_id, employee_cf) VALUES ('2018-08-22 17:41:45', 'funzionamento apparecchiature strumentali', 5, 'SNGMJT80L08F257P');
INSERT INTO message ("timestamp", text, resource_id, employee_cf) VALUES ('2018-08-22 17:41:48', 'batterie avviamento sistema ricarica', 11, 'SNGMJT80L08F257P');
INSERT INTO session (id) VALUES (1000);
INSERT INTO session (id) VALUES (1001);
INSERT INTO session (id) VALUES (1002);
INSERT INTO session (id) VALUES (1003);
INSERT INTO session (id) VALUES (1004);
INSERT INTO shift (id, shift_date, employee_cf, session_id, hour_start, hour_end) VALUES (1, '2018-08-19', 'GRZMTT83G40F230E', 1002, 11, 17);
INSERT INTO shift (id, shift_date, employee_cf, session_id, hour_start, hour_end) VALUES (2, '2018-08-19', 'RSSMRA77P03D150X', 1003, 15, 20);
INSERT INTO shift (id, shift_date, employee_cf, session_id, hour_start, hour_end) VALUES (3, '2018-08-19', 'BNCLGU91C23G224S', 1004, 10, 20);
INSERT INTO shift (id, shift_date, employee_cf, session_id, hour_start, hour_end) VALUES (4, '2018-08-21', 'SNGMJT80L08F257P', 1000, 10, 18);
INSERT INTO shift (id, shift_date, employee_cf, session_id, hour_start, hour_end) VALUES (5, '2018-08-21', 'RSSMRA77P03D150X', 1001, 5, 13);
INSERT INTO shift (id, shift_date, employee_cf, session_id, hour_start, hour_end) VALUES (6, '2018-08-21', 'BNCLGU91C23G224S', 1002, 6, 14);
INSERT INTO shift (id, shift_date, employee_cf, session_id, hour_start, hour_end) VALUES (7, '2018-08-21', 'SRGFRT89C10H223C', 1003, 10, 19);
INSERT INTO shift (id, shift_date, employee_cf, session_id, hour_start, hour_end) VALUES (8, '2018-08-22', 'GRZMTT83G40F230E', 1000, 5, 13);
INSERT INTO shift (id, shift_date, employee_cf, session_id, hour_start, hour_end) VALUES (9, '2018-08-22', 'SRGFRT89C10H223C', 1001, 4, 12);
INSERT INTO shift (id, shift_date, employee_cf, session_id, hour_start, hour_end) VALUES (10, '2018-08-22', 'PNFFNC84D07I462B', 1002, 3, 11);
INSERT INTO maintainer (shift_id) VALUES (1);
INSERT INTO maintainer (shift_id) VALUES (2);
INSERT INTO maintainer (shift_id) VALUES (4);
INSERT INTO maintainer (shift_id) VALUES (6);
INSERT INTO maintainer (shift_id) VALUES (9);
INSERT INTO dispatcher (shift_id) VALUES (3);
INSERT INTO dispatcher (shift_id) VALUES (5);
INSERT INTO dispatcher (shift_id) VALUES (7);
INSERT INTO dispatcher (shift_id) VALUES (8);
INSERT INTO dispatcher (shift_id) VALUES (10);
INSERT INTO condition (name) VALUES ('puntali protetti');
INSERT INTO condition (name) VALUES ('puntali non protetti');
INSERT INTO condition (name) VALUES ('parti scoperte in tensione entro 30 cm');
INSERT INTO condition (name) VALUES ('parti scoperte in tensione oltre 30 cm');
INSERT INTO condition (name) VALUES ('parti scoperte qualsiasi condizione');
INSERT INTO device (name, specs) VALUES ('guanti', 'gialli - ad uso lavorativo');
INSERT INTO device (name, specs) VALUES ('puntali', '0.9m');
INSERT INTO device (name, specs) VALUES ('maschera', NULL);
INSERT INTO device (name, specs) VALUES ('indumenti a norma', NULL);
INSERT INTO task (name, description, resource_id) VALUES ('ELETT_00', 'Consente di dimostrare il corretto funzionamento del gruppo elettrogeno', 6);
INSERT INTO task (name, description, resource_id) VALUES ('ELETT_01', 'Analisi elettrogeno per identificare eventuali danni', 7);
INSERT INTO task (name, description, resource_id) VALUES ('ELETT_02', 'Controllo del quadro per la verifica dei corretti messaggi di segnalazione', 8);
INSERT INTO task (name, description, resource_id) VALUES ('ELETT_03', 'Prova interna sul flusso delle scariche elettriche di tensione', 9);
INSERT INTO task (name, description, resource_id) VALUES ('ELETT_04', 'Messa in sicurezza quadro a seguito di infiltrazione acqua condensata', 10);
INSERT INTO task (name, description, resource_id) VALUES ('ELETT_05', 'Riparazione delle batterie per il funzionamento del gruppo', 11);
INSERT INTO task (name, description, resource_id) VALUES ('ELETT_06', 'Bilanciamento delle fasi per il controllo del carico', 12);
INSERT INTO groupn (title, damage, risk) VALUES ('PE00', 3, 2);
INSERT INTO groupn (title, damage, risk) VALUES ('PE01', 3, 1);
INSERT INTO groupn (title, damage, risk) VALUES ('PE02', 3, 3);
INSERT INTO condition_groupn (condition_name, groupn_title) VALUES ('puntali protetti', 'PE00');
INSERT INTO condition_groupn (condition_name, groupn_title) VALUES ('parti scoperte in tensione entro 30 cm', 'PE00');
INSERT INTO condition_groupn (condition_name, groupn_title) VALUES ('puntali protetti', 'PE01');
INSERT INTO condition_groupn (condition_name, groupn_title) VALUES ('parti scoperte in tensione oltre 30 cm', 'PE01');
INSERT INTO condition_groupn (condition_name, groupn_title) VALUES ('puntali non protetti', 'PE02');
INSERT INTO condition_groupn (condition_name, groupn_title) VALUES ('parti scoperte qualsiasi condizione', 'PE02');
INSERT INTO device_groupn (device_name, groupn_title) VALUES ('guanti', 'PE00');
INSERT INTO device_groupn (device_name, groupn_title) VALUES ('indumenti a norma', 'PE00');
INSERT INTO device_groupn (device_name, groupn_title) VALUES ('guanti', 'PE01');
INSERT INTO device_groupn (device_name, groupn_title) VALUES ('indumenti a norma', 'PE01');
INSERT INTO device_groupn (device_name, groupn_title) VALUES ('guanti', 'PE02');
INSERT INTO device_groupn (device_name, groupn_title) VALUES ('puntali', 'PE02');
INSERT INTO device_groupn (device_name, groupn_title) VALUES ('indumenti a norma', 'PE02');
INSERT INTO task_groupn (task_name, groupn_title) VALUES ('ELETT_05', 'PE00');
INSERT INTO task_groupn (task_name, groupn_title) VALUES ('ELETT_05', 'PE01');
INSERT INTO task_groupn (task_name, groupn_title) VALUES ('ELETT_06', 'PE00');
INSERT INTO task_groupn (task_name, groupn_title) VALUES ('ELETT_06', 'PE01');
INSERT INTO task_groupn (task_name, groupn_title) VALUES ('ELETT_06', 'PE02');
INSERT INTO intervention (maintainer_shift_id, task_name, town_cap, address, description, start_at, end_at) VALUES (1, 'ELETT_01', '41012 ', 'Autostrada A22, km 7', 'Esecuzione intervento di riparazione e controllo causa maltempo bollino rosso', '2018-08-19 11:23:00', '2018-08-19 13:18:00');
INSERT INTO intervention (maintainer_shift_id, task_name, town_cap, address, description, start_at, end_at) VALUES (1, 'ELETT_01', '41012 ', 'Autostrada A22, km 7', 'Esecuzione intervento di riparazione e controllo causa maltempo bollino rosso', '2018-08-19 12:23:00', '2018-08-19 15:36:00');
INSERT INTO intervention (maintainer_shift_id, task_name, town_cap, address, description, start_at, end_at) VALUES (2, 'ELETT_05', '41123 ', 'Autostrada A1, km 4', 'Esecuzione intervento di riparazione e controllo causa maltempo bollino rosso', '2018-08-19 16:37:00', '2018-08-19 18:24:00');
INSERT INTO intervention (maintainer_shift_id, task_name, town_cap, address, description, start_at, end_at) VALUES (4, 'ELETT_00', '41123 ', 'Autostrada A1, km 11', 'Controllo di routine', '2018-08-21 11:18:00', '2018-08-21 11:43:00');
INSERT INTO intervention (maintainer_shift_id, task_name, town_cap, address, description, start_at, end_at) VALUES (4, 'ELETT_02', '41123 ', 'Autostrada A1, km 11', 'Controllo di routine', '2018-08-21 15:27:00', '2018-08-21 16:08:00');
INSERT INTO intervention (maintainer_shift_id, task_name, town_cap, address, description, start_at, end_at) VALUES (6, 'ELETT_03', '41123 ', 'Autostrada A1, km 11', 'Controllo di routine', '2018-08-21 06:33:00', '2018-08-21 07:24:00');
INSERT INTO intervention (maintainer_shift_id, task_name, town_cap, address, description, start_at, end_at) VALUES (6, 'ELETT_06', '41123 ', 'Autostrada A1, km 11', 'Controllo di routine', '2018-08-21 12:58:00', '2018-08-21 13:21:00');
INSERT INTO intervention (maintainer_shift_id, task_name, town_cap, address, description, start_at, end_at) VALUES (9, 'ELETT_04', '42124 ', 'Autostrada A1, km 53', 'Manutenzione per problemi tecnici rilevati', '2018-08-22 05:42:00', '2018-08-22 06:51:00');
INSERT INTO intervention (maintainer_shift_id, task_name, town_cap, address, description, start_at, end_at) VALUES (9, 'ELETT_06', '42124 ', 'Autostrada A1, km 53', 'Regolazione carico del gruppo', '2018-08-22 10:22:00', '2018-08-22 11:13:00');
INSERT INTO inventory (nr, device_name, description) VALUES (1, 'puntali', NULL);
INSERT INTO inventory (nr, device_name, description) VALUES (2, 'puntali', NULL);
INSERT INTO inventory (nr, device_name, description) VALUES (3, 'puntali', NULL);
INSERT INTO inventory (nr, device_name, description) VALUES (4, 'puntali', NULL);
INSERT INTO inventory (nr, device_name, description) VALUES (1, 'guanti', NULL);
INSERT INTO inventory (nr, device_name, description) VALUES (2, 'guanti', NULL);
INSERT INTO inventory (nr, device_name, description) VALUES (3, 'guanti', NULL);
INSERT INTO inventory (nr, device_name, description) VALUES (4, 'guanti', NULL);
INSERT INTO inventory (nr, device_name, description) VALUES (1, 'maschera', 'Modello sostituito a causa di danneggiamenti');
INSERT INTO inventory (nr, device_name, description) VALUES (2, 'maschera', NULL);
INSERT INTO inventory (nr, device_name, description) VALUES (1, 'indumenti a norma', NULL);
INSERT INTO inventory (nr, device_name, description) VALUES (2, 'indumenti a norma', NULL);
INSERT INTO borrow (inventory_nr, inventory_device_name, maintainer_shift_id, motivation, start_at, end_at) VALUES (1, 'guanti', 2, 'DPI minimale per classe di pericolo indicata PE00', '2018-08-19 16:25:00', '2018-08-19 18:38:00');
INSERT INTO borrow (inventory_nr, inventory_device_name, maintainer_shift_id, motivation, start_at, end_at) VALUES (1, 'indumenti a norma', 2, 'DPI minimale per classe di pericolo indicata PE00', '2018-08-19 16:25:00', '2018-08-19 18:38:00');
INSERT INTO borrow (inventory_nr, inventory_device_name, maintainer_shift_id, motivation, start_at, end_at) VALUES (1, 'guanti', 6, 'DPI minimale per classe di pericolo indicata PE01', '2018-08-21 12:50:00', '2018-08-21 13:30:00');
INSERT INTO borrow (inventory_nr, inventory_device_name, maintainer_shift_id, motivation, start_at, end_at) VALUES (1, 'indumenti a norma', 6, 'DPI minimale per classe di pericolo indicata PE01', '2018-08-21 12:50:00', '2018-08-21 13:30:00');
INSERT INTO borrow (inventory_nr, inventory_device_name, maintainer_shift_id, motivation, start_at, end_at) VALUES (1, 'guanti', 9, 'DPI minimale per classe di pericolo indicata PE02', '2018-08-22 10:15:00', '2018-08-22 11:28:00');
INSERT INTO borrow (inventory_nr, inventory_device_name, maintainer_shift_id, motivation, start_at, end_at) VALUES (1, 'indumenti a norma', 9, 'DPI minimale per classe di pericolo indicata PE02', '2018-08-22 10:15:00', '2018-08-22 11:28:00');
INSERT INTO borrow (inventory_nr, inventory_device_name, maintainer_shift_id, motivation, start_at, end_at) VALUES (1, 'puntali', 9, 'DPI minimale per classe di pericolo indicata PE02', '2018-08-22 10:15:00', '2018-08-22 11:28:00');
INSERT INTO assistance (ticket, maintainer_shift_id, start_at, end_at) VALUES (1, 1, '2018-08-19 13:04:11', '2018-08-19 13:27:35');
INSERT INTO assistance (ticket, maintainer_shift_id, start_at, end_at) VALUES (2, 2, '2018-08-19 16:04:11', '2018-08-19 16:27:35');
INSERT INTO assistance (ticket, maintainer_shift_id, start_at, end_at) VALUES (3, 4, '2018-08-21 10:58:43', '2018-08-21 11:07:12');
INSERT INTO assistance (ticket, maintainer_shift_id, start_at, end_at) VALUES (4, 4, '2018-08-21 16:18:39', '2018-08-21 16:37:22');
INSERT INTO assistance (ticket, maintainer_shift_id, start_at, end_at) VALUES (5, 6, '2018-08-21 10:34:25', '2018-08-21 11:13:48');
INSERT INTO assistance (ticket, maintainer_shift_id, start_at, end_at) VALUES (6, 9, '2018-08-22 06:51:35', '2018-08-22 07:04:06');
INSERT INTO attendee (assistance_ticket, dispatcher_shift_id) VALUES (1, 3);
INSERT INTO attendee (assistance_ticket, dispatcher_shift_id) VALUES (2, 3);
INSERT INTO attendee (assistance_ticket, dispatcher_shift_id) VALUES (3, 5);
INSERT INTO attendee (assistance_ticket, dispatcher_shift_id) VALUES (4, 7);
INSERT INTO attendee (assistance_ticket, dispatcher_shift_id) VALUES (5, 7);
INSERT INTO attendee (assistance_ticket, dispatcher_shift_id) VALUES (6, 8);
INSERT INTO attendee (assistance_ticket, dispatcher_shift_id) VALUES (6, 10);
 
/*
* Controllo se un dipendente inserito come manutentore con un particolare shift_id non si ripeta nella tabella other_table
* other_table è un parametro, in modo da generalizzare la function a qualsiasi tabella passata in parametro.
* Per ora le tabelle di interesse sono: 'dispatcher', 'maintainer'
* Vedere sezione Vincoli Aggiuntivi
*/
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


/*
* Controllo se la risorsa in questione fa riferimento a un nodo dell'albero di tipo foglia
*/
CREATE OR REPLACE FUNCTION is_resource_a_leaf ()
  RETURNS trigger AS $$
    DECLARE
      resource_tb record;
    BEGIN
      IF NEW.resource_id IS NOT NULL THEN
        SELECT resource.id INTO resource_tb FROM resource WHERE resource.parent = NEW.resource_id;
        IF resource_tb IS NOT NULL THEN
          RAISE EXCEPTION 'is_resource_a_leaf (%). resource_id is not a leaf', NEW.resource_id
            USING HINT = 'Please check your resource table';
        END IF;
      END IF;
      RETURN NEW;
    END
$$ LANGUAGE 'plpgsql';/*
* Controllo se le date rientrano nei turni di un specifico dipendente che fa un operazione 
* Vedere sezione  'Vincoli aggiuntivi'
* Funzione generica, usata dai triggers per ogni tabella di interesse (es intervention)
*/
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
          RAISE EXCEPTION 'shift_dates_equalities_function exception. Timestamp not valid for the shift'
          USING HINT = 'Please check your shift dates and the table start_at or end_at timestamps';
        END IF;
  
        IF NEW.end_at IS NOT NULL THEN
          SELECT * INTO _shift FROM shift WHERE id = NEW.maintainer_shift_id
          AND NEW.end_at BETWEEN shift_date + interval '1 hour' * hour_start AND shift_date + interval '1 hour' * hour_end;
        END IF;
        
        IF _shift IS NULL THEN
          RAISE EXCEPTION 'shift_dates_equalities_function exception. Timestamp not valid for the shift'
          USING HINT = 'Please check your shift dates and the table start_at or end_at timestamps';
        END IF;
      RETURN NEW;
    END
$$ LANGUAGE 'plpgsql';


/*
* Controllo se un dipendente inserito come manutentore con un particolare shift_id non si ripeta nella tabella other_table
* other_table è un parametro, in modo da generalizzare la function a qualsiasi tabella passata in parametro.
* Per ora le tabelle di interesse sono: 'dispatcher', 'maintainer'
* Vedere sezione Vincoli Aggiuntivi
*/
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


/*
* Controllo se la risorsa in questione fa riferimento a un nodo dell'albero di tipo foglia
*/
CREATE OR REPLACE FUNCTION is_resource_a_leaf ()
  RETURNS trigger AS $$
    DECLARE
      resource_tb record;
    BEGIN
      IF NEW.resource_id IS NOT NULL THEN
        SELECT resource.id INTO resource_tb FROM resource WHERE resource.parent = NEW.resource_id;
        IF resource_tb IS NOT NULL THEN
          RAISE EXCEPTION 'is_resource_a_leaf (%). resource_id is not a leaf', NEW.resource_id
            USING HINT = 'Please check your resource table';
        END IF;
      END IF;
      RETURN NEW;
    END
$$ LANGUAGE 'plpgsql';/*
* Controllo se le date rientrano nei turni di un specifico dipendente che fa un operazione 
* Vedere sezione  'Vincoli aggiuntivi'
* Funzione generica, usata dai triggers per ogni tabella di interesse (es intervention)
*/
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
          RAISE EXCEPTION 'shift_dates_equalities_function exception. Timestamp not valid for the shift'
          USING HINT = 'Please check your shift dates and the table start_at or end_at timestamps';
        END IF;
  
        IF NEW.end_at IS NOT NULL THEN
          SELECT * INTO _shift FROM shift WHERE id = NEW.maintainer_shift_id
          AND NEW.end_at BETWEEN shift_date + interval '1 hour' * hour_start AND shift_date + interval '1 hour' * hour_end;
        END IF;
        
        IF _shift IS NULL THEN
          RAISE EXCEPTION 'shift_dates_equalities_function exception. Timestamp not valid for the shift'
          USING HINT = 'Please check your shift dates and the table start_at or end_at timestamps';
        END IF;
      RETURN NEW;
    END
$$ LANGUAGE 'plpgsql';


/*
* Controllo se un dipendente inserito come manutentore con un particolare shift_id non si ripeta nella tabella other_table
* other_table è un parametro, in modo da generalizzare la function a qualsiasi tabella passata in parametro.
* Per ora le tabelle di interesse sono: 'dispatcher', 'maintainer'
* Vedere sezione Vincoli Aggiuntivi
*/
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


/*
* Controllo se la risorsa in questione fa riferimento a un nodo dell'albero di tipo foglia
*/
CREATE OR REPLACE FUNCTION is_resource_a_leaf ()
  RETURNS trigger AS $$
    DECLARE
      resource_tb record;
    BEGIN
      IF NEW.resource_id IS NOT NULL THEN
        SELECT resource.id INTO resource_tb FROM resource WHERE resource.parent = NEW.resource_id;
        IF resource_tb IS NOT NULL THEN
          RAISE EXCEPTION 'is_resource_a_leaf (%). resource_id is not a leaf', NEW.resource_id
            USING HINT = 'Please check your resource table';
        END IF;
      END IF;
      RETURN NEW;
    END
$$ LANGUAGE 'plpgsql';/*
* Controllo se le date rientrano nei turni di un specifico dipendente che fa un operazione 
* Vedere sezione  'Vincoli aggiuntivi'
* Funzione generica, usata dai triggers per ogni tabella di interesse (es intervention)
*/
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
          RAISE EXCEPTION 'shift_dates_equalities_function exception. Timestamp not valid for the shift'
          USING HINT = 'Please check your shift dates and the table start_at or end_at timestamps';
        END IF;
  
        IF NEW.end_at IS NOT NULL THEN
          SELECT * INTO _shift FROM shift WHERE id = NEW.maintainer_shift_id
          AND NEW.end_at BETWEEN shift_date + interval '1 hour' * hour_start AND shift_date + interval '1 hour' * hour_end;
        END IF;
        
        IF _shift IS NULL THEN
          RAISE EXCEPTION 'shift_dates_equalities_function exception. Timestamp not valid for the shift'
          USING HINT = 'Please check your shift dates and the table start_at or end_at timestamps';
        END IF;
      RETURN NEW;
    END
$$ LANGUAGE 'plpgsql';


CREATE TRIGGER media_is_resource_a_leaf_trigger
  BEFORE INSERT OR UPDATE
  ON attachment
  FOR EACH ROW EXECUTE PROCEDURE is_resource_a_leaf();
CREATE TRIGGER task_is_resource_a_leaf_trigger
  BEFORE INSERT OR UPDATE
  ON task
  FOR EACH ROW EXECUTE PROCEDURE is_resource_a_leaf();
CREATE TRIGGER shift_overlap_employee_maintainer_trigger
  BEFORE INSERT OR UPDATE
  ON maintainer
  FOR EACH ROW EXECUTE PROCEDURE shift_overlap_employee_type('maintainer');

CREATE TRIGGER shift_overlap_employee_dispatcher_trigger
  BEFORE INSERT OR UPDATE
  ON dispatcher
  FOR EACH ROW EXECUTE PROCEDURE shift_overlap_employee_type('dispatcher');CREATE TRIGGER shift_dates_equalities_assistance_trigger
  BEFORE INSERT OR UPDATE
  ON assistance
  FOR EACH ROW EXECUTE PROCEDURE shift_dates_equalities_function();

CREATE OR REPLACE FUNCTION dispatcher_shift_equalities_function()
  RETURNS trigger AS $$
    DECLARE
      _shift record;
    BEGIN

      SELECT shift.* INTO _shift FROM shift, assistance WHERE NEW.assistance_ticket = assistance.ticket
        AND shift.id = NEW.dispatcher_shift_id
        AND assistance.start_at BETWEEN shift_date + interval '1 hour' * hour_start AND shift_date + interval '1 hour' * hour_end;
  
      IF _shift IS NULL THEN
        RAISE EXCEPTION 'dispatcher_shift_equalities_function exception. Shift or Timestamp not valid'
        USING HINT = 'Please check your shift dates and the table start_at or end_at timestamps';
      END IF;
  
      SELECT shift.* INTO _shift FROM shift, assistance WHERE NEW.assistance_ticket = assistance.ticket
        AND shift.id = NEW.dispatcher_shift_id
        AND (assistance.end_at IS NULL OR assistance.end_at BETWEEN shift_date + interval '1 hour' * hour_start 
          AND shift_date + interval '1 hour' * hour_end);

      IF _shift IS NULL THEN
        RAISE EXCEPTION 'dispatcher_shift_equalities_function exception. Shift or Timestamp not valid'
        USING HINT = 'Please check your shift dates and the table start_at or end_at timestamps';
      END IF;
      RETURN NEW;
    END
$$ LANGUAGE 'plpgsql';

CREATE TRIGGER dispatcher_shift_equalities_assistance_trigger
  BEFORE INSERT OR UPDATE
  ON attendee
  FOR EACH ROW EXECUTE PROCEDURE dispatcher_shift_equalities_function();-- Un manutentore non può fare altre assistenze fino a quando non ha terminato quella presente

CREATE OR REPLACE FUNCTION maintainer_is_already_occupied_assistance()
  RETURNS trigger AS $$
    DECLARE
      _assistances record;
    BEGIN
      SELECT maintainer_shift_id INTO _assistances FROM assistance WHERE maintainer_shift_id = NEW.maintainer_shift_id AND end_at IS NULL;
      IF _assistances IS NOT NULL THEN
        RAISE EXCEPTION 'maintainer_is_already_occupied_assistance exception. The maintaner had to finish others assistance first!'
        USING HINT = 'Please check assistance';
      END IF;
      RETURN NEW;
    END
$$ LANGUAGE 'plpgsql';

CREATE TRIGGER maintainer_is_already_occupied_assistance_trigger
  BEFORE INSERT
  ON assistance
  FOR EACH ROW EXECUTE PROCEDURE maintainer_is_already_occupied_assistance();CREATE TRIGGER shift_dates_equalities_intervention_trigger
  BEFORE INSERT OR UPDATE
  ON intervention
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

CREATE TRIGGER shift_dates_equalities_borrow_trigger
  BEFORE INSERT OR UPDATE
  ON borrow
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
