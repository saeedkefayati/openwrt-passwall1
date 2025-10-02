#!/bin/bash

stop_passwall() {
    echo "Stopping Passwall v1 service..."
    /etc/init.d/passwall stop
}
