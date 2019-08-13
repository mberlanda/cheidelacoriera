#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

PORT=${PORT:-3001}
# export LD_PRELOAD=/usr/lib/x86_64-linux-gnu/libjemalloc.so.1

if [[ "${RAILS_DB_MIGRATE}" == "true" ]]; then
  bundle exec rake db:migrate
fi

# Path to PIDS and SOCK file
mkdir -p shared/pids shared/sockets

# Substitute $PORT in nginx config
sed -i -e 's/$PORT/'"$PORT"'/g' /etc/nginx/sites-available/default

exec "$@"
