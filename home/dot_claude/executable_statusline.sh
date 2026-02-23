#!/bin/bash
# Claude Code Status Line - Catppuccin Mocha
# Two-line layout with full info display

input=$(cat)

# ============================================================================
# CATPPUCCIN MOCHA COLORS (RGB)
# ============================================================================
ROSEWATER='\033[38;2;245;224;220m'
FLAMINGO='\033[38;2;242;205;205m'
PINK='\033[38;2;245;194;231m'
MAUVE='\033[38;2;203;166;247m'
RED='\033[38;2;243;139;168m'
MAROON='\033[38;2;235;160;172m'
PEACH='\033[38;2;250;179;135m'
YELLOW='\033[38;2;249;226;175m'
GREEN='\033[38;2;166;227;161m'
TEAL='\033[38;2;148;226;213m'
SKY='\033[38;2;137;220;235m'
SAPPHIRE='\033[38;2;116;199;236m'
BLUE='\033[38;2;137;180;250m'
LAVENDER='\033[38;2;180;190;254m'
TEXT='\033[38;2;205;214;244m'
SUBTEXT1='\033[38;2;186;194;222m'
SUBTEXT0='\033[38;2;166;173;200m'
OVERLAY2='\033[38;2;147;153;178m'
OVERLAY1='\033[38;2;127;132;156m'
OVERLAY0='\033[38;2;108;112;134m'
SURFACE2='\033[38;2;88;91;112m'
SURFACE1='\033[38;2;69;71;90m'
SURFACE0='\033[38;2;49;50;68m'
BASE='\033[38;2;30;30;46m'
MANTLE='\033[38;2;24;24;37m'
CRUST='\033[38;2;17;17;27m'
RESET='\033[0m'

# Icons with colors
ICON_MODEL="${BLUE}󰚩${RESET}"      # Nerd font icon for AI/model
ICON_DIR="${SKY}${RESET}"         # Folder
ICON_GIT="${MAUVE}${RESET}"       # Git branch
ICON_COST="${YELLOW}󰄖${RESET}"     # Cash sign
ICON_TIME="${PEACH}${RESET}"      # Clock
ICON_TOKENS="${SAPPHIRE}${RESET}" # Counter

# ============================================================================
# EXTRACT DATA FROM JSON
# ============================================================================
MODEL=$(echo "$input" | jq -r '.model.display_name // "Unknown"')
DIR=$(echo "$input" | jq -r '.workspace.current_dir // "~"')
DIR_NAME="${DIR##*/}"
[ -z "$DIR_NAME" ] && DIR_NAME="~"

# Context window
PCT=$(echo "$input" | jq -r '.context_window.used_percentage // 0' | cut -d. -f1)

# Cost tracking
COST=$(echo "$input" | jq -r '.cost.total_cost_usd // 0')
COST_FMT=$(printf '$%.2f' "$COST")

# Duration
DURATION_MS=$(echo "$input" | jq -r '.cost.total_duration_ms // 0')
DURATION_SEC=$((DURATION_MS / 1000))
MINS=$((DURATION_SEC / 60))
SECS=$((DURATION_SEC % 60))
DURATION_FMT="${MINS}m${SECS}s"

# Token counts
INPUT_TOKENS=$(echo "$input" | jq -r '.context_window.total_input_tokens // 0')
OUTPUT_TOKENS=$(echo "$input" | jq -r '.context_window.total_output_tokens // 0')
TOTAL_TOKENS=$((INPUT_TOKENS + OUTPUT_TOKENS))

# Format tokens with K suffix if over 1000
if [ "$TOTAL_TOKENS" -ge 1000 ]; then
  TOKENS_FMT="$((TOTAL_TOKENS / 1000))k"
else
  TOKENS_FMT="$TOTAL_TOKENS"
fi

# ============================================================================
# GIT STATUS (with caching for performance)
# ============================================================================
CACHE_FILE="/tmp/claude-statusline-git-cache-$$"
CACHE_MAX_AGE=5 # seconds

