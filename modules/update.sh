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
    [ -x "$PASSWALL_SERVICE" ] && "$PASSWALL_SERVICE" restart

    success "Update completed successfully!"
}

[ "${0##*/}" = "update.sh" ] && update_passwall
