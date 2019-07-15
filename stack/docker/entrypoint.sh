#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

if [[ "${RAILS_DB_MIGRATE}" == "true" ]]; then
  bundle exec rake db:migrate
fi

# Path to Puma PID and SOCK file
mkdir -p shared/pids shared/sockets

exec "$@"
