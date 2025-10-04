#!/bin/sh

uninstall_passwall() {
    echo "Uninstalling Passwall v1..."
    /etc/init.d/passwall stop 
    opkg remove luci-app-passwall --autoremove || true
    [ -d /etc/config/passwall ] && rm -rf /etc/config/passwall
    [ -f /usr/bin/passwall1 ] && rm -f /usr/bin/passwall1
    [ -f /root/passwall1 ] && rm -f /root/passwall1
    echo "Uninstallation completed successfully."
}
