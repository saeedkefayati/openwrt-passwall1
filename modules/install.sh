#!/bin/sh

install_passwall() {
    echo "Installing Passwall v1..."
    # Update package lists
    opkg update

    # Install main package
    opkg install luci-app-passwall || {
        echo "Installation failed!"
        return 1
    }

    echo "Applying initial configuration..."
    uci set passwall.@global[0].enabled='1'
    uci commit passwall
    /etc/init.d/passwall restart
    echo "Installation completed successfully."
}
