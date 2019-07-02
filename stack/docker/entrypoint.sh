#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

if [[ "${RAILS_DB_MIGRATE}" == "true" ]]; then
  bundle exec rake db:migrate
fi

exec "$@"