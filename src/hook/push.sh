#!/bin/bash
set -a; source ../VERSION ; set +a;

docker push oupfiz5/ubuntu-s6:"${UBUNTU_VERSION}"
docker push oupfiz5/ubuntu-s6:latest
