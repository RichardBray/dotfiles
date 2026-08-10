#!/usr/bin/env bash
# Claude Code status line script
#
# Line 1: Model | context% used | project (branch) | thinking
# Line 2: current ●●●○○○○○○○ 28% ↻ 1hr 38min
# Line 3: weekly  ●●●●●●●●●●○○ 79% ↻ 2hr 4min
#
# Usage data is fetched from the Anthropic API using your stored OAuth token.

set -f

input=$(cat)

if [ -z "$input" ]; then
    printf "Claude"
    exit 0
fi

# ── Colors ──────────────────────────────────────────────
blue='\033[38;5;75m'
green='\033[38;5;120m'
cyan='\033[38;5;87m'
red='\033[38;5;203m'
yellow='\033[38;5;226m'
orange='\033[38;5;214m'
amber='\033[38;5;220m'
magenta='\033[38;5;213m'
white='\033[38;5;253m'
dim='\033[2m'
reset='\033[0m'

sep=" ${dim}│${reset} "

# ── Helpers ─────────────────────────────────────────────
color_for_tokens() {
    # Color by absolute token usage so thresholds are window-size agnostic.
    # ~120K = old 61% of 200K (red), ~62K = old 31% of 200K (amber).
    local tokens=$1
    if [ "$tokens" -ge 120000 ]; then printf "$red"
    elif [ "$tokens" -ge 62000 ]; then printf "$amber"
    else printf "$green"
    fi
}

build_bar() {
    local pct=$1 width=$2
    [ "$pct" -lt 0 ] 2>/dev/null && pct=0
    [ "$pct" -gt 100 ] 2>/dev/null && pct=100
    local filled=$(( pct * width / 100 ))
    local empty=$(( width - filled ))
    local filled_str="" empty_str=""
    for ((i=0; i<filled; i++)); do filled_str+="●"$'\xe2\x80\x8a'; done
    for ((i=0; i<empty; i++)); do empty_str+="○"$'\xe2\x80\x8a'; done
    printf "${white}${filled_str}${dim}${empty_str}${reset}"
}

iso_to_epoch() {
    local iso_str="$1"
    local epoch
    epoch=$(date -d "${iso_str}" +%s 2>/dev/null)
    [ -n "$epoch" ] && { echo "$epoch"; return 0; }
    local stripped="${iso_str%%.*}"
    stripped="${stripped%%Z}"
    stripped="${stripped%%+*}"
    stripped="${stripped%%-[0-9][0-9]:[0-9][0-9]}"
    if [[ "$iso_str" == *"Z"* ]] || [[ "$iso_str" == *"+00:00"* ]]; then
        epoch=$(env TZ=UTC date -j -f "%Y-%m-%dT%H:%M:%S" "$stripped" +%s 2>/dev/null)
    else
        epoch=$(date -j -f "%Y-%m-%dT%H:%M:%S" "$stripped" +%s 2>/dev/null)
    fi
    [ -n "$epoch" ] && { echo "$epoch"; return 0; }
    return 1
}

format_reset_time() {
    local iso_str="$1" style="$2"
    [ -z "$iso_str" ] || [ "$iso_str" = "null" ] && return
    local epoch
    epoch=$(iso_to_epoch "$iso_str")
    [ -z "$epoch" ] && return
    case "$style" in
        countdown)
            local now diff
            now=$(date +%s)
            diff=$(( epoch - now ))
            [ "$diff" -le 0 ] && { printf "now"; return; }
            local hrs mins
            hrs=$(( diff / 3600 ))
            mins=$(( (diff % 3600) / 60 ))
            if [ "$hrs" -gt 0 ]; then
                printf "%dhr %dmin" "$hrs" "$mins"
            else
                printf "%dmin" "$mins"
            fi
            ;;
        time)
            date -j -r "$epoch" +"%l:%M%p" 2>/dev/null | sed 's/^ //; s/\.//g' | tr '[:upper:]' '[:lower:]' || \
            date -d "@$epoch" +"%l:%M%P" 2>/dev/null | sed 's/^ //; s/\.//g'
            ;;
        datetime)
            date -j -r "$epoch" +"%a %l:%M%p" 2>/dev/null | sed 's/  / /g; s/^ //; s/\.//g' | tr '[:upper:]' '[:lower:]' | awk '{print toupper(substr($0,1,1)) substr($0,2)}' || \
            date -d "@$epoch" +"%a %l:%M%P" 2>/dev/null | sed 's/  / /g; s/^ //; s/\.//g' | awk '{print toupper(substr($0,1,1)) substr($0,2)}'
            ;;
    esac
}

# ── Extract JSON data ────────────────────────────────────
model_name=$(echo "$input" | jq -r '.model.display_name // "Claude"')
cwd=$(echo "$input" | jq -r '.cwd // ""')
[ -z "$cwd" ] || [ "$cwd" = "null" ] && cwd=$(pwd)
dirname=$(basename "$cwd")

size=$(echo "$input" | jq -r '.context_window.context_window_size // 200000')
[ "$size" -eq 0 ] 2>/dev/null && size=200000
input_tokens=$(echo "$input" | jq -r '.context_window.current_usage.input_tokens // 0')
cache_create=$(echo "$input" | jq -r '.context_window.current_usage.cache_creation_input_tokens // 0')
cache_read=$(echo "$input" | jq -r '.context_window.current_usage.cache_read_input_tokens // 0')
current=$(( input_tokens + cache_create + cache_read ))
[ "$size" -gt 0 ] && pct_used=$(( current * 100 / size )) || pct_used=0

