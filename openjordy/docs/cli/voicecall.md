---
summary: "CLI reference for `openjordy voicecall` (voice-call plugin command surface)"
read_when:
  - You use the voice-call plugin and want the CLI entry points
  - You want quick examples for `voicecall call|continue|status|tail|expose`
title: "voicecall"
---

# `openjordy voicecall`

`voicecall` is a plugin-provided command. It only appears if the voice-call plugin is installed and enabled.

Primary doc:

- Voice-call plugin: [Voice Call](/plugins/voice-call)

## Common commands

```bash
openjordy voicecall status --call-id <id>
openjordy voicecall call --to "+15555550123" --message "Hello" --mode notify
openjordy voicecall continue --call-id <id> --message "Any questions?"
openjordy voicecall end --call-id <id>
```

## Exposing webhooks (Tailscale)

```bash
openjordy voicecall expose --mode serve
openjordy voicecall expose --mode funnel
openjordy voicecall expose --mode off
```

Security note: only expose the webhook endpoint to networks you trust. Prefer Tailscale Serve over Funnel when possible.
