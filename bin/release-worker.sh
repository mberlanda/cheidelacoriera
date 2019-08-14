#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

tag="$1"

docker build -t "cheidelacoriera:${tag}" -f Dockerfile.web .
docker tag "cheidelacoriera:${tag}" registry.heroku.com/cheidelacoriera/worker
docker push registry.heroku.com/cheidelacoriera/worker
heroku container:release worker -a cheidelacoriera
