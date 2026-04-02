#!/bin/sh
input=$(cat)

MODEL=$(echo "$input" | jq -r '.model.display_name // .model.id // "claude"')
PCT=$(echo "$input" | jq -r '.context_window.used_percentage // 0' | cut -d. -f1)
DURATION_MS=$(echo "$input" | jq -r '.cost.total_duration_ms // 0')
FIVE_H=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
SEVEN_D=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')
WORKTREE=$(echo "$input" | jq -r '.worktree.name // empty')

# Progress bar
FILLED=$((PCT * 10 / 100))
EMPTY=$((10 - FILLED))
BAR=""
i=0
while [ $i -lt $FILLED ]; do BAR="${BAR}▓"; i=$((i+1)); done
i=0
while [ $i -lt $EMPTY ]; do BAR="${BAR}░"; i=$((i+1)); done

# Color based on usage
if [ "$PCT" -ge 90 ]; then
  COLOR="\033[31m"
elif [ "$PCT" -ge 70 ]; then
  COLOR="\033[33m"
else
  COLOR="\033[32m"
fi
RESET="\033[0m"

# Format duration
MINS=$((DURATION_MS / 60000))
SECS=$(((DURATION_MS % 60000) / 1000))
if [ $MINS -gt 0 ]; then
  TIME="${MINS}m ${SECS}s"
else
  TIME="${SECS}s"
fi

# Rate limits
RATE=""
if [ -n "$FIVE_H" ] && [ -n "$SEVEN_D" ]; then
  FIVE_H_INT=$(printf '%.0f' "$FIVE_H")
  SEVEN_D_INT=$(printf '%.0f' "$SEVEN_D")
  RATE=" | 5h:${FIVE_H_INT}% 7d:${SEVEN_D_INT}%"
fi

# Worktree
WT=""
if [ -n "$WORKTREE" ]; then
  WT=" | ⎇ ${WORKTREE}"
fi

printf "[%s] ${COLOR}%s${RESET} %s%%%s%s | %s\n" "$MODEL" "$BAR" "$PCT" "$RATE" "$WT" "$TIME"
