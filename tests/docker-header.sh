#!/bin/sh
# requires: updated snapshot-apk.txt
# build Dockerfile version header

command -v pbcopy >/dev/null 2>&1 || exit 0

grep -E '^cvs |^git |^lighttpd |^openssh |^runit ' snapshot-apk.txt | xargs | sed 's/^/# /' | pbcopy
