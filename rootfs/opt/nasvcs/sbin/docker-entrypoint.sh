#!/bin/sh
set -e

entrypoint_log() {
    echo "$(date '+%Y-%m-%dT%H:%M:%S%z') nasvcs: $*"
}

entrypoint_log "version ${NASVCS_VERSION:-unknown} starting"

if [ ! -f /opt/nasvcs/etc/ssh/ssh_host_ecdsa_key ] || [ ! -f /opt/nasvcs/etc/ssh/ssh_host_ed25519_key ] || [ ! -f /opt/nasvcs/etc/ssh/ssh_host_rsa_key ]
then
    entrypoint_log "generating SSH host keys"
    mkdir -p /opt/nasvcs/etc/ssh
    ssh-keygen -Af /opt/nasvcs | ts '%Y-%m-%dT%H:%M:%S%z'
fi

if [ ! -s /opt/nasvcs/etc/ssh/authorized_keys ]
then
    entrypoint_log "warning: authorized_keys file not found or empty"
fi

entrypoint_log "enabling vcs user with a random password"
PW=$(head -c 32 /dev/urandom | base64) && echo -e "$PW\n$PW" | passwd vcs >/dev/null 2>&1 && unset PW

exec "$@"
