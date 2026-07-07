#!/bin/sh
# check for changes to viewvc default configuration
# requires: docker-build.sh
DOCKER_RUN='docker run --rm --hostname nasvcs.test --entrypoint sh'
IMAGE='nasvcs:dev'
COMMAND='cat /opt/nasvcs/viewvc/viewvc.conf.dist'
SNAPSHOT='snapshot-viewvc-defaults.txt'

[ -f "$SNAPSHOT" ] || touch "$SNAPSHOT"

if ! $DOCKER_RUN "$IMAGE" -c "$COMMAND" | colordiff -u "$SNAPSHOT" -
then
	echo "snapshot using: $DOCKER_RUN $IMAGE -c '$COMMAND' >$SNAPSHOT"
	echo "$DOCKER_RUN $IMAGE -c '$COMMAND' >$SNAPSHOT" | pbcopy
    exit 1
fi
