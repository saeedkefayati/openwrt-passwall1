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
    echo "         Now you can use '${PASSWALL_COMMAND}' command      "
    echo "-----------------------------------------------------"
}


# -------------------------------
# Show OpenWrt Information
# -------------------------------
show_openwrt_info() {
    echo "             OpenWrt System Information             "
    echo ""
    printf "%-12s : %b\n" "RELEASE_TYPE" "$RELEASE_TYPE"
    printf "%-12s : %b\n" "RELEASE" "$RELEASE"
    printf "%-12s : %b\n" "ARCH" "$ARCH"
    printf "%-12s : %b\n" "REVISION" "$REVISION"
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


# -------------------------------
# Get OpenWrt Information
# -------------------------------
get_openwrt_info() {
    [ -f /etc/openwrt_release ] || { error "/etc/openwrt_release not found!"; return 1; }

    RELEASE=$(grep DISTRIB_RELEASE /etc/openwrt_release | cut -d"'" -f2)
    REVISION=$(grep DISTRIB_REVISION /etc/openwrt_release | cut -d"'" -f2)
    ARCH=$(grep DISTRIB_ARCH /etc/openwrt_release | cut -d"'" -f2)

    if [ -z "$RELEASE" ]; then
        RELEASE_TYPE="UNKNOWN"
    elif echo "$RELEASE" | grep -iq "snapshot"; then
        RELEASE_TYPE="SNAPSHOT"
    elif echo "$RELEASE" | grep -iq "rc"; then
        RELEASE_TYPE="RC"
    elif echo "$RELEASE" | grep -iq "beta"; then
        RELEASE_TYPE="BETA"
    else
        RELEASE_TYPE="STABLE"
    fi

    export RELEASE_TYPE RELEASE ARCH REVISION
}


# -------------------------------
# Passwall Add Feeds
# -------------------------------
add_passwall_feeds() {
    [ -z "$RELEASE" ] && { error "RELEASE not set! Run get_openwrt_info first."; return 1; }
    [ -z "$ARCH" ] && { error "ARCH not set! Run get_openwrt_info first."; return 1; }
    [ -z "$RELEASE_TYPE" ] && { error "RELEASE_TYPE not set! Run get_openwrt_info first."; return 1; }

    FEEDS="passwall_packages passwall_luci"

    case "$RELEASE_TYPE" in
        SNAPSHOT)
            BASE_URL="https://master.dl.sourceforge.net/project/openwrt-passwall-build/snapshots/packages-$RELEASE/$ARCH"
            ;;
        RC|BETA|STABLE)
            BASE_URL="https://master.dl.sourceforge.net/project/openwrt-passwall-build/releases/packages-$RELEASE/$ARCH"
            ;;
        *)
            warn "Unknown RELEASE_TYPE, defaulting to releases path"
            BASE_URL="https://master.dl.sourceforge.net/project/openwrt-passwall-build/releases/packages-$RELEASE/$ARCH"
            ;;
    esac

    info "Adding Passwall repositories for $RELEASE_TYPE ($RELEASE/$ARCH)..."

    for feed in $FEEDS; do
        if grep -q "$feed" /etc/opkg/customfeeds.conf 2>/dev/null; then
            info "Feed $feed already exists, skipping."
        else
            echo "src/gz $feed $BASE_URL/$feed" >> /etc/opkg/customfeeds.conf
            success "Added feed: $feed"
        fi
    done
}