# asdf

A version manager for multiple runtime versions (Node.js, Python, Go, etc.) using a single CLI tool and configuration file.

## Plugin Management

```bash
# List all available plugins in asdf registry
asdf plugin list all

# List currently installed plugins
asdf plugin list

# Add a plugin (e.g., golang)
asdf plugin add golang
```

## Version Management

```bash
# List all available versions for a plugin
asdf list all golang

# Install a specific version
asdf install golang 1.25.5
```
