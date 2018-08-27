-- Aggiornare un intervento di un particolare manutentore con una data di fine.
-- Questo update darà un errore poichè non combacia il turno con l'orario (vedere Vincoli aggiuntivi)
UPDATE intervention SET end_at = '2019-01-01 10:00:00' WHERE maintainer_shift_id = 1 
