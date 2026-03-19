# @openjordy/zalouser

OpenJordy extension for Zalo Personal Account messaging via native `zca-js` integration.

> **Warning:** Using Zalo automation may result in account suspension or ban. Use at your own risk. This is an unofficial integration.

## Features

- Channel plugin integration with onboarding + QR login
- In-process listener/sender via `zca-js` (no external CLI)
- Multi-account support
- Agent tool integration (`zalouser`)
- DM/group policy support

## Prerequisites

- OpenJordy Gateway
- Zalo mobile app (for QR login)

No external `zca`, `openzca`, or `zca-cli` binary is required.

## Install

### Option A: npm

```bash
openjordy plugins install @openjordy/zalouser
```

### Option B: local source checkout

```bash
openjordy plugins install ./extensions/zalouser
cd ./extensions/zalouser && pnpm install
```

Restart the Gateway after install.

## Quick start

### Login (QR)

```bash
openjordy channels login --channel zalouser
```

Scan the QR code with the Zalo app on your phone.

### Enable channel

```yaml
channels:
  zalouser:
    enabled: true
    dmPolicy: pairing # pairing | allowlist | open | disabled
```

### Send a message

```bash
openjordy message send --channel zalouser --target <threadId> --message "Hello from OpenJordy"
```

## Configuration

Basic:

```yaml
channels:
  zalouser:
    enabled: true
    dmPolicy: pairing
```

Multi-account:

```yaml
channels:
  zalouser:
    enabled: true
    defaultAccount: default
    accounts:
      default:
        enabled: true
        profile: default
      work:
        enabled: true
        profile: work
```

## Useful commands

```bash
openjordy channels login --channel zalouser
openjordy channels login --channel zalouser --account work
openjordy channels status --probe
openjordy channels logout --channel zalouser

openjordy directory self --channel zalouser
openjordy directory peers list --channel zalouser --query "name"
openjordy directory groups list --channel zalouser --query "work"
openjordy directory groups members --channel zalouser --group-id <id>
```

## Agent tool

The extension registers a `zalouser` tool for AI agents.

Available actions: `send`, `image`, `link`, `friends`, `groups`, `me`, `status`

## Troubleshooting

- Login not persisted: `openjordy channels logout --channel zalouser && openjordy channels login --channel zalouser`
- Probe status: `openjordy channels status --probe`
- Name resolution issues (allowlist/groups): use numeric IDs or exact Zalo names

## Credits

Built on [zca-js](https://github.com/RFS-ADRENO/zca-js).
