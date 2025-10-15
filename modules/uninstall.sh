#!/bin/sh
#========================================
# uninstall.sh - Uninstall Passwall v1
#========================================

uninstall_passwall() {
    # Step 1: Stop the Passwall service
    info "Stopping Passwall service..."
    passwall_service stop

    # Step 2: Remove the Passwall package
    info "Removing Passwall package..."
    opkg remove "$PASSWALL_PACKAGE" >/dev/null 2>&1 || warn "Package not found or failed to remove."

    # Step 3: Remove feeds
    info "Removing Passwall repositories..."
    FEEDS="passwall_packages passwall_luci"
    for feed in $FEEDS; do
        if grep -q "$feed" "$CUSTOM_FEEDS_FILE"; then
            sed -i "/$feed/d" "$CUSTOM_FEEDS_FILE"
            success "Removed feed: $feed"
        fi
    done

    # Step 4: Remove files and directories
    info "Removing custom script files..."
    [ -f "$PASSWALL_BIN_DIR" ] && rm -f "$PASSWALL_BIN_DIR" && success "Removed command: $PASSWALL_BIN_DIR"
    # info "Removing main script directory..."
    # [ -d "$PASSWALL_INSTALL_DIR" ] && rm -rf "$PASSWALL_INSTALL_DIR" && success "Removed directory: $PASSWALL_INSTALL_DIR"

    # Step 5: Update package lists
    info "Updating package lists..."
    opkg update

    success "Passwall v1 uninstalled successfully!"
    sleep 3
}