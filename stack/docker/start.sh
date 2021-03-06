#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

function main {
  /etc/init.d/nginx stop
  /etc/init.d/nginx restart

  # nohup bundle exec sidekiq -e production -C config/sidekiq.yml </dev/null >/dev/null 2>&1 & \
  bundle exec unicorn -c config/unicorn.rb
}


main
