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

echo "Shellcheck main files"
LC_ALL=C.UTF-8 shellcheck "${targets[@]}"

# VERSION were exclude from main check (above)
# exclude warning https://github.com/koalaman/shellcheck/wiki/SC2034
echo "Shellcheck VERSION"
LC_ALL=C.UTF-8 shellcheck --shell=sh --exclude=SC2034 VERSION

exit $?
