#!/bin/sh
#========================================
# stop.sh - Stop Passwall Service
#========================================


stop_passwall() {
    info "Stopping Passwall v1 service..."
    passwall_service stop
    sleep 3
}

