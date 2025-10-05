#!/bin/sh
#========================================
# disable.sh - Disable Passwall Service
#========================================


disable_passwall() {
    info "Disabling Passwall v1 service..."

    if [ -x "$PASSWALL_SERVICE" ]; then
        "$PASSWALL_SERVICE" disable
        success "Passwall service disabled."
    else
        warn "Passwall service not found!"
    fi
}

