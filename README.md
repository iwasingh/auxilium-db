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
        ├── auxilium.sql                # File contenente il sql di creazione e inserimento e triggers(generato dal comando make sql)
        ├── export.sql                  # File di esportazione ottenuto da postgresql
        ├── create                      # Query creazione
        ├── insert                      # Query inserimento
        ├── delete                      # Query eliminazione
        ├── select                      # Query di interrogazione
        ├── triggers                    # Triggers/Procedure
        └── update                      # Query di aggiornamento
```
## Import Database
Sono presenti 2 file nella directory ```sqls```. È possibile sfruttare questi 2 file per creare il database con i dati, tabelle e triggers.
* auxilium.sql - file generato tramite script Makefile. Copiare il contenuto e incollarlo su Query tool ed eseguire il tutto.
* export.sql - file generato dal pgAdmin. Al click destro su un database usare l'opzione ```Restore```, quindi selezionare il file ```export.sql```  per importare tutti i dati

Nel caso si fossero problemi con un file è possibile provare con l'altro. Ricordare ovviamente di create il database prima di operare con uno dei 2 file:
```CREATE DATABASE auxilium```

## Generazione sql
Di fronte all'esigenza di gestire il codice sql e al suo utilizzo, si è creato uno script che generasse un file unico prendendo le varie query in ordine dai file sotto ogni cartella 
Quindi a seguito di una modifica basta lanciare un comando per avere il sql aggiornanto e pronto all'uso.
È possibile generare direttamente il sql tramite i seguenti comandi make dalla directory ```Project```(testato solo su Debian 9). In alternativa
è comunque possibile ottenere il codice sql da ogni singolo file presente nelle sottodirectory sotto ```sqls``` oppure semplicemente copiando
e incollando il contenuto del file ```auxilium.sql```

Per la generazione è importante quindi posizionarsi sulla directory Project ed avere [make](https://www.gnu.org/software/make/)
```
cd Project
```
e successivamente eseguire i comandi esposti.

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

## Autori 

* **Singh Amarjot** 
* **Matteo Guerzoni**

## Licenza
Alcuni diritti sono riservati
