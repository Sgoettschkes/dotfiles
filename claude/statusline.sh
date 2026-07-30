#!/bin/bash
# File managed by Sgoettschkes/dotfiles
# Claude Code statusline: default context (dir, git branch, model) + caveman badge.

INPUT=$(cat)

CWD=$(printf '%s' "$INPUT" | jq -r '.workspace.current_dir // .cwd // empty')
MODEL=$(printf '%s' "$INPUT" | jq -r '.model.display_name // empty')

DIR_NAME=""
[ -n "$CWD" ] && DIR_NAME=$(basename "$CWD")

BRANCH=""
if [ -n "$CWD" ]; then
  BRANCH=$(git -C "$CWD" symbolic-ref --quiet --short HEAD 2>/dev/null \
    || git -C "$CWD" rev-parse --short HEAD 2>/dev/null)
fi

CYAN='\033[38;5;39m'
DIM='\033[2m'
NC='\033[0m'

OUT=""
[ -n "$DIR_NAME" ] && OUT="${CYAN}${DIR_NAME}${NC}"
[ -n "$BRANCH" ]   && OUT="${OUT} ${DIM}(${BRANCH})${NC}"
[ -n "$MODEL" ]    && OUT="${OUT} ${DIM}${MODEL}${NC}"

printf '%b' "$OUT"

# Caveman badge (reads its own flag file; ignores stdin). Space-separate if
# both the default context and the badge produce output.
BADGE=$(bash "/Users/sebastian/.claude/plugins/cache/caveman/caveman/0d95a81d35a9/src/hooks/caveman-statusline.sh" < /dev/null)
if [ -n "$BADGE" ]; then
  [ -n "$OUT" ] && printf ' '
  printf '%s' "$BADGE"
fi
