#!/bin/sh
#========================================
# stop.sh - Stop Passwall Service
#========================================

BASE_DIR="$(cd "$(dirname "$0")/.." && pwd)"
. "$BASE_DIR/utils/common.sh"
. "$BASE_DIR/config.cfg"

stop_passwall() {
    info "Stopping Passwall v1 service..."
    if [ -x "$PASSWALL_SERVICE" ]; then
        "$PASSWALL_SERVICE" stop
        info "Passwall service stopped."
    else
        warn "Passwall service not found!"
    fi
}

[ "${0##*/}" = "stop.sh" ] && stop_passwall
