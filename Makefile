PROJECT = auxilium-db
WORKDIR = `pwd`
SQLDIR  = ./sqls/
CREATE  = $(SQLDIR)create
INSERT  = $(SQLDIR)data


.PHONY: create insert test

create: 
	@echo " " > $(CREATE)/create.sql
	@for i in $$(ls $(CREATE) | cut -d" " -f 1 | sort -n | sed 's/[^0-9]*//g'); do cat "$(CREATE)/$$i "*; cat "$(CREATE)/$$i "* >> $(CREATE)/create.sql; done

insert:
	@echo " " > $(INSERT)/data.sql
	@for i in $$(ls $(INSERT) | cut -d" " -f 1 | sort -n | sed 's/[^0-9]*//g'); do cat "$(INSERT)/$$i "*; cat "$(INSERT)/$$i "* >> $(INSERT)/data.sql; done

test:
	$(foreach var,$(.VARIABLES),$(info $(var) = $($(var))))


