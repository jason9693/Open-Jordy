#!/usr/bin/env bash
# JordyDock - Docker helpers for OpenJordy
# Inspired by Simon Willison's "Running OpenJordy in Docker"
# https://til.simonwillison.net/llms/openjordy-docker
#
# Installation:
#   mkdir -p ~/.jordydock && curl -sL https://raw.githubusercontent.com/openjordy/openjordy/main/scripts/shell-helpers/jordydock-helpers.sh -o ~/.jordydock/jordydock-helpers.sh
#   echo 'source ~/.jordydock/jordydock-helpers.sh' >> ~/.zshrc
#
# Usage:
#   jordydock-help    # Show all available commands

# =============================================================================
# Colors
# =============================================================================
_CLR_RESET='\033[0m'
_CLR_BOLD='\033[1m'
_CLR_DIM='\033[2m'
_CLR_GREEN='\033[0;32m'
_CLR_YELLOW='\033[1;33m'
_CLR_BLUE='\033[0;34m'
_CLR_MAGENTA='\033[0;35m'
_CLR_CYAN='\033[0;36m'
_CLR_RED='\033[0;31m'

# Styled command output (green + bold)
_clr_cmd() {
  echo -e "${_CLR_GREEN}${_CLR_BOLD}$1${_CLR_RESET}"
}

# Inline command for use in sentences
_cmd() {
  echo "${_CLR_GREEN}${_CLR_BOLD}$1${_CLR_RESET}"
}

# =============================================================================
# Config
# =============================================================================
JORDYDOCK_CONFIG="${HOME}/.jordydock/config"

# Common paths to check for OpenJordy
JORDYDOCK_COMMON_PATHS=(
  "${HOME}/openjordy"
  "${HOME}/workspace/openjordy"
  "${HOME}/projects/openjordy"
  "${HOME}/dev/openjordy"
  "${HOME}/code/openjordy"
  "${HOME}/src/openjordy"
)

_jordydock_filter_warnings() {
  grep -v "^WARN\|^time="
}

_jordydock_trim_quotes() {
  local value="$1"
  value="${value#\"}"
  value="${value%\"}"
  printf "%s" "$value"
}

_jordydock_read_config_dir() {
  if [[ ! -f "$JORDYDOCK_CONFIG" ]]; then
    return 1
  fi
  local raw
  raw=$(sed -n 's/^JORDYDOCK_DIR=//p' "$JORDYDOCK_CONFIG" | head -n 1)
  if [[ -z "$raw" ]]; then
    return 1
  fi
  _jordydock_trim_quotes "$raw"
}

# Ensure JORDYDOCK_DIR is set and valid
_jordydock_ensure_dir() {
  # Already set and valid?
  if [[ -n "$JORDYDOCK_DIR" && -f "${JORDYDOCK_DIR}/docker-compose.yml" ]]; then
    return 0
  fi

  # Try loading from config
  local config_dir
  config_dir=$(_jordydock_read_config_dir)
  if [[ -n "$config_dir" && -f "${config_dir}/docker-compose.yml" ]]; then
    JORDYDOCK_DIR="$config_dir"
    return 0
  fi

  # Auto-detect from common paths
  local found_path=""
  for path in "${JORDYDOCK_COMMON_PATHS[@]}"; do
    if [[ -f "${path}/docker-compose.yml" ]]; then
      found_path="$path"
      break
    fi
  done

  if [[ -n "$found_path" ]]; then
    echo ""
    echo "🦞 Found OpenJordy at: $found_path"
    echo -n "   Use this location? [Y/n] "
    read -r response
    if [[ "$response" =~ ^[Nn] ]]; then
      echo ""
      echo "Set JORDYDOCK_DIR manually:"
      echo "  export JORDYDOCK_DIR=/path/to/openjordy"
      return 1
    fi
    JORDYDOCK_DIR="$found_path"
  else
    echo ""
    echo "❌ OpenJordy not found in common locations."
    echo ""
    echo "Clone it first:"
    echo ""
    echo "  git clone https://github.com/openjordy/openjordy.git ~/openjordy"
    echo "  cd ~/openjordy && ./docker-setup.sh"
    echo ""
    echo "Or set JORDYDOCK_DIR if it's elsewhere:"
    echo ""
    echo "  export JORDYDOCK_DIR=/path/to/openjordy"
    echo ""
    return 1
  fi

  # Save to config
  if [[ ! -d "${HOME}/.jordydock" ]]; then
    /bin/mkdir -p "${HOME}/.jordydock"
  fi
  echo "JORDYDOCK_DIR=\"$JORDYDOCK_DIR\"" > "$JORDYDOCK_CONFIG"
  echo "✅ Saved to $JORDYDOCK_CONFIG"
  echo ""
  return 0
}

