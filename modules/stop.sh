#!/bin/sh
#========================================
# stop.sh - Stop Passwall Service
#========================================


stop_passwall() {
    info "Stopping Passwall v1 service..."
    if [ -x "$PASSWALL_SERVICE_DIR" ]; then
        "$PASSWALL_SERVICE_DIR" stop
        success "Passwall service stopped."
    else
        warn "Passwall service not found!"
    fi
    sleep 3
}

