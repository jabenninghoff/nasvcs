#!/bin/sh
# requires: updated snapshot-apk.txt
# build Dockerfile version header

if command -v pbcopy >/dev/null 2>&1
then
	grep -E '^cvs |^git |^lighttpd |^openssh |^runit ' snapshot-apk.txt | xargs | sed 's/^/# /' | pbcopy
fi
