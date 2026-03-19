---
summary: "CLI reference for `openjordy reset` (reset local state/config)"
read_when:
  - You want to wipe local state while keeping the CLI installed
  - You want a dry-run of what would be removed
title: "reset"
---

# `openjordy reset`

Reset local config/state (keeps the CLI installed).

```bash
openjordy reset
openjordy reset --dry-run
openjordy reset --scope config+creds+sessions --yes --non-interactive
```
