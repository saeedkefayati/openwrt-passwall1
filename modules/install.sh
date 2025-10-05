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
    else
        info "GPG key already exists, skipping."
    fi

    # Step 2: Detect release & architecture
    info "Detecting OpenWrt release and architecture..."
    [ -f /etc/openwrt_release ] || error "/etc/openwrt_release not found!"
    . /etc/openwrt_release
    RELEASE=${DISTRIB_RELEASE%.*}
    ARCH=$DISTRIB_ARCH
    info "Detected OpenWrt $RELEASE on $ARCH"

    # Step 3: Add Passwall repositories
    FEEDS="passwall_packages passwall_luci"
    for feed in $FEEDS; do
        if grep -q "$feed" /etc/opkg/customfeeds.conf; then
            info "Feed $feed already exists, skipping."
        else
            echo "src/gz $feed https://master.dl.sourceforge.net/project/openwrt-passwall-build/releases/packages-$RELEASE/$ARCH/$feed" >> /etc/opkg/customfeeds.conf
            info "Added feed $feed"
        fi
    done

    # Step 4: Update package lists
    info "Updating package lists..."
    opkg update || error "Failed to update package lists"

    # Step 5: Install Passwall v1
    info "Installing Passwall v1..."
    if opkg list-installed | grep -q "$PASSWALL_PACKAGE"; then
        info "Passwall already installed, skipping."
    else
        opkg install "$PASSWALL_PACKAGE" || error "Failed to install Passwall"
    fi

    # Step 6: Enable and start service
    info "Enabling and starting Passwall..."
    uci set passwall.@global[0].enabled='1'
    uci commit passwall
    "$PASSWALL_SERVICE" enable
    "$PASSWALL_SERVICE" restart

    success "Passwall v1 installation completed successfully!"
}

[ "${0##*/}" = "install.sh" ] && install_passwall
