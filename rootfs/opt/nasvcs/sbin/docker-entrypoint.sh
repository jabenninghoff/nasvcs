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

# TODO: workaround for missing hyperlinks in directory listing for application/* MIME types (json php xsl yaml yml)
# upstream issue: https://github.com/viewvc/viewvc/issues/407
if [ -n "${NASVCS_VIEWVC_MIME_TYPE_WORKAROUND}" ]
then
    workaround="text/x-workaround ${NASVCS_VIEWVC_MIME_TYPE_WORKAROUND}"
    if ! grep -qxF "$workaround" /opt/nasvcs/viewvc/mimetypes.conf
    then
        entrypoint_log "applying NASVCS_VIEWVC_MIME_TYPE_WORKAROUND"
        entrypoint_log "setting ViewVC MIME_TYPE \"text/x-workaround ${NASVCS_VIEWVC_MIME_TYPE_WORKAROUND}\""
        sed -i 's/^#mime_types_files = mimetypes.conf/mime_types_files = mimetypes.conf/' /opt/nasvcs/viewvc/viewvc.conf
        echo "$workaround" >> /opt/nasvcs/viewvc/mimetypes.conf
    fi
fi

if [ ! -f /opt/nasvcs/etc/ssh/ssh_host_ecdsa_key ] || \
   [ ! -f /opt/nasvcs/etc/ssh/ssh_host_ed25519_key ] || \
   [ ! -f /opt/nasvcs/etc/ssh/ssh_host_rsa_key ]
then
    entrypoint_log "generating SSH host keys"
    mkdir -p /opt/nasvcs/etc/ssh
    # TODO: develop a better solution that doesn't pipe to ts
    ssh-keygen -Af /opt/nasvcs | ts '%Y-%m-%dT%H:%M:%S%z'
fi

if [ ! -s /opt/nasvcs/etc/ssh/authorized_keys ]
then
    entrypoint_log "warning: authorized_keys file does not exist or is empty"
fi

entrypoint_log "enabling vcs user with a random password"
 PW="$(head -c 32 /dev/urandom | base64)"
 printf '%s\n%s\n' "$PW" "$PW" | passwd vcs >/dev/null 2>&1
 unset PW

entrypoint_log "creating symbolic links for vcs project roots"
for dir in /opt/nasvcs/vcs/*; do
    [ -d "$dir" ] || continue
    [ -L "/$(basename "$dir")" ] && continue
    if ln -s "$dir" "/$(basename "$dir")"
    then
        entrypoint_log "created symbolic link /$(basename "$dir") -> $dir"
    else
        entrypoint_log "error creating symbolic link /$(basename "$dir") -> $dir"
    fi
done

if [ ! -f /var/log/lighttpd/access.log ]
then
    entrypoint_log "initializing lighttpd log"
    touch /var/log/lighttpd/access.log && chown lighttpd:lighttpd /var/log/lighttpd/access.log
fi

exec "$@"
