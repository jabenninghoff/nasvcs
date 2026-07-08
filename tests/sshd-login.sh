#!/bin/sh
# interactive: check nasvcs SSH access
# requires: docker compose, valid ./user/authorized_keys

# TODO: color success/failure messages
fail() {
    printf "\nSSH tests FAILED\n\n"
    docker compose down -v
    exit 1
}

ssh_login() {
    URI=$1
    result=$2
    printf "trying SSH %s (%s): " "$URI" "$result"
    if ssh -t "$URI" ls /opt
    then
        [ "$result" = "expect_succeed" ] || fail
    else
        [ "$result" = "expect_fail" ] || fail
    fi
}

docker compose up -d && sleep 0.1
printf "\n"

printf "SSH: testing ls /opt (returns nasvcs on success)\n"
ssh_login random@nasvcs.test   expect_fail
ssh_login root@nasvcs.test     expect_fail
ssh_login lighttpd@nasvcs.test expect_fail
ssh_login vcs@nasvcs.test      expect_succeed
printf "\n"

printf "SSH tests successful!\n\n"
docker compose down -v
