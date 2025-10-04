#!/bin/sh
#========================================
# common.sh - Helper functions
#========================================

BASE_DIR="$(cd "$(dirname "$0")/.." && pwd)"
. "$BASE_DIR/config.cfg"

#----------------------------------------
# Colors
#----------------------------------------
USE_COLOR=1
[ ! -t 1 ] && USE_COLOR=0

GREEN="\033[1;32m"
YELLOW="\033[1;33m"
RED="\033[1;31m"
NC="\033[0m"

color() { [ "$USE_COLOR" -eq 1 ] && printf "%b" "$1" || true; }


#----------------------------------------
# Log functions
#----------------------------------------
info()  { printf "%s[INFO]%s %s\n" "$(color "$GREEN")" "$(color "$NC")" "$*"; }
warn()  { printf "%s[WARN]%s %s\n" "$(color "$YELLOW")" "$(color "$NC")" "$*"; }
error() {
    local exit_now=${2:-1}
    printf "%s[ERROR]%s %s\n" "$(color "$RED")" "$(color "$NC")" "$1" >&2
    [ "$exit_now" -eq 1 ] && exit 1
}


#----------------------------------------
# Check if command exists
#----------------------------------------
check_command() {
    local cmd=$1
    local install_cmd=${2:-"opkg update && opkg install $cmd"}
    if ! command -v "$cmd" >/dev/null 2>&1; then
        error "Required command '$cmd' not found. Install it with: $install_cmd"
    fi
}


#----------------------------------------
# Clear terminal
#----------------------------------------
clear_terminal() { [ -t 1 ] && (printf "\033c" 2>/dev/null || clear || reset); }


#----------------------------------------
# Show Banner
#----------------------------------------
show_banner() {
    printf "%s" "$(color "$GREEN")"
    echo "-------------------------------------------------"
    echo " _____ _____ _____ _____ _ _ _ _____ __    __    "
    echo "|  _  |  _  |   __|   __| | | |  _  |  |  |  |   "
    echo "|   __|     |__   |__   | | | |     |  |__|  |__ "
    echo "|__|  |__|__|_____|_____|_____|__|__|_____|_____|"
    echo "                                                 "
    echo "             PASSWALL v1 MANAGEMENT              "
    echo "-------------------------------------------------"
    echo "         now you can use '${PASSWALL_COMMAND}' command      "
    echo "-------------------------------------------------"
    printf "%s" "$(color "$NC")"
}


#----------------------------------------
# Show Core Status
#----------------------------------------
show_core_status() {
    echo "              Core Component Status              "

    grep -E '^SERVICE_[0-9]+' "$BASE_DIR/config.cfg" | while IFS= read -r line; do
        value=$(echo "$line" | cut -d'=' -f2- | tr -d '"')
        name=$(echo "$value" | cut -d'|' -f1)
        path=$(echo "$value" | cut -d'|' -f2)
        
        if [ -x "$path" ] || command -v "$path" >/dev/null 2>&1; then
            if echo "$path" | grep -q "/init.d/"; then
                if "$path" status >/dev/null 2>&1; then
                    status="${GREEN}Running${NC}"
                else
                    status="${YELLOW}Stopped${NC}"
                fi
            else
                base_proc=$(basename "$path")
                if pgrep -x "$base_proc" >/dev/null 2>&1; then
                    status="${GREEN}Running${NC}"
                else
                    status="${YELLOW}Stopped${NC}"
                fi
            fi
        else
            status="${RED}Not Installed${NC}"
        fi
        
        printf "%-12s : %b\n" "$name" "$status"
    done

    echo "-------------------------------------------------"
}
