#!/bin/sh
set -e

entrypoint_log() {
    echo "$(date -Iseconds) nasvcs: $*"
}

entrypoint_log "version ${NASVCS_VERSION:-unknown} starting"

if [ ! -f /opt/nasvcs/etc/ssh/ssh_host_ecdsa_key ] || [ ! -f /opt/nasvcs/etc/ssh/ssh_host_ed25519_key ] || [ ! -f /opt/nasvcs/etc/ssh/ssh_host_rsa_key ]
then
    entrypoint_log "generating SSH host keys"
    mkdir -p /opt/nasvcs/etc/ssh
    ssh-keygen -Af /opt/nasvcs
fi

exec "$@"
