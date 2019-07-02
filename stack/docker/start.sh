#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

function main {
  nohup bundle exec sidekiq -e production -C config/sidekiq.yml </dev/null >/dev/null 2>&1 & \
  bundle exec puma -C config/puma.rb
}

main