cache_is_stale() {
  if [ ! -f "$CACHE_FILE" ]; then
    return 0
  fi
  # macOS uses -f %m, Linux uses -c %Y
  if command -v stat >/dev/null 2>&1; then
    MTIME=$(stat -f %m "$CACHE_FILE" 2>/dev/null || stat -c %Y "$CACHE_FILE" 2>/dev/null || echo 0)
    AGE=$(($(date +%s) - MTIME))
    [ "$AGE" -gt "$CACHE_MAX_AGE" ] && return 0
  fi
  return 1
}

GIT_INFO=""
if cache_is_stale; then
  if git rev-parse --git-dir >/dev/null 2>&1; then
    BRANCH=$(git branch --show-current 2>/dev/null || echo "detached")
    STAGED=$(git diff --cached --numstat 2>/dev/null | wc -l | tr -d ' ')
    MODIFIED=$(git diff --numstat 2>/dev/null | wc -l | tr -d ' ')
    UNTRACKED=$(git ls-files --others --exclude-standard 2>/dev/null | wc -l | tr -d ' ')
    echo "$BRANCH|$STAGED|$MODIFIED|$UNTRACKED" >"$CACHE_FILE"
  else
    echo "|||" >"$CACHE_FILE"
  fi
fi

if [ -f "$CACHE_FILE" ]; then
  IFS='|' read -r BRANCH STAGED MODIFIED UNTRACKED <"$CACHE_FILE"
  if [ -n "$BRANCH" ]; then
    GIT_STATUS=""
    [ "$STAGED" -gt 0 ] && GIT_STATUS="${GIT_STATUS} ${GREEN}+${STAGED}${RESET}"
    [ "$MODIFIED" -gt 0 ] && GIT_STATUS="${GIT_STATUS} ${YELLOW}~${MODIFIED}${RESET}"
    [ "$UNTRACKED" -gt 0 ] && GIT_STATUS="${GIT_STATUS} ${RED}?${UNTRACKED}${RESET}"
    GIT_INFO="${OVERLAY2}│${RESET} ${ICON_GIT} ${MAUVE}${BRANCH}${RESET}${GIT_STATUS}"
  fi
fi

# ============================================================================
# CONTEXT USAGE PROGRESS BAR
# ============================================================================
# Choose color based on usage threshold
if [ "$PCT" -ge 90 ]; then
  BAR_COLOR="$RED"
elif [ "$PCT" -ge 70 ]; then
  BAR_COLOR="$YELLOW"
elif [ "$PCT" -ge 50 ]; then
  BAR_COLOR="$PEACH"
else
  BAR_COLOR="$GREEN"
fi

# Build 20-character progress bar for better granularity
BAR_WIDTH=20
FILLED=$((PCT * BAR_WIDTH / 100))
EMPTY=$((BAR_WIDTH - FILLED))

BAR=""
[ "$FILLED" -gt 0 ] && BAR=$(printf "%${FILLED}s" | tr ' ' '█')
[ "$EMPTY" -gt 0 ] && BAR="${BAR}$(printf "%${EMPTY}s" | tr ' ' '░')"

# ============================================================================
# LINE 1: Model, Directory, Git Info, Vim Mode
# ============================================================================
LINE1="${ICON_MODEL} ${BLUE}${MODEL}${RESET}"
LINE1="${LINE1} ${OVERLAY2}│${RESET} ${ICON_DIR} ${SKY}${DIR_NAME}${RESET}"
LINE1="${LINE1} ${GIT_INFO}"

# ============================================================================
# LINE 2: Context Bar, Stats
# ============================================================================
LINE2="${BAR_COLOR}${BAR}${RESET} ${TEXT}${PCT}%${RESET}"
LINE2="${LINE2} ${OVERLAY2}│${RESET} ${ICON_COST} ${YELLOW}${COST_FMT}${RESET}"
LINE2="${LINE2} ${OVERLAY2}│${RESET} ${ICON_TIME} ${PEACH}${DURATION_FMT}${RESET}"
LINE2="${LINE2} ${OVERLAY2}│${RESET} ${ICON_TOKENS} ${SAPPHIRE}${TOKENS_FMT}${RESET}"

# ============================================================================
# OUTPUT
# ============================================================================
echo -e "$LINE1"
echo -e "$LINE2"

# Cleanup old cache files (optional, prevents accumulation)
find /tmp -name "claude-statusline-git-cache-*" -mtime +1 -delete 2>/dev/null || true
