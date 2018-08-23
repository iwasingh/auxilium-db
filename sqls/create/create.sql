 
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
  nr SERIAL, -- NOT NULL
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