# Wrapper to run docker compose commands
_jordydock_compose() {
  _jordydock_ensure_dir || return 1
  local compose_args=(-f "${JORDYDOCK_DIR}/docker-compose.yml")
  if [[ -f "${JORDYDOCK_DIR}/docker-compose.extra.yml" ]]; then
    compose_args+=(-f "${JORDYDOCK_DIR}/docker-compose.extra.yml")
  fi
  command docker compose "${compose_args[@]}" "$@"
}

_jordydock_read_env_token() {
  _jordydock_ensure_dir || return 1
  if [[ ! -f "${JORDYDOCK_DIR}/.env" ]]; then
    return 1
  fi
  local raw
  raw=$(sed -n 's/^OPENJORDY_GATEWAY_TOKEN=//p' "${JORDYDOCK_DIR}/.env" | head -n 1)
  if [[ -z "$raw" ]]; then
    return 1
  fi
  _jordydock_trim_quotes "$raw"
}

# Basic Operations
jordydock-start() {
  _jordydock_compose up -d openjordy-gateway
}

jordydock-stop() {
  _jordydock_compose down
}

jordydock-restart() {
  _jordydock_compose restart openjordy-gateway
}

jordydock-logs() {
  _jordydock_compose logs -f openjordy-gateway
}

jordydock-status() {
  _jordydock_compose ps
}

# Navigation
jordydock-cd() {
  _jordydock_ensure_dir || return 1
  cd "${JORDYDOCK_DIR}"
}

jordydock-config() {
  cd ~/.openjordy
}

jordydock-workspace() {
  cd ~/.openjordy/workspace
}

# Container Access
jordydock-shell() {
  _jordydock_compose exec openjordy-gateway \
    bash -c 'echo "alias openjordy=\"./openjordy.mjs\"" > /tmp/.bashrc_openjordy && bash --rcfile /tmp/.bashrc_openjordy'
}

jordydock-exec() {
  _jordydock_compose exec openjordy-gateway "$@"
}

jordydock-cli() {
  _jordydock_compose run --rm openjordy-cli "$@"
}

# Maintenance
jordydock-rebuild() {
  _jordydock_compose build openjordy-gateway
}

jordydock-clean() {
  _jordydock_compose down -v --remove-orphans
}

# Health check
jordydock-health() {
  _jordydock_ensure_dir || return 1
  local token
  token=$(_jordydock_read_env_token)
  if [[ -z "$token" ]]; then
    echo "❌ Error: Could not find gateway token"
    echo "   Check: ${JORDYDOCK_DIR}/.env"
    return 1
  fi
  _jordydock_compose exec -e "OPENJORDY_GATEWAY_TOKEN=$token" openjordy-gateway \
    node dist/index.js health
}

# Show gateway token
jordydock-token() {
  _jordydock_read_env_token
}

# Fix token configuration (run this once after setup)
jordydock-fix-token() {
  _jordydock_ensure_dir || return 1

  echo "🔧 Configuring gateway token..."
  local token
  token=$(jordydock-token)
  if [[ -z "$token" ]]; then
    echo "❌ Error: Could not find gateway token"
    echo "   Check: ${JORDYDOCK_DIR}/.env"
    return 1
  fi

  echo "📝 Setting token: ${token:0:20}..."

  _jordydock_compose exec -e "TOKEN=$token" openjordy-gateway \
    bash -c './openjordy.mjs config set gateway.remote.token "$TOKEN" && ./openjordy.mjs config set gateway.auth.token "$TOKEN"' 2>&1 | _jordydock_filter_warnings

  echo "🔍 Verifying token was saved..."
  local saved_token
  saved_token=$(_jordydock_compose exec openjordy-gateway \
    bash -c "./openjordy.mjs config get gateway.remote.token 2>/dev/null" 2>&1 | _jordydock_filter_warnings | tr -d '\r\n' | head -c 64)

  if [[ "$saved_token" == "$token" ]]; then
    echo "✅ Token saved correctly!"
  else
    echo "⚠️  Token mismatch detected"
    echo "   Expected: ${token:0:20}..."
    echo "   Got: ${saved_token:0:20}..."
  fi

  echo "🔄 Restarting gateway..."
  _jordydock_compose restart openjordy-gateway 2>&1 | _jordydock_filter_warnings

  echo "⏳ Waiting for gateway to start..."
  sleep 5

  echo "✅ Configuration complete!"
  echo -e "   Try: $(_cmd jordydock-devices)"
}

