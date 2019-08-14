#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

function main {
  /etc/init.d/nginx stop

  bundle exec sidekiq -e production -C config/sidekiq.yml
}


main
