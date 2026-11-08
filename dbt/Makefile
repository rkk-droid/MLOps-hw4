DBT ?= dbt
PROFILES := --profiles-dir .

.PHONY: deps seed run test docs all

deps:
	$(DBT) deps $(PROFILES)

seed:
	$(DBT) seed $(PROFILES)

run:
	$(DBT) run $(PROFILES)

test:
	$(DBT) test $(PROFILES)

docs:
	$(DBT) docs generate $(PROFILES)

all: deps seed run test
