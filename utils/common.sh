#!/bin/sh
#========================================
# Common Helper Functions
#========================================


# -------------------------------
# Colors
# -------------------------------
USE_COLOR=1
[ ! -t 1 ] && USE_COLOR=0

NC="\033[0m"
GREEN="\033[1;32m"
YELLOW="\033[1;33m"
RED="\033[1;31m"
CYAN="\033[1;36m"

color() { [ "$USE_COLOR" -eq 1 ] && printf "%b" "$1" || true; }

#----------------------------------------
# Logger
#----------------------------------------
info()    { printf "%b\n" "${CYAN}[INFO]${NC} $1"; }
success() { printf "%b\n" "${GREEN}[OK]${NC} $1"; }
warn()    { printf "%b\n" "${YELLOW}[WARN]${NC} $1"; }
error()   { printf "%b\n" "${RED}[ERROR]${NC} $1"; }


#----------------------------------------
# Check if dependecy exists
#----------------------------------------
check_command() {
    cmd="$1"

    if command -v "$cmd" >/dev/null 2>&1; then
        info "Command '$cmd' found."
    else
        error "Required command '$cmd' not found. Please install it."
    fi
}


# -------------------------------
# Clear terminal
# -------------------------------
clear_terminal() {
    if command -v printf >/dev/null 2>&1; then
        printf "\033c"
    elif command -v clear >/dev/null 2>&1; then
        clear
    elif command -v reset >/dev/null 2>&1; then
        reset
    else
        error "No method to clear terminal available"
    fi
}


# -------------------------------
# Show Banner
# -------------------------------
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
    echo "         Now you can use '${PASSWALL_COMMAND}' command      "
    echo "-------------------------------------------------"
}


# -------------------------------
# Show Core Status
# -------------------------------
show_core_status() {
    echo "              Core Component Status              "

    grep -E '^SERVICE_[0-9]+' "./config.cfg" | while IFS= read -r line; do
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
