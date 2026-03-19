---
name: jordyhub
description: Use the JordyHub CLI to search, install, update, and publish agent skills from jordyhub.com. Use when you need to fetch new skills on the fly, sync installed skills to latest or a specific version, or publish new/updated skill folders with the npm-installed jordyhub CLI.
metadata:
  {
    "openjordy":
      {
        "requires": { "bins": ["jordyhub"] },
        "install":
          [
            {
              "id": "node",
              "kind": "node",
              "package": "jordyhub",
              "bins": ["jordyhub"],
              "label": "Install JordyHub CLI (npm)",
            },
          ],
      },
  }
---

# JordyHub CLI

Install

```bash
npm i -g jordyhub
```

Auth (publish)

```bash
jordyhub login
jordyhub whoami
```

Search

```bash
jordyhub search "postgres backups"
```

Install

```bash
jordyhub install my-skill
jordyhub install my-skill --version 1.2.3
```

Update (hash-based match + upgrade)

```bash
jordyhub update my-skill
jordyhub update my-skill --version 1.2.3
jordyhub update --all
jordyhub update my-skill --force
jordyhub update --all --no-input --force
```

List

```bash
jordyhub list
```

Publish

```bash
jordyhub publish ./my-skill --slug my-skill --name "My Skill" --version 1.2.0 --changelog "Fixes + docs"
```

Notes

- Default registry: https://jordyhub.com (override with JORDYHUB_REGISTRY or --registry)
- Default workdir: cwd (falls back to OpenJordy workspace); install dir: ./skills (override with --workdir / --dir / JORDYHUB_WORKDIR)
- Update command hashes local files, resolves matching version, and upgrades to latest unless --version is set
