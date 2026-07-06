#!/bin/sh
# requires: updated snapshot-apk.txt
# build Dockerfile version header

grep -E '^cvs |^git |^lighttpd |^openssh |^runit ' snapshot-apk.txt | xargs | sed 's/^/# /' | pbcopy
