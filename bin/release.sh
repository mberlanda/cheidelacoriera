#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

tag="$1"
# This env var allows to re-use the same docker cached
# layers when building images for different environments
app="${TARGET_APP:-cheidelacoriera}"

docker build -t "${app}:${tag}" -f Dockerfile.web .
docker tag "${app}:${tag}" "registry.heroku.com/${app}/web"
docker push "registry.heroku.com/${app}/web"
heroku container:release web -a "${app}"
