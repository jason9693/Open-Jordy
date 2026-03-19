# JordyDock <!-- omit in toc -->

Stop typing `docker-compose` commands. Just type `jordydock-start`.

Inspired by Simon Willison's [Running OpenJordy in Docker](https://til.simonwillison.net/llms/openjordy-docker).

- [Quickstart](#quickstart)
- [Available Commands](#available-commands)
  - [Basic Operations](#basic-operations)
  - [Container Access](#container-access)
  - [Web UI \& Devices](#web-ui--devices)
  - [Setup \& Configuration](#setup--configuration)
  - [Maintenance](#maintenance)
  - [Utilities](#utilities)
- [Common Workflows](#common-workflows)
  - [Check Status and Logs](#check-status-and-logs)
  - [Set Up WhatsApp Bot](#set-up-whatsapp-bot)
  - [Troubleshooting Device Pairing](#troubleshooting-device-pairing)
  - [Fix Token Mismatch Issues](#fix-token-mismatch-issues)
  - [Permission Denied](#permission-denied)
- [Requirements](#requirements)

## Quickstart

**Install:**

```bash
mkdir -p ~/.jordydock && curl -sL https://raw.githubusercontent.com/openjordy/openjordy/main/scripts/shell-helpers/jordydock-helpers.sh -o ~/.jordydock/jordydock-helpers.sh
```

```bash
echo 'source ~/.jordydock/jordydock-helpers.sh' >> ~/.zshrc && source ~/.zshrc
```

**See what you get:**

```bash
jordydock-help
```

On first command, JordyDock auto-detects your OpenJordy directory:

- Checks common paths (`~/openjordy`, `~/workspace/openjordy`, etc.)
- If found, asks you to confirm
- Saves to `~/.jordydock/config`

**First time setup:**

```bash
jordydock-start
```

```bash
jordydock-fix-token
```

```bash
jordydock-dashboard
```

If you see "pairing required":

```bash
jordydock-devices
```

And approve the request for the specific device:

```bash
jordydock-approve <request-id>
```

## Available Commands

### Basic Operations

| Command            | Description                     |
| ------------------ | ------------------------------- |
| `jordydock-start`   | Start the gateway               |
| `jordydock-stop`    | Stop the gateway                |
| `jordydock-restart` | Restart the gateway             |
| `jordydock-status`  | Check container status          |
| `jordydock-logs`    | View live logs (follows output) |

### Container Access

| Command                   | Description                                    |
| ------------------------- | ---------------------------------------------- |
| `jordydock-shell`          | Interactive shell inside the gateway container |
| `jordydock-cli <command>`  | Run OpenJordy CLI commands                      |
| `jordydock-exec <command>` | Execute arbitrary commands in the container    |

### Web UI & Devices

| Command                 | Description                                |
| ----------------------- | ------------------------------------------ |
| `jordydock-dashboard`    | Open web UI in browser with authentication |
| `jordydock-devices`      | List device pairing requests               |
| `jordydock-approve <id>` | Approve a device pairing request           |

### Setup & Configuration

| Command              | Description                                       |
| -------------------- | ------------------------------------------------- |
| `jordydock-fix-token` | Configure gateway authentication token (run once) |

### Maintenance

| Command            | Description                                      |
| ------------------ | ------------------------------------------------ |
| `jordydock-rebuild` | Rebuild the Docker image                         |
| `jordydock-clean`   | Remove all containers and volumes (destructive!) |

### Utilities

| Command              | Description                               |
| -------------------- | ----------------------------------------- |
| `jordydock-health`    | Run gateway health check                  |
| `jordydock-token`     | Display the gateway authentication token  |
| `jordydock-cd`        | Jump to the OpenJordy project directory    |
| `jordydock-config`    | Open the OpenJordy config directory        |
| `jordydock-workspace` | Open the workspace directory              |
| `jordydock-help`      | Show all available commands with examples |

## Common Workflows

### Check Status and Logs

**Restart the gateway:**

```bash
jordydock-restart
```

**Check container status:**

```bash
jordydock-status
```

**View live logs:**

```bash
jordydock-logs
```

### Set Up WhatsApp Bot

**Shell into the container:**

```bash
jordydock-shell
```

**Inside the container, login to WhatsApp:**

```bash
openjordy channels login --channel whatsapp --verbose
```

Scan the QR code with WhatsApp on your phone.

**Verify connection:**

```bash
openjordy status
```

### Troubleshooting Device Pairing

**Check for pending pairing requests:**

```bash
jordydock-devices
```

**Copy the Request ID from the "Pending" table, then approve:**

```bash
jordydock-approve <request-id>
```

Then refresh your browser.

### Fix Token Mismatch Issues

If you see "gateway token mismatch" errors:

```bash
jordydock-fix-token
```

This will:

1. Read the token from your `.env` file
2. Configure it in the OpenJordy config
3. Restart the gateway
4. Verify the configuration

### Permission Denied

**Ensure Docker is running and you have permission:**

```bash
docker ps
```

## Requirements

- Docker and Docker Compose installed
- Bash or Zsh shell
- OpenJordy project (from `docker-setup.sh`)

## Development

**Test with fresh config (mimics first-time install):**

```bash
unset JORDYDOCK_DIR && rm -f ~/.jordydock/config && source scripts/shell-helpers/jordydock-helpers.sh
```

Then run any command to trigger auto-detect:

```bash
jordydock-start
```
