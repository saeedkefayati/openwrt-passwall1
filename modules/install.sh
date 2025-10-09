#!/bin/sh
#========================================
# install.sh - Install Passwall v1
#========================================

install_passwall() {

    info "Checking required commands..."
    check_command opkg
    check_command wget
    check_command uci

    # Step 1: Add Passwall GPG key
    info "Adding Passwall GPG key..."
    if ! opkg-key list | grep -q passwall; then
        wget -O /tmp/passwall.pub https://master.dl.sourceforge.net/project/openwrt-passwall-build/passwall.pub
        opkg-key add /tmp/passwall.pub
        rm /tmp/passwall.pub
        success "GPG key added successfully."
    else
        info "GPG key already exists, skipping."
    fi

    # Step 2: Detect OpenWrt info
    info "Detecting OpenWrt release and architecture..."
    get_openwrt_info
    info "Detected OpenWrt $RELEASE_TYPE ($RELEASE) on $ARCH"

    # Step 3: Add Passwall repositories
    info "Adding Passwall repositories..."
    add_passwall_feeds

    # Step 4: Update package lists
    info "Updating package lists..."
    opkg update || { error "Failed to update package lists"; return 1; }

    # Step 5: Install Passwall v1
    info "Installing Passwall v1..."
    if opkg list-installed | grep -q "$PASSWALL_PACKAGE"; then
        info "Passwall already installed, skipping."
    else
        opkg install "$PASSWALL_PACKAGE" || { error "Failed to install Passwall"; return 1; }
    fi

    # Step 6: Enable and start service
    info "Enabling Passwall service settings..."
    uci set passwall.@global[0].enabled='1'
    uci commit passwall
    
    info "Enabling service on boot..."
    passwall_service enable
    
    info "Restarting service to apply settings..."
    passwall_service restart

    success "Passwall v1 installation completed successfully!"
    sleep 3
}

