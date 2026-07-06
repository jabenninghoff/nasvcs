FROM alpine:3.24.1@sha256:28bd5fe8b56d1bd048e5babf5b10710ebe0bae67db86916198a6eec434943f8b

# cvs 1.12.13-r3 git 2.54.0-r0 lighttpd 1.4.82-r1 moreutils 0.70-r1 openssh 10.3_p1-r0 runit 2.3.1-r0
# major updates are features, other updates are fixes
RUN apk upgrade --no-cache && apk add --no-cache cvs git lighttpd moreutils openssh runit

ARG NASVCS_VERSION
ENV NASVCS_VERSION="${NASVCS_VERSION}"
COPY rootfs/ /

RUN mkdir -p /opt/nasvcs/vcs && \
    addgroup --gid 5000 vcs && \
    adduser --ingroup vcs --uid 5000 --disabled-password vcs && \
    chown vcs:vcs /opt/nasvcs/vcs

EXPOSE 22
VOLUME [ "/opt/nasvcs/vcs", "/opt/nasvcs/etc/ssh" ]

ENTRYPOINT [ "/opt/nasvcs/sbin/docker-entrypoint.sh" ]
CMD [ "runsvdir", "-P", "/opt/nasvcs/runit" ]
