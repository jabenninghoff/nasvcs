FROM alpine:3.24.1@sha256:28bd5fe8b56d1bd048e5babf5b10710ebe0bae67db86916198a6eec434943f8b

# cvs 1.12.13-r3 git 2.54.0-r0 lighttpd 1.4.85-r0 openssh 10.3_p1-r0 runit 2.3.1-r0
# major updates are features, other updates are fixes
RUN apk upgrade --no-cache && \
    apk add --no-cache cvs git lighttpd openssh runit && \
    # openssh packages
    apk add --no-cache moreutils && \
    # gitweb packages
    apk add --no-cache git-gitweb perl-cgi && \
    # viewvc packages
    apk add --no-cache rcs python3 py3-pygments py3-chardet && \
    # lighttpd packages
    apk add --no-cache lighttpd-mod_auth apache2-utils

ARG NASVCS_VERSION
ENV NASVCS_VERSION="${NASVCS_VERSION}"

# save alpine default lighttpd configuration for snapshot testing
RUN cp -p /etc/lighttpd/lighttpd.conf /etc/lighttpd/lighttpd.conf.dist
COPY rootfs/ /

# download, install and configure viewvc
ARG VIEWVC_VERSION=1.3.0
ARG VIEWVC_SHA256="c2982b0ae822e210ca083f9738ea8e2e52fdc1fa1665baa2a10c06e874c5b68f"
RUN cd /tmp && \
    apk add --no-cache patch && \
    wget https://github.com/viewvc/viewvc/releases/download/${VIEWVC_VERSION}/viewvc-${VIEWVC_VERSION}.tar.gz && \
    echo "${VIEWVC_SHA256}  viewvc-${VIEWVC_VERSION}.tar.gz" | sha256sum -c - && \
    tar xzf viewvc-${VIEWVC_VERSION}.tar.gz && \
    cd viewvc-${VIEWVC_VERSION} && \
    # patch to always display file markup link per https://github.com/viewvc/viewvc/issues/407
    # patch for issue https://github.com/viewvc/viewvc/issues/408
    patch -p0 --batch --forward -i /opt/nasvcs/src/viewvc.patch && \
    ./viewvc-install --prefix=/opt/nasvcs/viewvc --destdir= && \
    # security: delete iis cgi directory
    rm -rf /opt/nasvcs/viewvc/bin/cgi/iis && \
    # configure cvs roots
    sed -i 's!^#root_parents =.*!root_parents = /opt/nasvcs/vcs : cvs!' /opt/nasvcs/viewvc/viewvc.conf && \
    # enable all views
    sed -i 's/^#allowed_views =.*/allowed_views = annotate, co, diff, image, markup, roots, tar/' /opt/nasvcs/viewvc/viewvc.conf && \
    # cleanup
    cd / && \
    rm -rf /tmp/viewvc-${VIEWVC_VERSION} /tmp/viewvc-${VIEWVC_VERSION}.tar.gz && \
    apk del patch

RUN mkdir -p /opt/nasvcs/vcs && \
    addgroup --gid 5000 vcs && \
    adduser --ingroup vcs --uid 5000 --disabled-password vcs && \
    chown vcs:vcs /opt/nasvcs/vcs

EXPOSE 22 80
VOLUME [ "/opt/nasvcs/etc/ssh", "/opt/nasvcs/user", "/opt/nasvcs/vcs" ]

ENTRYPOINT [ "/opt/nasvcs/sbin/docker-entrypoint.sh" ]
CMD [ "runsvdir", "-P", "/opt/nasvcs/runit" ]
