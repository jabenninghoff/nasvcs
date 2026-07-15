#!/bin/sh
# run all interactive tests
# requires: docker-build.sh, docker compose
./sshd-login.sh && \
./web-access.sh && \
echo "" && echo "all tests passed!"
