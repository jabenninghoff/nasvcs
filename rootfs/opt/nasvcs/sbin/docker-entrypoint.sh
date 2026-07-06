#!/bin/sh
set -e

entrypoint_log() {
    echo "$(date '+%Y-%m-%dT%H:%M:%S%z') nasvcs: $*"
}

entrypoint_log "version ${NASVCS_VERSION:-unknown} starting"

# shellcheck disable=SC3028
entrypoint_log "using HOSTNAME ${HOSTNAME:-unknown}"

if [ -z "${NASVCS_GIT_PROJECTROOT}" ]
then
    export NASVCS_GIT_PROJECTROOT='/opt/nasvcs/vcs/git'
    entrypoint_log "warning: NASVCS_GIT_PROJECTROOT not set, using default ${NASVCS_GIT_PROJECTROOT}"
else
    entrypoint_log "using NASVCS_GIT_PROJECTROOT ${NASVCS_GIT_PROJECTROOT}"
fi

if [ ! -d "${NASVCS_GIT_PROJECTROOT}" ] || [ -z "$(ls "${NASVCS_GIT_PROJECTROOT}")" ]
then
    entrypoint_log "warning: NASVCS_GIT_PROJECTROOT directory does not exist or is empty"
fi

if [ ! -f /opt/nasvcs/etc/ssh/ssh_host_ecdsa_key ] || \
   [ ! -f /opt/nasvcs/etc/ssh/ssh_host_ed25519_key ] || \
   [ ! -f /opt/nasvcs/etc/ssh/ssh_host_rsa_key ]
then
    entrypoint_log "generating SSH host keys"
    mkdir -p /opt/nasvcs/etc/ssh
    ssh-keygen -Af /opt/nasvcs | ts '%Y-%m-%dT%H:%M:%S%z'
fi

if [ ! -s /opt/nasvcs/etc/ssh/authorized_keys ]
then
    entrypoint_log "warning: authorized_keys file does not exist or is empty"
fi

entrypoint_log "enabling vcs user with a random password"
PW=$(head -c 32 /dev/urandom | base64) && echo -e "$PW\n$PW" | passwd vcs >/dev/null 2>&1 && unset PW

entrypoint_log "creating symbolic links for vcs project roots"
for dir in /opt/nasvcs/vcs/*; do
    [ -d "$dir" ] || continue
    if ln -s "$dir" "/$(basename "$dir")"
    then
        entrypoint_log "created symbolic link /$(basename "$dir") -> $dir"
    else
        entrypoint_log "error creating symbolic link /$(basename "$dir") -> $dir"
    fi
done

entrypoint_log "initializing lighttpd log"
touch /var/log/lighttpd/access.log && chown lighttpd:lighttpd /var/log/lighttpd/access.log

exec "$@"
