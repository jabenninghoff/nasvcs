#!/bin/sh
# check nasvcs startup and version output
# requires: docker-build.sh

docker run --rm --hostname nasvcs.test nasvcs:dev sh
