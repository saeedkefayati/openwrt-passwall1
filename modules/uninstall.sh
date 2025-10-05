#!/bin/sh
#========================================
# uninstall.sh - Uninstall Passwall v1
#========================================


uninstall_passwall() {
    # Step 1: Stopping Passwall service
    info "Stopping Passwall service..."
    [ -x "$PASSWALL_SERVICE" ] && "$PASSWALL_SERVICE" stop

    # Step 2: Removing Passwall packages
    info "Removing Passwall packages..."
    opkg remove "$PASSWALL_PACKAGE" || warn "Failed to remove package, maybe not installed"

    # Step 3: Remove Passwall repositories
    FEEDS="passwall_packages passwall_luci"

    for feed in $FEEDS; do
        if grep -q "$feed" /etc/opkg/customfeeds.conf; then
            info "Removing feed $feed"
            sed -i "/$feed/d" /etc/opkg/customfeeds.conf
        else
            warn "Feed $feed not found in customfeeds.conf"
        fi
    done

    # Step 4: Remove configuration files
    info "Removing configuration files..."
    [ -d "$PASSWALL_CONFIG_DIR" ] && rm -rf "$PASSWALL_CONFIG_DIR"
    [ -f "$PASSWALL_BIN_DIR" ] && rm -f "$PASSWALL_BIN_DIR"

    # Step 5: Update package lists
    info "Updating package lists..."
    opkg update || error "Failed to update package lists"

    success "Passwall v1 uninstalled successfully!"
}

