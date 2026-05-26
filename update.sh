#!/bin/bash
set -e

cd "$(dirname "$0")"

command -v docker >/dev/null || { echo "Docker not found"; exit 1; }

# Generate nginx config from template
export $(grep -v '^#' config/.env | xargs)
envsubst '${DOMAIN}' < network/nginx/default.conf.template > network/nginx/default.conf

docker network create network-docker-server 2>/dev/null || true

for stack in arr_stack games network apps; do
  COMPOSE="./$stack/docker-compose.yml"
  [ -f "$COMPOSE" ] || continue

  echo "==> $stack"
  docker compose -f "$COMPOSE" --env-file ./config/.env pull
  docker compose -f "$COMPOSE" --env-file ./config/.env up -d
done

docker image prune -a -f
