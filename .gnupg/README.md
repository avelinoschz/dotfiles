# .gnupg

GnuPG configuration directory for encryption keys and settings.

## Contents

### gpg-agent.conf

Configuration for the GPG agent daemon.

- `pinentry-program` - Uses pinentry-mac for passphrase prompts on macOS
- `default-cache-ttl` - Caches passphrase for 10 minutes (600 seconds)
- `max-cache-ttl` - Maximum cache time of 2 hours (7200 seconds)
