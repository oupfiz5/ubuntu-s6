#!/bin/bash
# shellcheck disable=SC1091
set -a; source ../VERSIONS ; set +a;

IMAGE="${IMAGE:-oupfiz5/ubuntu-s6:${UBUNTU_VERSION}-${S6_OVERLAY_IMAGE_TAG}}"
docker push "${IMAGE}"
