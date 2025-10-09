#!/bin/sh
#========================================
# enable.sh - Enable Passwall Service
#========================================


enable_passwall() {
    info "Enabling Passwall v1 service..."
    passwall_service enable
    sleep 3
}

