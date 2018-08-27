-- Eliminare tutti gli allegati che si riferiscono alle risorse che hanno nel titolo la parola 'informazioni'

DELETE FROM attachment WHERE resource_id 
  IN (SELECT resource.id FROM resource WHERE resource.title LIKE '%informazioni%');
