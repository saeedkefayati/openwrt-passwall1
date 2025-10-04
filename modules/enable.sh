#!/bin/sh
#========================================
# enable.sh - Enable Passwall Service
#========================================

BASE_DIR="${PASSWALL_INSTALL_DIR:-/root/passwall1}"
. "$BASE_DIR/utils/common.sh"
. "$BASE_DIR/config.cfg"

enable_passwall() {
    info "Enabling Passwall v1 service..."
    if [ -x "$PASSWALL_SERVICE" ]; then
        "$PASSWALL_SERVICE" enable
        info "Passwall service enabled."
    else
        warn "Passwall service not found!"
    fi
}

[ "${0##*/}" = "enable.sh" ] && enable_passwall
