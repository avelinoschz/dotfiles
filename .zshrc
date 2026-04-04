# Deduplicate PATH entries (zsh built-in)
typeset -U path

# PATH
# Suggested by Claude Code
export PATH="$HOME/.local/bin:$PATH"
# asdf — added by asdf getting started guide
export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"

# Completions
autoload -Uz compinit && compinit

# GPG prompt
# Tell GPG which terminal to use for interactive prompts.
# This avoids issues when signing commits/tags or decrypting from the shell,
# so pinentry can ask for the passphrase in the current terminal session.
export GPG_TTY=$(tty)

# Git prompt styling
# Branch display
ZSH_THEME_GIT_PROMPT_PREFIX="%F{green}("
ZSH_THEME_GIT_PROMPT_SUFFIX=")%f"
ZSH_THEME_GIT_PROMPT_DIRTY=""
ZSH_THEME_GIT_PROMPT_CLEAN=""

# Remote tracking status
ZSH_THEME_GIT_PROMPT_AHEAD="%F{cyan}↑%f"
ZSH_THEME_GIT_PROMPT_BEHIND="%F{magenta}↓%f"
ZSH_THEME_GIT_PROMPT_DIVERGED="%F{red}↑↓%f"

# Staged changes
ZSH_THEME_GIT_PROMPT_ADDED="%F{green}+%f"

# Unstaged changes
ZSH_THEME_GIT_PROMPT_MODIFIED="%F{yellow}!%f"
ZSH_THEME_GIT_PROMPT_RENAMED="%F{yellow}»%f"
ZSH_THEME_GIT_PROMPT_DELETED="%F{red}✗%f"

# Untracked files
ZSH_THEME_GIT_PROMPT_UNTRACKED="%F{red}?%f"

# Special states
ZSH_THEME_GIT_PROMPT_STASHED="%F{blue}\$%f"
ZSH_THEME_GIT_PROMPT_UNMERGED="%F{red}=%f"

# Git prompt
setopt prompt_subst
# PROMPT='%1~$(git_prompt_info)$(git_prompt_status) %# '  # oh-my-zsh functions
source "$HOME/.zsh_git_prompt"
PROMPT='%1~$(_git_prompt_info)$(_git_prompt_status) %# '