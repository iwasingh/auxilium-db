# Auxilium
## Some facts
Questo progetto nasce a seguito dell'[Hackathon 2016 Var Group](https://www.vargroup.it/hackathon/).
Dopo la competizione si è scelto di estenderlo per proporlo come progetto d'esame per Basi di Dati.

## Struttura del progetto
```
├── Auxilium.pdf                        # Pdf del progetto
└── Project                             # Main directory del progetto
    ├── charts                          # Grafici e infografiche
    ├── dias                            # Tutti i file .dia
    ├── pngs                            # Tutti i file .pngs
    └── sqls                            # Tutti i file .sql
        ├── auxilium.sql                # File contenente il sql di creazione e inserimento(generato dal comando make sql)
        ├── export.sql                  # File di esportazione ottenuto da postgresql
        ├── create                      # Query creazione
        ├── insert                      # Query inserimento
        ├── delete                      # Query eliminazione
        ├── select                      # Query di interrogazione
        ├── triggers                    # Triggers/Procedure
        └── update                      # Query di aggiornamento
```
## Generazione sql
Se il file ```export.sql``` desse problemi, è possibile generare direttamente il sql tramite i seguenti comandi make dalla directory ```Project```.
È consigliabile usare il file ```export.sql``` poichè la generazione sql non è detto che funzioni(testato solo su Debian 9). In alternativa
è comunque possibile ottenere il codice sql da ogni singolo file presente nelle sottodirectory sotto ```sqls```


Per la generazione è importante quindi posizionarsi sulla directory Project
```
cd Project
```
e successivamente eseguire i comandi esposti.

```
#### Generazione dell'intero file sql 
Verrà generato il file ```auxilium.sql``` che sarà presente all'interno della directory ```sqls```
ATTENZIONE: questo file conterrà solo le query di CREAZIONE, INSERIMENTO E TRIGGERS/PROCEDURE
```
make sql
```
È possibile generare anche i vari spezzoni sql seguendo i seguenti comandi


#### Generazione query di creazione 
Questo comando genererà un file ```create.sql``` dentro la directory ```sqls/create```
```
make create
```

#### Generazione query di inserimento 
Questo comando genererà un file ```insert.sql``` dentro la directory ```sqls/insert```
```
make insert
```

#### Generazione query di eliminazione 
Questo comando genererà un file ```delete.sql``` dentro la directory ```sqls/delete```

```
make delete
```

#### Generazione query di aggiornamento 
Questo comando genererà un file ```update.sql``` dentro la directory ```sqls/update```

```
make update
```

#### Generazione triggers 
Questo comando genererà un file ```triggers.sql``` dentro la directory ```sqls/triggers```
```
make triggers
```
