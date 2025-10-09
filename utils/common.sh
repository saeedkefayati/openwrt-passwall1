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
# Check if dependency exists
#----------------------------------------
check_command() {
    cmd="$1"

    if command -v "$cmd" >/dev/null 2>&1; then
        info "Command '$cmd' found."
    else
        error "Required command '$cmd' not found. Please install it."
        return 1
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
}


# -------------------------------
# Show Separator
# -------------------------------
show_separator() {
    banner_width=$(wc -L < ./banner.txt)

    if [ ! -f "./banner.txt" ]; then
        error "banner.txt file not found!"
        exit 1
    fi

    printf '%.0s-' $(seq 1 $banner_width)
    echo ""
}


# -------------------------------
# Show Shortcut
# -------------------------------
show_centered_text() {
    banner_width=$(wc -L < ./banner.txt)
    
    text_to_center="$1"
    text_len=${#text_to_center}
    
    padding=$(( (banner_width - text_len) / 2 ))
    
    printf "%*s%s\n" "$padding" "" "$text_to_center"
}
