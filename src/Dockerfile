# * Base image
ARG UBUNTU_VERSION=20.04
FROM ubuntu:${UBUNTU_VERSION}

# * Arguments
ARG S6_OVERLAY_VERSION=2.2.0.3 \
    BUILD_DATE \
    UBUNTU_VERSION

# * Labels
LABEL \
    maintainer="Oupfiz V <oupfiz5@yandex.ru>" \
    org.opencontainers.image.created="${BUILD_DATE}" \
    org.opencontainers.image.authors="Oupfiz V (Five)" \
    org.opencontainers.image.url="https://chiselapp.com/user/oupfiz5/repository/ubuntu-s6/home" \
    org.opencontainers.image.documentation="https://chiselapp.com/user/oupfiz5/repository/ubuntu-s6/wiki" \
    org.opencontainers.image.source="https://chiselapp.com/user/oupfiz5/repository/ubuntu-s6/brlist" \
    org.opencontainers.image.version="0.0.3d" \
    org.opencontainers.image.revision="" \
    org.opencontainers.image.vendor="" \
    org.opencontainers.image.licenses="" \
    org.opencontainers.image.ref.name="" \
    org.opencontainers.image.title="Ubuntu image with s6 init system" \
    org.opencontainers.image.description="Ubuntu base docker image using s6-overlay" \
    org.opencontainers.ubuntu.version="${UBUNTU_VERSION}" \
    org.opencontainers.s6overlay.version="${S6_OVERLAY_VERSION}"

# * Environment

# * Copy
COPY rootfs/ /

# * Add
ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-amd64.tar.gz /tmp/s6-overlay.tar.gz

# * Run
# hadolint ignore=DL3003,DL3008
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y tzdata --no-install-recommends && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    cd /tmp && \
    tar xzf /tmp/s6-overlay.tar.gz -C / --exclude='./bin' && \
    tar xzf /tmp/s6-overlay.tar.gz -C /usr ./bin && \
    rm /tmp/s6-overlay.tar.gz

# * Entrypoint
ENTRYPOINT ["/init"]
