#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

tag="$1"
# This env var allows to re-use the same docker cached
# layers when building images for different environments
app="${TARGET_APP:-cheidelcoriera}"

docker build -t "${app}:${tag}" -f Dockerfile.worker .
docker tag "${app}:${tag}" "registry.heroku.com/${app}/worker"
docker push "registry.heroku.com/${app}/worker"
heroku container:release worker -a "${app}"
