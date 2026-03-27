# Oh-My-Zsh Configuration
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME=""
plugins=(git asdf)
source $ZSH/oh-my-zsh.sh

# GPG prompt
export GPG_TTY=$(tty)

# Git styling via oh-my-zsh
setopt prompt_subst
PROMPT='%1~ $(git_prompt_info)$(git_prompt_status) %# '

# Branch display
ZSH_THEME_GIT_PROMPT_PREFIX="%F{green}("
ZSH_THEME_GIT_PROMPT_SUFFIX=")%f"
ZSH_THEME_GIT_PROMPT_DIRTY="*"
ZSH_THEME_GIT_PROMPT_CLEAN=""

# Ahead / behind / diverged from remote
ZSH_THEME_GIT_PROMPT_AHEAD="%F{cyan}⬆ %f"
ZSH_THEME_GIT_PROMPT_BEHIND="%F{magenta}⬇ %f"
ZSH_THEME_GIT_PROMPT_DIVERGED="%F{red}⬆⬇ %f"

# Working tree status
ZSH_THEME_GIT_PROMPT_UNTRACKED="%F{red}?%f"
ZSH_THEME_GIT_PROMPT_ADDED="%F{green}+%f"
ZSH_THEME_GIT_PROMPT_MODIFIED="%F{yellow}!%f"
ZSH_THEME_GIT_PROMPT_RENAMED="%F{yellow}»%f"
ZSH_THEME_GIT_PROMPT_DELETED="%F{red}✗%f"
ZSH_THEME_GIT_PROMPT_UNMERGED="%F{red}=%f"
ZSH_THEME_GIT_PROMPT_STASHED="%F{blue}\$%f"

# Added by Antigravity
export PATH="/Users/avelino/.antigravity/antigravity/bin:$PATH"