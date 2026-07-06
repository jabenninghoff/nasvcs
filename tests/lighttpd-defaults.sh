#!/bin/sh
# check for changes to lighttpd default configuration
# requires: docker-build.sh
DOCKER_RUN='docker run --rm --hostname nasvcs.test --entrypoint sh'
IMAGE='nasvcs:dev'
COMMAND='cat /etc/lighttpd/lighttpd.conf.dist'
SNAPSHOT='snapshot-lighttpd-defaults.txt'

[ -f "$SNAPSHOT" ] || touch "$SNAPSHOT"

if ! $DOCKER_RUN "$IMAGE" -c "$COMMAND" | colordiff -u "$SNAPSHOT" -
then
	echo "snapshot using: $DOCKER_RUN $IMAGE -c '$COMMAND' >$SNAPSHOT"
	echo "$DOCKER_RUN $IMAGE -c '$COMMAND' >$SNAPSHOT" | pbcopy
    exit 1
fi
