# scripts

Utility scripts for machine bootstrap and dotfile synchronization.

## Scripts

- `setup.sh`: Full bootstrap for a new machine.
- `setup-keys.sh`: Deploy SSH and GPG configs if missing.
- `init-secrets.sh`: Initialize `~/.zsh_secrets` from `../.env.example` without overwriting existing values.
- `push.sh`: Apply tracked files from this repo to `$HOME` (repo -> home).
- `pull.sh`: Capture tracked files from `$HOME` into this repo (home -> repo).

## Quick usage

Run from repo root:

```bash
./scripts/setup.sh
./scripts/setup.sh --dry-run

./scripts/init-secrets.sh
./scripts/init-secrets.sh --dry-run

./scripts/push.sh --all
./scripts/pull.sh --all
```

You can also use Make targets from repo root:

```bash
make setup
make secrets
make push
make pull
```
