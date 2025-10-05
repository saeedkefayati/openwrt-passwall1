#!/bin/sh
#========================================
# enable.sh - Enable Passwall Service
#========================================


enable_passwall() {
    info "Enabling Passwall v1 service..."
    if [ -x "$PASSWALL_SERVICE_DIR" ]; then
        "$PASSWALL_SERVICE_DIR" enable
        success "Passwall service enabled."
    else
        warn "Passwall service not found!"
    fi
}

