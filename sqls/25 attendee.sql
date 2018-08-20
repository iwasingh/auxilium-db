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
