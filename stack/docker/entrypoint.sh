#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

function main {
  if [[ "${RAILS_DB_MIGRATE}" == "true" ]];
    bundle exec rake db:migrate
  fi
}

main