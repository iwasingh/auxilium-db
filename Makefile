PROJECT = auxilium-db
WORKDIR = `pwd`
SQLDIR  = ./sqls/
CREATE  = $(SQLDIR)create
INSERT  = $(SQLDIR)data
TRIGGERS = $(SQLDIR)triggers

CREATE_FILE 	= $(CREATE)/create.sql
INSERT_FILE 	= $(INSERT)/insert.sql
TRIGGERS_FILE = $(TRIGGERS)/triggers.sql

.PHONY: create insert triggers test

create: 
	@echo " " > $(CREATE)/create.sql
	@for i in $$(ls $(CREATE) | cut -d" " -f 1 | sort -n | sed 's/[^0-9]*//g'); do cat "$(CREATE)/$$i "*; cat "$(CREATE)/$$i "* >> $(CREATE)/create.sql; done

insert:
	@echo " " > $(INSERT)/insert.sql
	@for i in $$(ls $(INSERT) | cut -d" " -f 1 | sort -n | sed 's/[^0-9]*//g'); do cat "$(INSERT)/$$i "*; cat "$(INSERT)/$$i "* >> $(INSERT)/insert.sql; done

triggers:
	@echo " " > $(TRIGGERS)/triggers.sql
	@for i in $$(ls $(TRIGGERS) | cut -d" " -f 1 | sort -n | sed 's/[^0-9]*//g'); do cat "$(TRIGGERS)/$$i "*; cat "$(TRIGGERS)/$$i "* >> $(TRIGGERS)/triggers.sql; done

sql: create insert triggers
	cat $(CREATE_FILE) $(INSERT_FILE) $(TRIGGERS_FILE) > $(SQLDIR)auxilium.sql

test:
	$(foreach var,$(.VARIABLES),$(info $(var) = $($(var))))


