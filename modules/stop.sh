#!/bin/sh
#========================================
# stop.sh - Stop Passwall Service
#========================================


stop_passwall() {
    info "Stopping Passwall v1 service..."
    passwall_service stop
    success "Passwall service stopped."
    sleep 3
}

