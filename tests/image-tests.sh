#!/bin/sh
# run all image tests
# requires: docker-build.sh
./apk-list.sh && \
./sshd-defaults.sh && \
./lighttpd-defaults.sh && \
./viewvc-defaults.sh && \
./startup.sh && \
./docker-header.sh && \
./apk-upgrade.sh && \
printf "\nall tests \e[32mpassed\e[0m!\n"
