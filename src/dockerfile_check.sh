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


# * Pull hadolint and check targets
docker run --rm -i hadolint/hadolint < "${targets[@]}"

exit $?
