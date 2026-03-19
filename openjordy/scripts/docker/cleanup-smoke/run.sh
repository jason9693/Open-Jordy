#!/usr/bin/env bash
set -euo pipefail

cd /repo

export OPENJORDY_STATE_DIR="/tmp/openjordy-test"
export OPENJORDY_CONFIG_PATH="${OPENJORDY_STATE_DIR}/openjordy.json"

echo "==> Build"
pnpm build

echo "==> Seed state"
mkdir -p "${OPENJORDY_STATE_DIR}/credentials"
mkdir -p "${OPENJORDY_STATE_DIR}/agents/main/sessions"
echo '{}' >"${OPENJORDY_CONFIG_PATH}"
echo 'creds' >"${OPENJORDY_STATE_DIR}/credentials/marker.txt"
echo 'session' >"${OPENJORDY_STATE_DIR}/agents/main/sessions/sessions.json"

echo "==> Reset (config+creds+sessions)"
pnpm openjordy reset --scope config+creds+sessions --yes --non-interactive

test ! -f "${OPENJORDY_CONFIG_PATH}"
test ! -d "${OPENJORDY_STATE_DIR}/credentials"
test ! -d "${OPENJORDY_STATE_DIR}/agents/main/sessions"

echo "==> Recreate minimal config"
mkdir -p "${OPENJORDY_STATE_DIR}/credentials"
echo '{}' >"${OPENJORDY_CONFIG_PATH}"

echo "==> Uninstall (state only)"
pnpm openjordy uninstall --state --yes --non-interactive

test ! -d "${OPENJORDY_STATE_DIR}"

echo "OK"
