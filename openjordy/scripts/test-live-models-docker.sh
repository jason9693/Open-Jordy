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

echo "==> Run live model tests (profile keys)"
docker run --rm -t \
  --entrypoint bash \
  -e COREPACK_ENABLE_DOWNLOAD_PROMPT=0 \
  -e HOME=/home/node \
  -e NODE_OPTIONS=--disable-warning=ExperimentalWarning \
  -e OPENJORDY_LIVE_TEST=1 \
  -e OPENJORDY_LIVE_MODELS="${OPENJORDY_LIVE_MODELS:-${JORDYDBOT_LIVE_MODELS:-modern}}" \
  -e OPENJORDY_LIVE_PROVIDERS="${OPENJORDY_LIVE_PROVIDERS:-${JORDYDBOT_LIVE_PROVIDERS:-}}" \
  -e OPENJORDY_LIVE_MAX_MODELS="${OPENJORDY_LIVE_MAX_MODELS:-${JORDYDBOT_LIVE_MAX_MODELS:-48}}" \
  -e OPENJORDY_LIVE_MODEL_TIMEOUT_MS="${OPENJORDY_LIVE_MODEL_TIMEOUT_MS:-${JORDYDBOT_LIVE_MODEL_TIMEOUT_MS:-}}" \
  -e OPENJORDY_LIVE_REQUIRE_PROFILE_KEYS="${OPENJORDY_LIVE_REQUIRE_PROFILE_KEYS:-${JORDYDBOT_LIVE_REQUIRE_PROFILE_KEYS:-}}" \
  -v "$CONFIG_DIR":/home/node/.openjordy \
  -v "$WORKSPACE_DIR":/home/node/.openjordy/workspace \
  "${PROFILE_MOUNT[@]}" \
  "$IMAGE_NAME" \
  -lc "set -euo pipefail; [ -f \"$HOME/.profile\" ] && source \"$HOME/.profile\" || true; cd /app && pnpm test:live"
