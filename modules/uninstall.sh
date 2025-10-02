#!/bin/sh

uninstall_passwall() {
    echo "Uninstalling Passwall v1..."
    /etc/init.d/passwall stop
    opkg remove luci-app-passwall
    rm -rf /etc/config/passwall
    rm -rf /usr/bin/passwall
    echo "Uninstallation completed successfully."
}
