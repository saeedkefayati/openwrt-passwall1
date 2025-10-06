#!/bin/sh
#========================================
# update.sh - Update Passwall v1
#========================================


update_passwall() {
    info "Updating Passwall v1..."
    opkg update
    if ! opkg install "$PASSWALL_PACKAGE"; then
        error "Update failed!"
        return 1
    fi

    success "Restarting Passwall service..."
    [ -x "$PASSWALL_SERVICE_DIR" ] && "$PASSWALL_SERVICE_DIR" restart

    success "Update completed successfully!"
    sleep 3
}

