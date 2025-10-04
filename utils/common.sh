#!/bin/sh
#========================================
# common.sh - Helper functions
#========================================

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
# Check if dependecy exists
#----------------------------------------
check_dependency() {
    local name=$1
    local pkg=${2:-$name}
    local auto_install=${3:-false}

    # check command
    if command -v "$name" >/dev/null 2>&1; then
        info "Dependency '$name' found (command)."
        return 0
    fi

    # check package
    if opkg list-installed | grep -q "^$pkg "; then
        info "Dependency '$pkg' found (package)."
        return 0
    fi

    # install automatic
    if [ "$auto_install" = true ]; then
        info "Dependency '$pkg' not found. Installing..."
        opkg update && opkg install "$pkg" || error "Failed to install $pkg"
    else
        error "Dependency '$pkg' is missing. Install it with: opkg update && opkg install $pkg"
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
