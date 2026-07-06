#!/bin/sh
# run all image tests
# requires: docker-build.sh
./apk-list.sh && \
./sshd-defaults.sh && \
./startup.sh && \
./docker-header.sh && \
./apk-upgrade.sh && \
echo "" && echo "all tests passed!"
