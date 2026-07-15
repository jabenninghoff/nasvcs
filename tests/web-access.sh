#!/bin/sh
# interactive: check nasvcs web access
# requires: docker compose, valid /opt/nasvcs/user/lighttpd.user, hurl

# TODO: color success/failure messages
fail() {
    printf "Web tests FAILED\n\n"
    docker compose down -v
    exit 1
}

hurl_test() {
    hurl --test "$@" || fail
}

docker compose up -d && sleep 0.1
printf "\n"

printf "Web: testing GitWeb access\n\n"
hurl_test gitweb-unauth.hurl
hurl_test --user vcs:vcstest gitweb-auth.hurl
hurl_test --user vcs:badpass gitweb-unauth.hurl

printf "Web: testing ViewVC access\n\n"
hurl_test viewvc-unauth.hurl
hurl_test --user vcs:vcstest viewvc-auth.hurl
hurl_test --user vcs:badpass viewvc-unauth.hurl

printf "Web tests successful!\n\n"
docker compose down -v
