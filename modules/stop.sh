#!/bin/sh
#========================================
# stop.sh - Stop Passwall Service
#========================================

. "$(dirname "$0")/config.cfg"
. "$(dirname "$0")/utils/common.sh"

stop_passwall() {
    info "Stopping Passwall v1 service..."
    if [ -x "$PASSWALL_SERVICE" ]; then
        "$PASSWALL_SERVICE" stop
        success "Passwall service stopped."
    else
        warn "Passwall service not found!"
    fi
}

[ "${0##*/}" = "stop.sh" ] && stop_passwall
