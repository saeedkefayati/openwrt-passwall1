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
    cat ./banner.txt
    echo ""
    echo "         Now you can use '${PASSWALL_COMMAND}' command      "
    echo "-----------------------------------------------------"
}


# -------------------------------
# Show Core Status
# -------------------------------
show_core_status() {
    echo "              Core Component Status              "
    echo ""
    grep -E '^SERVICE_[0-9]+' "./config.cfg" | while IFS= read -r line; do
        value=$(echo "$line" | cut -d'=' -f2- | tr -d '"')
        name=$(echo "$value" | cut -d'|' -f1)
        path=$(echo "$value" | cut -d'|' -f2)

        if [ ! -x "$path" ]; then
            status="${RED}Not Installed${NC}"
        else
            if ps -w | grep -v "grep" | grep -q -E "xray|sing-box|hysteria"; then
                status="${GREEN}Running${NC}"
            else
                status="${YELLOW}Stopped${NC}"
            fi
        fi

        printf "%-12s : %b\n" "$name" "$status"
    done

    echo "-----------------------------------------------------"
}


# -------------------------------
# Passwall Service Runner
# -------------------------------
passwall_service() {
    action="$1" # 'start', 'stop', 'restart', etc.

    if ! [ -x "$PASSWALL_SERVICE_DIR" ]; then
        warn "Passwall service not found!"
        return 1 
    fi

    mkdir -p /tmp/etc/passwall

    if "$PASSWALL_SERVICE_DIR" "$action"; then
        success "Passwall service '$action' command completed successfully."
        return 0
    else
        error "Passwall service '$action' command failed."
        return 1
    fi
}