#!/bin/sh
#========================================
# disable.sh - Disable Passwall Service
#========================================

. "$(dirname "$0")/config.cfg"
. "$(dirname "$0")/utils/common.sh"

disable_passwall() {
    info "Disabling Passwall v1 service..."

    if [ -x "$PASSWALL_SERVICE" ]; then
        "$PASSWALL_SERVICE" disable
        success "Passwall service disabled."
    else
        warn "Passwall service not found!"
    fi
}

[ "${0##*/}" = "disable.sh" ] && disable_passwall
