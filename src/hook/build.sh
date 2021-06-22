#!/bin/bash
# shellcheck disable=SC1091
set -a; source ../VERSION ; set +a;

# CIS-DI-0005: Enable Content trust for Docker
export DOCKER_CONTENT_TRUST=1

docker build \
       --build-arg BUILD_DATE="$(date -u +"%Y-%m-%dT%H:%M:%SZ")" \
       --build-arg S6_OVERLAY_VERSION="${S6_OVERLAY_VERSION}" \
       --build-arg UBUNTU_VERSION="${UBUNTU_VERSION}" \
       -t oupfiz5/ubuntu-s6:"${UBUNTU_VERSION}" \
       -t oupfiz5/ubuntu-s6:latest \
       -f ../Dockerfile \
        ../.
