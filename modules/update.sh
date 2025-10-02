#!/bin/bash

update_passwall() {
    echo "Updating Passwall v1..."
    opkg update
    opkg install luci-app-passwall || {
        echo "Update failed!"
        return 1
    }
    /etc/init.d/passwall restart
    echo "Update completed successfully."
}
