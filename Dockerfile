FROM alpine:3.24.1@sha256:28bd5fe8b56d1bd048e5babf5b10710ebe0bae67db86916198a6eec434943f8b

RUN apk upgrade --no-cache

ARG NASVCS_VERSION
ENV NASVCS_VERSION="${NASVCS_VERSION}"
COPY rootfs/ /

ENTRYPOINT [ "/opt/nasvcs/sbin/docker-entrypoint.sh" ]
CMD [ "sleep", "inf" ]
