#!/bin/bash
# shellcheck disable=SC1091
set -a; source ../VERSION ; set +a;

docker push oupfiz5/ubuntu-s6:"${UBUNTU_VERSION}"
docker push oupfiz5/ubuntu-s6:latest