# Open dashboard in browser
jordydock-dashboard() {
  _jordydock_ensure_dir || return 1

  echo "🦞 Getting dashboard URL..."
  local output exit_status url
  output=$(_jordydock_compose run --rm openjordy-cli dashboard --no-open 2>&1)
  exit_status=$?
  url=$(printf "%s\n" "$output" | _jordydock_filter_warnings | grep -o 'http[s]\?://[^[:space:]]*' | head -n 1)
  if [[ $exit_status -ne 0 ]]; then
    echo "❌ Failed to get dashboard URL"
    echo -e "   Try restarting: $(_cmd jordydock-restart)"
    return 1
  fi

  if [[ -n "$url" ]]; then
    echo "✅ Opening: $url"
    open "$url" 2>/dev/null || xdg-open "$url" 2>/dev/null || echo "   Please open manually: $url"
    echo ""
    echo -e "${_CLR_CYAN}💡 If you see 'pairing required' error:${_CLR_RESET}"
    echo -e "   1. Run: $(_cmd jordydock-devices)"
    echo "   2. Copy the Request ID from the Pending table"
    echo -e "   3. Run: $(_cmd 'jordydock-approve <request-id>')"
  else
    echo "❌ Failed to get dashboard URL"
    echo -e "   Try restarting: $(_cmd jordydock-restart)"
  fi
}

# List device pairings
jordydock-devices() {
  _jordydock_ensure_dir || return 1

  echo "🔍 Checking device pairings..."
  local output exit_status
  output=$(_jordydock_compose exec openjordy-gateway node dist/index.js devices list 2>&1)
  exit_status=$?
  printf "%s\n" "$output" | _jordydock_filter_warnings
  if [ $exit_status -ne 0 ]; then
    echo ""
    echo -e "${_CLR_CYAN}💡 If you see token errors above:${_CLR_RESET}"
    echo -e "   1. Verify token is set: $(_cmd jordydock-token)"
    echo "   2. Try manual config inside container:"
    echo -e "      $(_cmd jordydock-shell)"
    echo -e "      $(_cmd 'openjordy config get gateway.remote.token')"
    return 1
  fi

  echo ""
  echo -e "${_CLR_CYAN}💡 To approve a pairing request:${_CLR_RESET}"
  echo -e "   $(_cmd 'jordydock-approve <request-id>')"
}

# Approve device pairing request
jordydock-approve() {
  _jordydock_ensure_dir || return 1

  if [[ -z "$1" ]]; then
    echo -e "❌ Usage: $(_cmd 'jordydock-approve <request-id>')"
    echo ""
    echo -e "${_CLR_CYAN}💡 How to approve a device:${_CLR_RESET}"
    echo -e "   1. Run: $(_cmd jordydock-devices)"
    echo "   2. Find the Request ID in the Pending table (long UUID)"
    echo -e "   3. Run: $(_cmd 'jordydock-approve <that-request-id>')"
    echo ""
    echo "Example:"
    echo -e "   $(_cmd 'jordydock-approve 6f9db1bd-a1cc-4d3f-b643-2c195262464e')"
    return 1
  fi

  echo "✅ Approving device: $1"
  _jordydock_compose exec openjordy-gateway \
    node dist/index.js devices approve "$1" 2>&1 | _jordydock_filter_warnings

  echo ""
  echo "✅ Device approved! Refresh your browser."
}

