#!/bin/sh
#========================================
# update.sh - Update Passwall v1
#========================================


update_passwall() {
    info "Updating package lists..."
    opkg update
    
    info "Updating Passwall v1 package..."
    if ! opkg install "$PASSWALL_PACKAGE"; then
        error "Update failed!"
        return 1
    fi

    info "Restarting Passwall v1 service after update..."
    passwall_service restart

    success "Update completed successfully!"
    sleep 3
}

