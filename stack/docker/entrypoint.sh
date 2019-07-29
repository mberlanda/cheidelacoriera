#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

PORT=${PORT:-3001}

if [[ "${RAILS_DB_MIGRATE}" == "true" ]]; then
  bundle exec rake db:migrate
fi

# Path to PIDS and SOCK file
mkdir -p shared/pids shared/sockets

# Substitute $PORT in nginx config
sed -i -e 's/$PORT/'"$PORT"'/g' /etc/nginx/sites-available/default
# /etc/init.d/nginx restart
# nginx -s reload
echo "Finished"

exec "$@"
