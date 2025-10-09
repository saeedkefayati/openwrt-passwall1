#!/bin/sh
#========================================
# enable.sh - Enable Passwall Service
#========================================


enable_passwall() {
    info "Enabling Passwall v1 service..."
    passwall_service enable
    success "Passwall service enabled."
    sleep 3
}

