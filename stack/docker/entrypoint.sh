#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

echo "Checking connectivity"
./stack/docker/db_ready

exec "$@"