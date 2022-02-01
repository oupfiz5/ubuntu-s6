#!/bin/bash
# shellcheck disable=SC1091
set -a; source ../VERSIONS ; set +a;

IMAGE="${IMAGE:-oupfiz5/ubuntu-s6:${UBUNTU_VERSION}-${S6_OVERLAY_IMAGE_TAG}}"

docker build \
       --build-arg BUILD_DATE="$(date -u +"%Y-%m-%dT%H:%M:%SZ")" \
       --build-arg S6_OVERLAY_VERSION="${S6_OVERLAY_VERSION}" \
       --build-arg UBUNTU_VERSION="${UBUNTU_VERSION}" \
       -t "${IMAGE}" \
       -f ../Dockerfile \
        ../.
