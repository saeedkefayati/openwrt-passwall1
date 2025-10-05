#!/bin/sh
#========================================
# restart.sh - Restart Passwall Service
#========================================


restart_passwall() {
    info "Restarting Passwall v1 service..."
    if [ -x "$PASSWALL_SERVICE" ]; then
        "$PASSWALL_SERVICE" restart
        success "Passwall service restarted."
    else
        warn "Passwall service not found!"
    fi
}

