#!/bin/bash
# shellcheck disable=SC1091
set -a; source ../VERSION ; set +a;

# CIS-DI-0005: Enable Content trust for Docker
# export DOCKER_CONTENT_TRUST=1

docker push oupfiz5/ubuntu-s6:"${UBUNTU_VERSION}-{S6_OVERLAY_VERSION}"
#docker push oupfiz5/ubuntu-s6:latest
