#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

tag="$1"
# This env var allows to re-use the same docker cached
# layers when building images for different environments
app="${TARGET_APP:-cheidelacoriera}"
# Use docker buildx if running on Apple silicon for heroku compatibility
if [ -x "$(command -v arch)" ]; then
  if [[ $(arch) == 'arm64' ]]; then
    docker buildx build --platform linux/amd64 -t "${app}:${tag}" -f Dockerfile.worker .
  else
    docker buildx build -t "${app}:${tag}" -f Dockerfile.worker .
  fi
else
  docker buildx build -t "${app}:${tag}" -f Dockerfile.worker .
fi

docker tag "${app}:${tag}" "registry.heroku.com/${app}/worker"
docker push "registry.heroku.com/${app}/worker"
heroku container:release worker -a "${app}"
