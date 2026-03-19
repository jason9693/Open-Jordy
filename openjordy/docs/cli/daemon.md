---
summary: "CLI reference for `openjordy daemon` (legacy alias for gateway service management)"
read_when:
  - You still use `openjordy daemon ...` in scripts
  - You need service lifecycle commands (install/start/stop/restart/status)
title: "daemon"
---

# `openjordy daemon`

Legacy alias for Gateway service management commands.

`openjordy daemon ...` maps to the same service control surface as `openjordy gateway ...` service commands.

## Usage

```bash
openjordy daemon status
openjordy daemon install
openjordy daemon start
openjordy daemon stop
openjordy daemon restart
openjordy daemon uninstall
```

## Subcommands

- `status`: show service install state and probe Gateway health
- `install`: install service (`launchd`/`systemd`/`schtasks`)
- `uninstall`: remove service
- `start`: start service
- `stop`: stop service
- `restart`: restart service

## Common options

- `status`: `--url`, `--token`, `--password`, `--timeout`, `--no-probe`, `--deep`, `--json`
- `install`: `--port`, `--runtime <node|bun>`, `--token`, `--force`, `--json`
- lifecycle (`uninstall|start|stop|restart`): `--json`

## Prefer

Use [`openjordy gateway`](/cli/gateway) for current docs and examples.