# Show all available jordydock helper commands
jordydock-help() {
  echo -e "\n${_CLR_BOLD}${_CLR_CYAN}🦞 JordyDock - Docker Helpers for OpenJordy${_CLR_RESET}\n"

  echo -e "${_CLR_BOLD}${_CLR_MAGENTA}⚡ Basic Operations${_CLR_RESET}"
  echo -e "  $(_cmd jordydock-start)       ${_CLR_DIM}Start the gateway${_CLR_RESET}"
  echo -e "  $(_cmd jordydock-stop)        ${_CLR_DIM}Stop the gateway${_CLR_RESET}"
  echo -e "  $(_cmd jordydock-restart)     ${_CLR_DIM}Restart the gateway${_CLR_RESET}"
  echo -e "  $(_cmd jordydock-status)      ${_CLR_DIM}Check container status${_CLR_RESET}"
  echo -e "  $(_cmd jordydock-logs)        ${_CLR_DIM}View live logs (follows)${_CLR_RESET}"
  echo ""

  echo -e "${_CLR_BOLD}${_CLR_MAGENTA}🐚 Container Access${_CLR_RESET}"
  echo -e "  $(_cmd jordydock-shell)       ${_CLR_DIM}Shell into container (openjordy alias ready)${_CLR_RESET}"
  echo -e "  $(_cmd jordydock-cli)         ${_CLR_DIM}Run CLI commands (e.g., jordydock-cli status)${_CLR_RESET}"
  echo -e "  $(_cmd jordydock-exec) ${_CLR_CYAN}<cmd>${_CLR_RESET}  ${_CLR_DIM}Execute command in gateway container${_CLR_RESET}"
  echo ""

  echo -e "${_CLR_BOLD}${_CLR_MAGENTA}🌐 Web UI & Devices${_CLR_RESET}"
  echo -e "  $(_cmd jordydock-dashboard)   ${_CLR_DIM}Open web UI in browser ${_CLR_CYAN}(auto-guides you)${_CLR_RESET}"
  echo -e "  $(_cmd jordydock-devices)     ${_CLR_DIM}List device pairings ${_CLR_CYAN}(auto-guides you)${_CLR_RESET}"
  echo -e "  $(_cmd jordydock-approve) ${_CLR_CYAN}<id>${_CLR_RESET} ${_CLR_DIM}Approve device pairing ${_CLR_CYAN}(with examples)${_CLR_RESET}"
  echo ""

  echo -e "${_CLR_BOLD}${_CLR_MAGENTA}⚙️  Setup & Configuration${_CLR_RESET}"
  echo -e "  $(_cmd jordydock-fix-token)   ${_CLR_DIM}Configure gateway token ${_CLR_CYAN}(run once)${_CLR_RESET}"
  echo ""

  echo -e "${_CLR_BOLD}${_CLR_MAGENTA}🔧 Maintenance${_CLR_RESET}"
  echo -e "  $(_cmd jordydock-rebuild)     ${_CLR_DIM}Rebuild Docker image${_CLR_RESET}"
  echo -e "  $(_cmd jordydock-clean)       ${_CLR_RED}⚠️  Remove containers & volumes (nuclear)${_CLR_RESET}"
  echo ""

  echo -e "${_CLR_BOLD}${_CLR_MAGENTA}🛠️  Utilities${_CLR_RESET}"
  echo -e "  $(_cmd jordydock-health)      ${_CLR_DIM}Run health check${_CLR_RESET}"
  echo -e "  $(_cmd jordydock-token)       ${_CLR_DIM}Show gateway auth token${_CLR_RESET}"
  echo -e "  $(_cmd jordydock-cd)          ${_CLR_DIM}Jump to openjordy project directory${_CLR_RESET}"
  echo -e "  $(_cmd jordydock-config)      ${_CLR_DIM}Open config directory (~/.openjordy)${_CLR_RESET}"
  echo -e "  $(_cmd jordydock-workspace)   ${_CLR_DIM}Open workspace directory${_CLR_RESET}"
  echo ""

  echo -e "${_CLR_BOLD}${_CLR_CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${_CLR_RESET}"
  echo -e "${_CLR_BOLD}${_CLR_GREEN}🚀 First Time Setup${_CLR_RESET}"
  echo -e "${_CLR_CYAN}  1.${_CLR_RESET} $(_cmd jordydock-start)          ${_CLR_DIM}# Start the gateway${_CLR_RESET}"
  echo -e "${_CLR_CYAN}  2.${_CLR_RESET} $(_cmd jordydock-fix-token)      ${_CLR_DIM}# Configure token${_CLR_RESET}"
  echo -e "${_CLR_CYAN}  3.${_CLR_RESET} $(_cmd jordydock-dashboard)      ${_CLR_DIM}# Open web UI${_CLR_RESET}"
  echo -e "${_CLR_CYAN}  4.${_CLR_RESET} $(_cmd jordydock-devices)        ${_CLR_DIM}# If pairing needed${_CLR_RESET}"
  echo -e "${_CLR_CYAN}  5.${_CLR_RESET} $(_cmd jordydock-approve) ${_CLR_CYAN}<id>${_CLR_RESET}   ${_CLR_DIM}# Approve pairing${_CLR_RESET}"
  echo ""

  echo -e "${_CLR_BOLD}${_CLR_GREEN}💬 WhatsApp Setup${_CLR_RESET}"
  echo -e "  $(_cmd jordydock-shell)"
  echo -e "    ${_CLR_BLUE}>${_CLR_RESET} $(_cmd 'openjordy channels login --channel whatsapp')"
  echo -e "    ${_CLR_BLUE}>${_CLR_RESET} $(_cmd 'openjordy status')"
  echo ""

  echo -e "${_CLR_BOLD}${_CLR_CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${_CLR_RESET}"
  echo ""

  echo -e "${_CLR_CYAN}💡 All commands guide you through next steps!${_CLR_RESET}"
  echo -e "${_CLR_BLUE}📚 Docs: ${_CLR_RESET}${_CLR_CYAN}https://docs.openjordy.ai${_CLR_RESET}"
  echo ""
}
