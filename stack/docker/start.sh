#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

if [[ ! ${SERVICE_NAME+x} ]]; then
   bash
fi

case "${SERVICE_NAME}" in
"web")
  if [[ ${RUN_DB_CREATE+x} ]]; then
    bundle exec rake db:reset
  fi

  if [[ ${RUN_DB_MIGRATE+x} ]]; then
    bundle exec rake db:migrate
  fi

  PORT=${PORT:-3000}
  bundle exec rake assets:precompile
  bundle exec rails s -p ${PORT}
  ;;
"worker")
  bundle exec sidekiq -c 5 -v
  ;;
esac
