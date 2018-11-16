#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

sed -ri "s/#log_statement = 'none'/log_statement = 'all'/g" /var/lib/postgresql/data/postgresql.conf

DB_NAME=${DB_NAME:-cheidelacoriera_production}

psql -v ON_ERROR_STOP=1 --username postgres <<-EOSQL
  CREATE DATABASE ${DB_NAME};
  CREATE ROLE application NOLOGIN;
  GRANT ALL PRIVILEGES ON DATABASE ${DB_NAME} TO application;
  CREATE USER ${DB_USER} WITH PASSWORD '${DB_PASSWORD}' CREATEDB ;
  GRANT application TO ${DB_USER};
EOSQL
