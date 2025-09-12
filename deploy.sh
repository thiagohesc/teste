#!/usr/bin/env bash
set -Eeuo pipefail

ENV="${1:-dev}"          # dev | prod
ACTION="${2:-up}"        # up | down | status | logs | pull | rebuild
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
COMPOSE_FILE="$ROOT_DIR/docker-compose.$ENV.yml"
ENV_FILE="$ROOT_DIR/.env.$ENV"

log(){ printf '[%s] %s\n' "$(date +%F_%T)" "$*"; }

# sanity checks
[ -f "$COMPOSE_FILE" ] || { echo "Compose não encontrado: $COMPOSE_FILE"; exit 2; }
[ -f "$ENV_FILE" ] && ENV_OPT=(--env-file "$ENV_FILE") || ENV_OPT=()

case "$ACTION" in
  up)
    log "Pull de imagens ($ENV)…"
    docker compose -f "$COMPOSE_FILE" "${ENV_OPT[@]}" pull || true
    log "Subindo stack ($ENV)…"
    docker compose -f "$COMPOSE_FILE" "${ENV_OPT[@]}" up -d --remove-orphans
    ;;

  down)
    log "Derrubando stack ($ENV)…"
    docker compose -f "$COMPOSE_FILE" "${ENV_OPT[@]}" down
    ;;

  status)
    docker compose -f "$COMPOSE_FILE" "${ENV_OPT[@]}" ps
    ;;

  logs)
    # tail follow dos serviços (Ctrl+C para sair)
    docker compose -f "$COMPOSE_FILE" "${ENV_OPT[@]}" logs -f --tail=200
    ;;

  pull)
    log "Pull de imagens ($ENV)…"
    docker compose -f "$COMPOSE_FILE" "${ENV_OPT[@]}" pull
    ;;

  rebuild)
    # se você builda localmente (em vez de usar imagens do registry)
    log "Buildando imagens ($ENV)…"
    docker compose -f "$COMPOSE_FILE" "${ENV_OPT[@]}" build --pull
    log "Subindo stack ($ENV)…"
    docker compose -f "$COMPOSE_FILE" "${ENV_OPT[@]}" up -d --remove-orphans
    ;;

  *)
    echo "Uso: $0 {ENV} {up|down|status|logs|pull|rebuild}"
    echo "Ex.: $0 prod up"
    exit 2
    ;;
esac
