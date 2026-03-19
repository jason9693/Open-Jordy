---
summary: "CLI reference for `openjordy devices` (device pairing + token rotation/revocation)"
read_when:
  - You are approving device pairing requests
  - You need to rotate or revoke device tokens
title: "devices"
---

# `openjordy devices`

Manage device pairing requests and device-scoped tokens.

## Commands

### `openjordy devices list`

List pending pairing requests and paired devices.

```
openjordy devices list
openjordy devices list --json
```

### `openjordy devices remove <deviceId>`

Remove one paired device entry.

```
openjordy devices remove <deviceId>
openjordy devices remove <deviceId> --json
```

### `openjordy devices clear --yes [--pending]`

Clear paired devices in bulk.

```
openjordy devices clear --yes
openjordy devices clear --yes --pending
openjordy devices clear --yes --pending --json
```

### `openjordy devices approve [requestId] [--latest]`

Approve a pending device pairing request. If `requestId` is omitted, OpenJordy
automatically approves the most recent pending request.

```
openjordy devices approve
openjordy devices approve <requestId>
openjordy devices approve --latest
```

### `openjordy devices reject <requestId>`

Reject a pending device pairing request.

```
openjordy devices reject <requestId>
```

### `openjordy devices rotate --device <id> --role <role> [--scope <scope...>]`

Rotate a device token for a specific role (optionally updating scopes).

```
openjordy devices rotate --device <deviceId> --role operator --scope operator.read --scope operator.write
```

### `openjordy devices revoke --device <id> --role <role>`

Revoke a device token for a specific role.

```
openjordy devices revoke --device <deviceId> --role node
```

## Common options

- `--url <url>`: Gateway WebSocket URL (defaults to `gateway.remote.url` when configured).
- `--token <token>`: Gateway token (if required).
- `--password <password>`: Gateway password (password auth).
- `--timeout <ms>`: RPC timeout.
- `--json`: JSON output (recommended for scripting).

Note: when you set `--url`, the CLI does not fall back to config or environment credentials.
Pass `--token` or `--password` explicitly. Missing explicit credentials is an error.

## Notes

- Token rotation returns a new token (sensitive). Treat it like a secret.
- These commands require `operator.pairing` (or `operator.admin`) scope.
- `devices clear` is intentionally gated by `--yes`.
- If pairing scope is unavailable on local loopback (and no explicit `--url` is passed), list/approve can use a local pairing fallback.
