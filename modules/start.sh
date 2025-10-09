#!/bin/sh
#========================================
# start.sh - Start Passwall Service
#========================================


start_passwall() {
    info "Starting Passwall v1 service..."
    passwall_service start
    success "Passwall service started."
    sleep 3
}

