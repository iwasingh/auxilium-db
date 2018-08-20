PROJECT = auxilium-db
WORKDIR = `pwd`

.PHONY: sql test

sql: 
	@for i in $$(ls sqls | cut -d" " -f 1 | sort -n | sed 's/[^0-9]*//g'); do cat "sqls/$$i "*; done

test:
	$(foreach var,$(.VARIABLES),$(info $(var) = $($(var))))


