#!/bin/sh
# run all interactive tests
# requires: docker-build.sh, docker compose
./sshd-login.sh && \
./web-access.sh && \
printf "\nall tests \e[32mpassed\e[0m!\n"
