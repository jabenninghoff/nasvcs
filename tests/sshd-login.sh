#!/bin/sh
# interactive: check nasvcs SSH access
# requires: docker compose, valid ./user/authorized_keys

fail() {
    printf "\nSSH tests \e[31mFAILED\e[0m\n\n"
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

printf "SSH tests \e[32msuccessful\e[0m!\n\n"
docker compose down -v
