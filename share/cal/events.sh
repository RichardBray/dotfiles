# Shared calendar helpers, sourced by `agenda` and `cal-notify`.
#
# Reads the LOCAL calendar store that macOS keeps in sync with your accounts
# (added in System Settings > Internet Accounts). No API keys, no network of
# our own -- icalBuddy reads ~/Library/Calendars directly.

CAL_ICALBUDDY="${CAL_ICALBUDDY:-$(command -v icalBuddy 2>/dev/null || echo /opt/homebrew/bin/icalBuddy)}"
CAL_SEP="~~@~~"

# Calendars to ignore (holidays, birthdays, reminders). Override with $CAL_EXCLUDE.
CAL_EXCLUDE="${CAL_EXCLUDE:-UK Holidays,Birthdays,Holidays in United Kingdom,Holidays in the United Kingdom,Reminders}"

# cal_events <daysAhead>
# Emits one line per timed event:
#   "<startEpoch>|<YYYY-MM-DD>|<HH:MM>|<title>|<calendar>"
# All-day events (no start time) are skipped. icalBuddy appends the calendar
# name as a trailing "(...)" on the title line; we split it back out.
cal_events() {
  days="${1:-1}"
  if [ "$days" -lt 0 ]; then
    span="eventsFrom:$(date -v"${days}d" +%Y-%m-%d) to:$(date +%Y-%m-%d)"
  else
    span="eventsToday+${days}"
  fi
  "$CAL_ICALBUDDY" -nrd -npn -b "" -ps "|${CAL_SEP}|" \
    -iep "datetime,title" -po "datetime,title" \
    -df "%Y-%m-%d" -tf "%H:%M" -ec "$CAL_EXCLUDE" $span 2>/dev/null \
  | while IFS= read -r line; do
      [ -z "$line" ] && continue
      dt=${line%%"${CAL_SEP}"*}
      full=${line#*"${CAL_SEP}"}
      [ "$full" = "$line" ] && continue             # malformed / no separator

      # Calendar name is the LAST parenthetical icalBuddy appended.
      case "$full" in
        *" ("*) cal=${full##*\(}; cal=${cal%\)}; title=${full% (*} ;;
        *)      cal=""; title=$full ;;
      esac

      date=$(printf '%s' "$dt" | grep -oE '[0-9]{4}-[0-9]{2}-[0-9]{2}' | head -1)
      start=$(printf '%s' "$dt" | grep -oE '[0-9]{1,2}:[0-9]{2}' | head -1)
      [ -z "$date" ] && continue
      [ -z "$start" ] && continue                   # all-day -> skip
      epoch=$(date -j -f "%Y-%m-%d %H:%M" "$date $start" +%s 2>/dev/null)
      [ -z "$epoch" ] && continue
      printf '%s|%s|%s|%s|%s\n' "$epoch" "$date" "$start" "$title" "$cal"
    done
}

# cal_countdown <seconds> -> "<1m" | "42m" | "3h 5m"
cal_countdown() {
  s=$1
  [ "$s" -lt 60 ] && { echo "<1m"; return; }
  m=$((s / 60))
  [ "$m" -lt 60 ] && { echo "${m}m"; return; }
  h=$((m / 60)); m=$((m % 60))
  echo "${h}h ${m}m"
}

# cal_color <calendarName> -> a 256-color code, stable per calendar.
# icalBuddy can't read the real Calendar.app colors, so we deterministically
# hash the name to a fixed palette (same calendar -> same color every run).
# Override a specific calendar via CAL_COLORS="Work=39;Home=41".
cal_color() {
  _name=$1
  # explicit override?
  if [ -n "${CAL_COLORS:-}" ]; then
    _o=$(printf '%s' "$CAL_COLORS" | tr ';' '\n' | grep -F "${_name}=" | head -1)
    [ -n "$_o" ] && { echo "${_o#*=}"; return; }
  fi
  _palette="39 208 41 170 197 220 45 214 129 81"
  _count=$(echo "$_palette" | wc -w | tr -d ' ')
  _n=$(printf '%s' "$_name" | cksum | cut -d' ' -f1)
  _i=$(( _n % _count + 1 ))
  echo "$_palette" | cut -d' ' -f"$_i"
}
