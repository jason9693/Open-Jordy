---
summary: "CLI reference for `openjordy config` (get/set/unset/file/validate)"
read_when:
  - You want to read or edit config non-interactively
title: "config"
---

# `openjordy config`

Config helpers: get/set/unset/validate values by path and print the active
config file. Run without a subcommand to open
the configure wizard (same as `openjordy configure`).

## Examples

```bash
openjordy config file
openjordy config get browser.executablePath
openjordy config set browser.executablePath "/usr/bin/google-chrome"
openjordy config set agents.defaults.heartbeat.every "2h"
openjordy config set agents.list[0].tools.exec.node "node-id-or-name"
openjordy config unset tools.web.search.apiKey
openjordy config validate
openjordy config validate --json
```

## Paths

Paths use dot or bracket notation:

```bash
openjordy config get agents.defaults.workspace
openjordy config get agents.list[0].id
```

Use the agent list index to target a specific agent:

```bash
openjordy config get agents.list
openjordy config set agents.list[1].tools.exec.node "node-id-or-name"
```

## Values

Values are parsed as JSON5 when possible; otherwise they are treated as strings.
Use `--strict-json` to require JSON5 parsing. `--json` remains supported as a legacy alias.

```bash
openjordy config set agents.defaults.heartbeat.every "0m"
openjordy config set gateway.port 19001 --strict-json
openjordy config set channels.whatsapp.groups '["*"]' --strict-json
```

## Subcommands

- `config file`: Print the active config file path (resolved from `OPENJORDY_CONFIG_PATH` or default location).

Restart the gateway after edits.

## Validate

Validate the current config against the active schema without starting the
gateway.

```bash
openjordy config validate
openjordy config validate --json
```
