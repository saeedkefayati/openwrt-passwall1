#!/bin/sh
#========================================
# exit.sh - Exit Passwall Main Menu
#========================================

. "$(dirname "$0")/utils/common.sh"

exit_passwall() {
    info "Exiting Passwall v1..."
    exit 0
}

[ "${0##*/}" = "exit.sh" ] && exit_passwall
