#!/bin/sh
set -e

entrypoint_log() {
    echo "$(date -Iseconds) nasvcs: $*"
}

entrypoint_log "version ${NASVCS_VERSION:-unknown} starting"

exec "$@"
