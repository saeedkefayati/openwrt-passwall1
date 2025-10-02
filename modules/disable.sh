#!/bin/bash

disable_passwall() {
    echo "Disabling Passwall v1 service..."
    /etc/init.d/passwall disable
}
