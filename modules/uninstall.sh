#!/bin/sh
#========================================
# uninstall.sh - Uninstall Passwall v1
#========================================


uninstall_passwall() {
    info "Stopping Passwall service..."
    [ -x "$PASSWALL_SERVICE" ] && "$PASSWALL_SERVICE" stop

    info "Removing Passwall packages..."
    opkg remove "$PASSWALL_PACKAGE" || warn "Failed to remove package, maybe not installed"

    info "Removing configuration files..."
    [ -d /etc/config/passwall ] && rm -rf /etc/config/passwall
    [ -f "$PASSWALL_BIN_DIR" ] && rm -f "$PASSWALL_BIN_DIR"
    [ -d "$PASSWALL_INSTALL_DIR" ] && rm -rf "$PASSWALL_INSTALL_DIR"

    success "Passwall uninstalled successfully!"
}

