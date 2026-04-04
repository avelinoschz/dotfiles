# Deduplicate PATH entries (zsh built-in)
typeset -U path

# PATH
# Suggested by Claude Code
export PATH="$HOME/.local/bin:$PATH"
# asdf — added by asdf getting started guide
export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"

# Completions — load and initialize zsh's completion system.
# autoload -Uz loads the function without executing it; compinit activates it.
autoload -Uz compinit && compinit

# GPG prompt
# Tell GPG which terminal to use for interactive prompts.
# This avoids issues when signing commits/tags or decrypting from the shell,
# so pinentry can ask for the passphrase in the current terminal session.
export GPG_TTY=$(tty)

# Git prompt styling
# Symbol order follows Starship convention: =(unmerged) $(stash) ✘(deleted) »(renamed) !(modified) +(added) ?(untracked) ⇡⇣(remote)
# Branch display
ZSH_THEME_GIT_PROMPT_PREFIX="%F{cyan}("
ZSH_THEME_GIT_PROMPT_SUFFIX=")%f"

# Conflict state
ZSH_THEME_GIT_PROMPT_UNMERGED="%F{red}=%f"

# Special states
ZSH_THEME_GIT_PROMPT_STASHED="%F{blue}\$%f"

# Unstaged changes
ZSH_THEME_GIT_PROMPT_DELETED="%F{red}✘%f"
ZSH_THEME_GIT_PROMPT_RENAMED="%F{yellow}»%f"
ZSH_THEME_GIT_PROMPT_MODIFIED="%F{yellow}!%f"

# Staged changes
ZSH_THEME_GIT_PROMPT_ADDED="%F{green}+%f"

# Untracked files
ZSH_THEME_GIT_PROMPT_UNTRACKED="%F{yellow}?%f"

# Remote tracking status
ZSH_THEME_GIT_PROMPT_AHEAD="%F{cyan}⇡%f"
ZSH_THEME_GIT_PROMPT_BEHIND="%F{red}⇣%f"
ZSH_THEME_GIT_PROMPT_DIVERGED="%F{red}⇡%f"

# Git prompt
setopt prompt_subst
# PROMPT='%1~$(git_prompt_info)$(git_prompt_status) %# '  # oh-my-zsh functions
source "$HOME/.zsh_git_prompt"
PROMPT='%1~$(_git_prompt_info)$(_git_prompt_status) %# '

# Show system info on terminal startup
fastfetch