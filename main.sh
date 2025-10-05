#!/bin/sh
#========================================
# Passwall v1 Main Script
#========================================

# -------------------------------
# Load all scripts
# -------------------------------
. "./config.cfg"
. "./utils/common.sh"

#========================================
# disable.sh - Disable Passwall Service
#========================================
disable_passwall() {
    info "Disabling Passwall v1 service..."

    if [ -x "$PASSWALL_SERVICE" ]; then
        "$PASSWALL_SERVICE" disable
        success "Passwall service disabled."
    else
        warn "Passwall service not found!"
    fi
}


#========================================
# enable.sh - Enable Passwall Service
#========================================
enable_passwall() {
    info "Enabling Passwall v1 service..."
    if [ -x "$PASSWALL_SERVICE" ]; then
        "$PASSWALL_SERVICE" enable
        success "Passwall service enabled."
    else
        warn "Passwall service not found!"
    fi
}


#========================================
# exit.sh - Exit Passwall Main Menu
#========================================
exit_passwall() {
    info "Exiting Passwall v1..."
    exit 0
}


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


#========================================
# restart.sh - Restart Passwall Service
#========================================
restart_passwall() {
    info "Restarting Passwall v1 service..."
    if [ -x "$PASSWALL_SERVICE" ]; then
        "$PASSWALL_SERVICE" restart
        success "Passwall service restarted."
    else
        warn "Passwall service not found!"
    fi
}


#========================================
# start.sh - Start Passwall Service
#========================================
start_passwall() {
    info "Starting Passwall v1 service..."
    if [ -x "$PASSWALL_SERVICE" ]; then
        "$PASSWALL_SERVICE" start
        success "Passwall service started."
    else
        warn "Passwall service not found!"
    fi
}


#========================================
# stop.sh - Stop Passwall Service
#========================================
stop_passwall() {
    info "Stopping Passwall v1 service..."
    if [ -x "$PASSWALL_SERVICE" ]; then
        "$PASSWALL_SERVICE" stop
        success "Passwall service stopped."
    else
        warn "Passwall service not found!"
    fi
}


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


# -------------------------------
# Main menu loop
# -------------------------------
while true; do
    clear_terminal
    show_banner
    show_core_status

    echo "Select an operation for Passwall v1:"
    i=1
    while true; do
        eval entry=\$MENU_${i}
        [ -z "$entry" ] && break
        menu_text=$(echo "$entry" | cut -d'|' -f1)
        echo "${i}) $menu_text"
        i=$((i+1))
    done

    printf "Your choice: "
    read op_choice
    eval selected=\$MENU_${op_choice}
    if [ -n "$selected" ]; then
        action_function=$(echo "$selected" | cut -d'|' -f2)
        if command -v "$action_function" >/dev/null 2>&1; then
            $action_function
        else
            echo "[ERROR] Function '$action_function' is not defined!"
            sleep 2
        fi
    else
        echo "[ERROR] Invalid choice! Try again."
        sleep 2
    fi
done
