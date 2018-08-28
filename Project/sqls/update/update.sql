 
-- Aggiornare un intervento di un particolare manutentore con una data di fine.
-- Questo update darà un errore poichè non combacia il turno con l'orario (vedere Vincoli aggiuntivi)
UPDATE intervention SET end_at = '2019-01-01 10:00:00' WHERE maintainer_shift_id = 1 
-- Modificare l'indirizzo a 'Via Baldassare Peruzzi' del dipendente con codice fiscale ASDASDASD234325Z
UPDATE employee SET address = 'Via Baldassare Peruzzi' WHERE cf = 'ASDASDASD234325Z';
-- Aggiornare la descrizione del dispositivo 'guanti' con 'verdi - ad uso lavorativo'
UPDATE device SET specs = 'verdi - ad uso lavorativo' WHERE name = 'guanti';
