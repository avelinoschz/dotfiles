.DEFAULT_GOAL := help

.PHONY: help setup setup-dry keys keys-dry secrets secrets-dry \
        push push-dry push-restore push-clean \
        pull pull-dry

# ─── trailing argument capture ───────────────────────────────────────────────
#
# Allows passing filenames directly after push/pull targets:
#   make push .zshrc            → ./scripts/push.sh .zshrc
#   make push-dry .zshrc        → ./scripts/push.sh --dry-run .zshrc
#   make pull .gitconfig        → ./scripts/pull.sh .gitconfig
#
# How it works:
#   $(MAKECMDGOALS) contains all targets passed on the command line.
#   $(wordlist 2,...) strips the first word (the target) and keeps the rest.
#   $(eval $(PUSH_ARGS):;@:) declares the filenames as no-op targets so Make
#   doesn't treat them as missing files and error out.

ifneq (,$(filter push push-dry,$(firstword $(MAKECMDGOALS))))
  PUSH_ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
  ifneq (,$(PUSH_ARGS))
    $(eval $(PUSH_ARGS):;@:)
  endif
endif

ifneq (,$(filter pull pull-dry,$(firstword $(MAKECMDGOALS))))
  PULL_ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
  ifneq (,$(PULL_ARGS))
    $(eval $(PULL_ARGS):;@:)
  endif
endif

# ─── targets ─────────────────────────────────────────────────────────────────

help: ## Show this help
	@awk 'BEGIN {FS = ":.*##"; printf "Usage: make <target>\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  %-16s %s\n", $$1, $$2 } /^##@/ { printf "\n%s\n", substr($$0, 5) }' $(MAKEFILE_LIST)

##@ Bootstrap

setup: ## Run full machine bootstrap
	./scripts/setup.sh

setup-dry: ## Preview bootstrap without making any changes
	./scripts/setup.sh --dry-run

keys: ## Deploy SSH and GPG configs to $$HOME
	./scripts/setup-keys.sh

keys-dry: ## Preview SSH/GPG deployment without deploying
	./scripts/setup-keys.sh --dry-run

secrets: ## Initialize $$HOME/.zsh_secrets from .env.example
	./scripts/init-secrets.sh

secrets-dry: ## Preview secrets initialization without writing files
	./scripts/init-secrets.sh --dry-run

##@ Dotfiles — push (repo → $$HOME)

push: ## Apply all dotfiles, or a specific file: make push .zshrc
	./scripts/push.sh $(or $(PUSH_ARGS),--all)

push-dry: ## Preview changes without applying: make push-dry .zshrc
	./scripts/push.sh --dry-run $(or $(PUSH_ARGS),--all)

push-restore: ## Restore most recent backup for all files
	./scripts/push.sh --restore --all

push-clean: ## Delete all backups
	./scripts/push.sh --clean --all

##@ Dotfiles — pull ($$HOME → repo)

pull: ## Capture all dotfiles, or a specific file: make pull .gitconfig
	./scripts/pull.sh $(or $(PULL_ARGS),--all)

pull-dry: ## Preview capture without pulling: make pull-dry .gitconfig
	./scripts/pull.sh --dry-run $(or $(PULL_ARGS),--all)
