# Oh-My-Zsh Configuration
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME=""
plugins=(git asdf)
source $ZSH/oh-my-zsh.sh

# GPG prompt
export GPG_TTY=$(tty)

# Git styling via oh-my-zsh
setopt prompt_subst
PROMPT='%1~ $(git_prompt_info)%# '
ZSH_THEME_GIT_PROMPT_PREFIX="%F{green}("
ZSH_THEME_GIT_PROMPT_SUFFIX=") %f"
ZSH_THEME_GIT_PROMPT_DIRTY="*"
ZSH_THEME_GIT_PROMPT_CLEAN=""