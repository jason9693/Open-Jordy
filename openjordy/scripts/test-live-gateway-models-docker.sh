#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
IMAGE_NAME="${OPENJORDY_IMAGE:-${JORDYDBOT_IMAGE:-openjordy:local}}"
CONFIG_DIR="${OPENJORDY_CONFIG_DIR:-${JORDYDBOT_CONFIG_DIR:-$HOME/.openjordy}}"
WORKSPACE_DIR="${OPENJORDY_WORKSPACE_DIR:-${JORDYDBOT_WORKSPACE_DIR:-$HOME/.openjordy/workspace}}"
PROFILE_FILE="${OPENJORDY_PROFILE_FILE:-${JORDYDBOT_PROFILE_FILE:-$HOME/.profile}}"

PROFILE_MOUNT=()
if [[ -f "$PROFILE_FILE" ]]; then
  PROFILE_MOUNT=(-v "$PROFILE_FILE":/home/node/.profile:ro)
fi

echo "==> Build image: $IMAGE_NAME"
docker build -t "$IMAGE_NAME" -f "$ROOT_DIR/Dockerfile" "$ROOT_DIR"

echo "==> Run gateway live model tests (profile keys)"
docker run --rm -t \
  --entrypoint bash \
  -e COREPACK_ENABLE_DOWNLOAD_PROMPT=0 \
  -e HOME=/home/node \
  -e NODE_OPTIONS=--disable-warning=ExperimentalWarning \
  -e OPENJORDY_LIVE_TEST=1 \
  -e OPENJORDY_LIVE_GATEWAY_MODELS="${OPENJORDY_LIVE_GATEWAY_MODELS:-${JORDYDBOT_LIVE_GATEWAY_MODELS:-modern}}" \
  -e OPENJORDY_LIVE_GATEWAY_PROVIDERS="${OPENJORDY_LIVE_GATEWAY_PROVIDERS:-${JORDYDBOT_LIVE_GATEWAY_PROVIDERS:-}}" \
  -e OPENJORDY_LIVE_GATEWAY_MAX_MODELS="${OPENJORDY_LIVE_GATEWAY_MAX_MODELS:-${JORDYDBOT_LIVE_GATEWAY_MAX_MODELS:-24}}" \
  -e OPENJORDY_LIVE_GATEWAY_MODEL_TIMEOUT_MS="${OPENJORDY_LIVE_GATEWAY_MODEL_TIMEOUT_MS:-${JORDYDBOT_LIVE_GATEWAY_MODEL_TIMEOUT_MS:-}}" \
  -v "$CONFIG_DIR":/home/node/.openjordy \
  -v "$WORKSPACE_DIR":/home/node/.openjordy/workspace \
  "${PROFILE_MOUNT[@]}" \
  "$IMAGE_NAME" \
  -lc "set -euo pipefail; [ -f \"$HOME/.profile\" ] && source \"$HOME/.profile\" || true; cd /app && pnpm test:live"
