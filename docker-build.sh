#!/bin/sh
# local build wrapper
set -e

docker build --build-arg NASVCS_VERSION="$(cat version.txt | tr -d '[:space:]')" -t nasvcs:dev "$@" .
