#!/bin/sh
#========================================
# enable.sh - Enable Passwall Service
#========================================

. "$(dirname "$0")/config.cfg"
. "$(dirname "$0")/utils/common.sh"

enable_passwall() {
    info "Enabling Passwall v1 service..."
    if [ -x "$PASSWALL_SERVICE" ]; then
        "$PASSWALL_SERVICE" enable
        success "Passwall service enabled."
    else
        warn "Passwall service not found!"
    fi
}

[ "${0##*/}" = "enable.sh" ] && enable_passwall
