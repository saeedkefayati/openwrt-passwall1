#!/bin/sh
#========================================
# start.sh - Start Passwall Service
#========================================


start_passwall() {
    info "Starting Passwall v1 service..."
    if [ -x "$PASSWALL_SERVICE_DIR" ]; then
        "$PASSWALL_SERVICE_DIR" start
        success "Passwall service started."
    else
        warn "Passwall service not found!"
    fi
    sleep 3
}

