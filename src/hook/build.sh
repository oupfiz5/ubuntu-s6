#!/bin/bash
# shellcheck disable=SC1091
set -a; source ../VERSIONS ; set +a;

IMAGE="${IMAGE:-${IMAGE_REPOSITORY}/${IMAGE_NAME}:${IMAGE_TAG}}"
DOCKERFILE="${DOCKERFILE:-Dockerfile}"

docker buildx build \
       --build-arg BUILD_DATE="$(date -u +"%Y-%m-%dT%H:%M:%SZ")" \
       --build-arg S6_OVERLAY_VERSION="${S6_OVERLAY_VERSION}" \
       --build-arg UBUNTU_VERSION="${UBUNTU_VERSION}" \
       -t "${IMAGE}" \
       -f ../"${DOCKERFILE}" \
        ../.
