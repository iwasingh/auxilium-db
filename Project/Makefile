PROJECT = auxilium-db
WORKDIR = `pwd`
SQLDIR  = ./sqls/
CREATE  = $(SQLDIR)create
INSERT  = $(SQLDIR)insert
TRIGGERS = $(SQLDIR)triggers
DELETE = $(SQLDIR)delete
UPDATE = $(SQLDIR)update
SELECT = $(SQLDIR)select

CREATE_FILE 	= $(CREATE)/create.sql
INSERT_FILE 	= $(INSERT)/insert.sql
TRIGGERS_FILE = $(TRIGGERS)/triggers.sql
DELETE_FILE 	= $(DELETE)/delete.sql
UPDATE_FILE = $(UPDATE)/update.sql
SELECT_FILE = $(SELECT)/select.sql

.PHONY: create insert triggers select update delete clean sql test

create: 
	@echo " " > $(CREATE)/create.sql
	@for i in $$(ls $(CREATE) | cut -d" " -f 1 | sort -n | sed 's/[^0-9]*//g'); do cat "$(CREATE)/$$i "*; cat "$(CREATE)/$$i "* >> $(CREATE)/create.sql; done

insert:
	@echo " " > $(INSERT)/insert.sql
	@for i in $$(ls $(INSERT) | cut -d" " -f 1 | sort -n | sed 's/[^0-9]*//g'); do cat "$(INSERT)/$$i "*; cat "$(INSERT)/$$i "* >> $(INSERT)/insert.sql; done

triggers:
	@echo " " > $(TRIGGERS)/triggers.sql
	@for i in $$(ls $(TRIGGERS) | cut -d" " -f 1 | sort -n | sed 's/[^0-9]*//g'); do cat "$(TRIGGERS)/$$i "*; cat "$(TRIGGERS)/$$i "* >> $(TRIGGERS)/triggers.sql; done

delete:
	@echo " " > $(DELETE)/delete.sql
	@for i in $$(ls $(DELETE) | cut -d" " -f 1 | sort -n | sed 's/[^0-9]*//g'); do cat "$(DELETE)/$$i "*; cat "$(DELETE)/$$i "* >> $(DELETE)/delete.sql; done

update:
	@echo " " > $(UPDATE)/update.sql
	@for i in $$(ls $(UPDATE) | cut -d" " -f 1 | sort -n | sed 's/[^0-9]*//g'); do cat "$(UPDATE)/$$i "*; cat "$(UPDATE)/$$i "* >> $(UPDATE)/update.sql; done

select:
	@echo " " > $(SELECT)/select.sql
	@for i in $$(ls $(SELECT) | cut -d" " -f 1 | sort -n | sed 's/[^0-9]*//g'); do cat "$(SELECT)/$$i "*; cat "$(SELECT)/$$i "* >> $(SELECT)/select.sql; done

sql: create insert triggers
	cat $(CREATE_FILE) $(INSERT_FILE) $(TRIGGERS_FILE) > $(SQLDIR)auxilium.sql

clean:
		find $(CREATE_FILE) $(INSERT_FILE) $(TRIGGERS_FILE) $(DELETE_FILE) $(UPDATE_FILE) $(SELECT_FILE) -delete
test:
	$(foreach var,$(.VARIABLES),$(info $(var) = $($(var))))


