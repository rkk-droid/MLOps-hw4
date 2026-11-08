.PHONY: up down load venv deps seed run test docs lint all pipeline

DBT := $(abspath .venv/bin/dbt)

up:
	docker compose up -d --wait

down:
	docker compose down

load: up
	./scripts/load_transactions.sh

venv:
	python3.12 -m venv .venv
	.venv/bin/pip install -r requirements.txt

deps:
	$(MAKE) -C dbt deps DBT="$(DBT)"

seed:
	$(MAKE) -C dbt seed DBT="$(DBT)"

run:
	$(MAKE) -C dbt run DBT="$(DBT)"

test:
	$(MAKE) -C dbt test DBT="$(DBT)"

docs:
	$(MAKE) -C dbt docs DBT="$(DBT)"

lint:
	.venv/bin/sqlfluff lint dbt/models dbt/macros dbt/tests dbt/seeds

all: deps seed run test

pipeline: load all
