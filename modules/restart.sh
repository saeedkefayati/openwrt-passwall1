#!/bin/sh
#========================================
# restart.sh - Restart Passwall Service
#========================================

BASE_DIR="$(cd "$(dirname "$0")/.." && pwd)"
. "$BASE_DIR/utils/common.sh"
. "$BASE_DIR/config.cfg"

restart_passwall() {
    info "Restarting Passwall v1 service..."
    if [ -x "$PASSWALL_SERVICE" ]; then
        "$PASSWALL_SERVICE" restart
        info "Passwall service restarted."
    else
        warn "Passwall service not found!"
    fi
}

[ "${0##*/}" = "restart.sh" ] && restart_passwall
