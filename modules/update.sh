#!/bin/sh
#========================================
# update.sh - Update Passwall v1
#========================================

BASE_DIR="${PASSWALL_INSTALL_DIR:-/root/passwall1}"
. "$BASE_DIR/utils/common.sh"
. "$BASE_DIR/config.cfg"

update_passwall() {
    info "Updating Passwall v1..."
    opkg update
    if ! opkg install "$PASSWALL_PACKAGE"; then
        error "Update failed!"
        return 1
    fi

    info "Restarting Passwall service..."
    [ -x "$PASSWALL_SERVICE" ] && "$PASSWALL_SERVICE" restart

    info "Update completed successfully!"
}

[ "${0##*/}" = "update.sh" ] && update_passwall
