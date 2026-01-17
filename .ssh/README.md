# .ssh

SSH client configuration directory.

## Contents

### config

Global SSH client settings applied to all hosts.

- `UseKeychain yes` - Stores passphrases in macOS Keychain
- `AddKeysToAgent yes` - Automatically adds keys to ssh-agent
- `IdentityFile ~/.ssh/id_ed25519` - Default private key using Ed25519 algorithm
