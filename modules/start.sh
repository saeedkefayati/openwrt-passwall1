#!/bin/sh
#========================================
# start.sh - Start Passwall Service
#========================================

BASE_DIR="${PASSWALL_INSTALL_DIR:-/root/passwall1}"
. "$BASE_DIR/utils/common.sh"
. "$BASE_DIR/config.cfg"

start_passwall() {
    info "Starting Passwall v1 service..."
    if [ -x "$PASSWALL_SERVICE" ]; then
        "$PASSWALL_SERVICE" start
        success "Passwall service started."
    else
        warn "Passwall service not found!"
    fi
}

[ "${0##*/}" = "start.sh" ] && start_passwall
