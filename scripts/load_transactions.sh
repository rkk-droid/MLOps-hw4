#!/usr/bin/env bash
set -euo pipefail

root="$(cd "$(dirname "$0")/.." && pwd)"
cd "$root"

docker cp "$root/data/train.csv" hw04-clickhouse:/var/lib/clickhouse/user_files/train.csv

docker compose exec -T clickhouse \
  clickhouse-client --user default --password dbt --multiquery \
  < scripts/load_transactions.sql

docker compose exec -T clickhouse \
  clickhouse-client --user default --password dbt \
  --query "SELECT count() AS transactions FROM transactions_db.transactions"
