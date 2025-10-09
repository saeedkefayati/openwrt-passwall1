#!/bin/sh
#========================================
# update.sh - Update Passwall v1
#========================================


update_passwall() {
    info "Updating Passwall v1 package..."
    opkg update
    if ! opkg install "$PASSWALL_PACKAGE"; then
        error "Update failed!"
        return 1
    fi

    info "Updating Passwall v1 service..."
    passwall_service restart
    success "Passwall service restarted."

    success "Update completed successfully!"
    sleep 3
}

