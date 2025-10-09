#!/bin/sh
#========================================
# uninstall.sh - Uninstall Passwall v1
#========================================

uninstall_passwall() {
    # Step 1: Stop the Passwall service
    info "Stopping Passwall service..."
    passwall_service stop

    # Step 2: Remove the Passwall package (suppressing errors)
    info "Removing Passwall packages..."
    opkg remove "$PASSWALL_PACKAGE" >/dev/null 2>&1 || warn "Package not found or failed to remove."
    
    # Step 3: Remove the software repositories
    info "Removing Passwall repositories..."
    FEEDS="passwall_packages passwall_luci"
    for feed in $FEEDS; do
        if grep -q "$feed" /etc/opkg/customfeeds.conf; then
            sed -i "/$feed/d" /etc/opkg/customfeeds.conf
            success "Removed feed: $feed"
        fi
    done

    # Step 4: Remove files created by this script
    info "Removing custom script files..."
    if [ -f "$PASSWALL_BIN_DIR" ]; then
        rm -f "$PASSWALL_BIN_DIR"
        success "Removed command: $PASSWALL_BIN_DIR"
    fi
    
    # Step 5: Completely remove the main script directory
    info "Removing main script directory..."
    if [ -d "$PASSWALL_INSTALL_DIR" ]; then
        rm -rf "$PASSWALL_INSTALL_DIR"
        success "Removed directory: $PASSWALL_INSTALL_DIR"
    fi

    # Step 6: Update package lists
    info "Updating package lists..."
    opkg update

    success "Passwall v1 uninstalled successfully!"
    sleep 3
}