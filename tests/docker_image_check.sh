#!/bin/bash
set -e
IMAGE_NAME="${1:-oupfiz5/ubuntu-s6:latest}"

# * Install dockle and check targets
# Pay attention: some checks are ignored using .dockleignore
VERSION=$(
    curl --silent "https://api.github.com/repos/goodwithtech/dockle/releases/latest" | \
        grep '"tag_name":' | \
        sed -E 's/.*"v([^"]+)".*/\1/' \
       ) && docker run --rm \
                       -v /var/run/docker.sock:/var/run/docker.sock \
                       -v "$(pwd)"/.dockleignore:/.dockleignore \
                       goodwithtech/dockle:v"${VERSION}" \
                       --exit-code 1 \
                       --exit-level fatal \
                       "${IMAGE_NAME}"
exit $?
