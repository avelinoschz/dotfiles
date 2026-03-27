#!/bin/sh
input=$(cat)
cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd')
dir=$(basename "$cwd")

# Git branch and dirty state
git_branch=""
if git -C "$cwd" rev-parse --git-dir > /dev/null 2>&1; then
  branch=$(git -C "$cwd" symbolic-ref --short HEAD 2>/dev/null || git -C "$cwd" rev-parse --short HEAD 2>/dev/null)
  if [ -n "$branch" ]; then
    dirty=$(git -C "$cwd" status --porcelain 2>/dev/null)
    if [ -n "$dirty" ]; then
      suffix="*"
    else
      suffix=""
    fi
    git_branch=$(printf "\033[32m(%s%s)\033[0m " "$branch" "$suffix")
  fi
fi

printf "%s%s" "$dir" "$git_branch"
