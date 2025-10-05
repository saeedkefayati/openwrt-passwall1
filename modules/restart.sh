#!/bin/sh
#========================================
# restart.sh - Restart Passwall Service
#========================================

BASE_DIR="${PASSWALL_INSTALL_DIR:-/root/passwall1}"
. "$BASE_DIR/utils/common.sh"
. "$BASE_DIR/config.cfg"

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
