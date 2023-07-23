#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

PORT=${PORT:-3001}
RAILS_DB_SEED=${RAILS_DB_SEED:-false}
if [[ -f "/usr/lib/aarch64-linux-gnu/libjemalloc.so" ]]; then
  export LD_PRELOAD=/usr/lib/aarch64-linux-gnu/libjemalloc.so
fi
if [[ -f "/usr/lib/x86_64-linux-gnu/libjemalloc.so" ]]; then
  export LD_PRELOAD=/usr/lib/x86_64-linux-gnu/libjemalloc.so
fi

if [[ "${RAILS_DB_MIGRATE}" == "true" ]]; then
  bundle exec rake db:migrate
fi
if [[ "${RAILS_DB_SEED}" == "true" ]]; then
  bundle exec rails db:seed
fi

# Path to PIDS and SOCK file
mkdir -p shared/pids shared/sockets

# Substitute $PORT in nginx config
sed -i -e 's/$PORT/'"$PORT"'/g' /etc/nginx/sites-available/default

exec "$@"
