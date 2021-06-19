#!/bin/bash
set -e

# * Get list of targets
targets=()
while IFS=  read -r -d $'\0'; do
    targets+=("$REPLY")
done < <(
  find \
     Dockerfile \
    -type f \
    -print0
  )


# * Install dockle and check targets
VERSION=$(
    curl --silent "https://api.github.com/repos/goodwithtech/dockle/releases/latest" | \
        grep '"tag_name":' | \
        sed -E 's/.*"v([^"]+)".*/\1/' \
       ) && docker run --rm -v /var/run/docker.sock:/var/run/docker.sock \
                   goodwithtech/dockle:v"${VERSION}" "${targets[@]}"

exit $?
