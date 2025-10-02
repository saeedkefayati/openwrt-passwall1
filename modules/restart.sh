#!/bin/sh

restart_passwall() {
    echo "Restarting Passwall v1 service..."
    /etc/init.d/passwall restart
}
