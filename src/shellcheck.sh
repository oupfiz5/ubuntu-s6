#!/bin/bash
set -e

targets=()
while IFS=  read -r -d $'\0'; do
    targets+=("$REPLY")
done < <(
  find \
    rootfs/etc \
    hook \
    ./*.sh \
    -type f \
    -print0
  )


# shell_check.sh \
# dockerfilecheck.sh \

LC_ALL=C.UTF-8 shellcheck "${targets[@]}"

exit $?
