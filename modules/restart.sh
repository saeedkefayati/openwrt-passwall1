#!/bin/sh
#========================================
# restart.sh - Restart Passwall Service
#========================================

. "$(dirname "$0")/config.cfg"
. "$(dirname "$0")/utils/common.sh"

restart_passwall() {
    info "Restarting Passwall v1 service..."
    if [ -x "$PASSWALL_SERVICE" ]; then
        "$PASSWALL_SERVICE" restart
        success "Passwall service restarted."
    else
        warn "Passwall service not found!"
    fi
}

[ "${0##*/}" = "restart.sh" ] && restart_passwall