git_branch=""
git_dirty=""
if git -C "$cwd" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    git_branch=$(git -C "$cwd" symbolic-ref --short HEAD 2>/dev/null)
    [ -n "$(git -C "$cwd" status --porcelain 2>/dev/null)" ] && git_dirty="*"
fi

# ── LINE 1 ──────────────────────────────────────────────
pct_color=$(color_for_tokens "$current")

line1="${model_name}"
line1+="${sep}"
line1+="ctx ${pct_color}${pct_used}%${reset}"
line1+="${sep}"
line1+="${dirname}"
if [ -n "$git_branch" ]; then
    line1+=" (${git_branch}${git_dirty})"
fi

# ── OAuth token ──────────────────────────────────────────
# Profile-aware: with CLAUDE_CONFIG_DIR set, Claude Code stores credentials
# under "Claude Code-credentials-<first 8 hex of sha256(configDir)>".
config_dir="${CLAUDE_CONFIG_DIR:-$HOME/.claude}"
keychain_service="Claude Code-credentials"
if [ -n "$CLAUDE_CONFIG_DIR" ]; then
    dir_hash=$(printf '%s' "$CLAUDE_CONFIG_DIR" | shasum -a 256 | cut -c1-8)
    keychain_service="Claude Code-credentials-${dir_hash}"
fi

get_oauth_token() {
    [ -n "$CLAUDE_CODE_OAUTH_TOKEN" ] && { echo "$CLAUDE_CODE_OAUTH_TOKEN"; return 0; }
    if command -v security >/dev/null 2>&1; then
        local blob
        blob=$(security find-generic-password -s "$keychain_service" -w 2>/dev/null)
        if [ -n "$blob" ]; then
            local token
            token=$(echo "$blob" | jq -r '.claudeAiOauth.accessToken // empty' 2>/dev/null)
            [ -n "$token" ] && [ "$token" != "null" ] && { echo "$token"; return 0; }
        fi
    fi
    local creds_file="${config_dir}/.credentials.json"
    if [ -f "$creds_file" ]; then
        local token
        token=$(jq -r '.claudeAiOauth.accessToken // empty' "$creds_file" 2>/dev/null)
        [ -n "$token" ] && [ "$token" != "null" ] && { echo "$token"; return 0; }
    fi
    echo ""
}

# ── Fetch usage data (cached 60s) ────────────────────────
profile_key=$(basename "$config_dir")
cache_file="/tmp/claude/statusline-usage-cache-${profile_key}.json"
cache_max_age=60
mkdir -p /tmp/claude

needs_refresh=true
usage_data=""

if [ -f "$cache_file" ]; then
    cache_mtime=$(stat -f %m "$cache_file" 2>/dev/null || stat -c %Y "$cache_file" 2>/dev/null)
    now=$(date +%s)
    cache_age=$(( now - cache_mtime ))
    [ "$cache_age" -lt "$cache_max_age" ] && { needs_refresh=false; usage_data=$(cat "$cache_file" 2>/dev/null); }
fi

if $needs_refresh; then
    token=$(get_oauth_token)
    if [ -n "$token" ] && [ "$token" != "null" ]; then
        response=$(curl -s --max-time 5 \
            -H "Accept: application/json" \
            -H "Content-Type: application/json" \
            -H "Authorization: Bearer $token" \
            -H "anthropic-beta: oauth-2025-04-20" \
            -H "User-Agent: claude-code/2.1.34" \
            "https://api.anthropic.com/api/oauth/usage" 2>/dev/null)
        if [ -n "$response" ] && echo "$response" | jq -e '.five_hour' >/dev/null 2>&1; then
            usage_data="$response"
            echo "$response" > "$cache_file"
        fi
    fi
    [ -z "$usage_data" ] && [ -f "$cache_file" ] && usage_data=$(cat "$cache_file" 2>/dev/null)
fi

# ── LINES 2 & 3: Usage meters ────────────────────────────
rate_lines=""
bar_width=10

if [ -n "$usage_data" ] && echo "$usage_data" | jq -e . >/dev/null 2>&1; then
    five_hour_pct=$(echo "$usage_data" | jq -r '.five_hour.utilization // 0' | awk '{printf "%.0f", $1}')
    five_hour_reset_iso=$(echo "$usage_data" | jq -r '.five_hour.resets_at // empty')
    five_hour_reset=$(format_reset_time "$five_hour_reset_iso" "countdown")
    five_hour_bar=$(build_bar "$five_hour_pct" "$bar_width")
    five_hour_pct_color="$white"

    seven_day_pct=$(echo "$usage_data" | jq -r '.seven_day.utilization // 0' | awk '{printf "%.0f", $1}')
    seven_day_reset_iso=$(echo "$usage_data" | jq -r '.seven_day.resets_at // empty')
    seven_day_reset=$(format_reset_time "$seven_day_reset_iso" "datetime")
    seven_day_bar=$(build_bar "$seven_day_pct" "$bar_width")
    seven_day_pct_color="$white"

    rate_lines+="${white}current${reset} ${five_hour_bar} ${five_hour_pct_color}${five_hour_pct}%${reset} ${dim}⟳${reset} ${white}${five_hour_reset}${reset}"
    rate_lines+="\n${white}weekly${reset}  ${seven_day_bar} ${seven_day_pct_color}${seven_day_pct}%${reset} ${dim}⟳${reset} ${white}${seven_day_reset}${reset}"

fi

# ── Output ───────────────────────────────────────────────
printf "%b" "$line1"
[ -n "$rate_lines" ] && printf "\n\n%b" "$rate_lines"
