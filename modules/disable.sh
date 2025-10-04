#!/bin/sh
#========================================
# disable.sh - Disable Passwall Service
#========================================

BASE_DIR="$(cd "$(dirname "$0")/.." && pwd)"
. "$BASE_DIR/utils/common.sh"
. "$BASE_DIR/config.cfg"

disable_passwall() {
    info "Disabling Passwall v1 service..."

    if [ -x "$PASSWALL_SERVICE" ]; then
        "$PASSWALL_SERVICE" disable
        info "Passwall service disabled."
    else
        warn "Passwall service not found!"
    fi
}

[ "${0##*/}" = "disable.sh" ] && disable_passwall
