#!.bats-battery/bats-core/bin/bats
load './helpers.bash'

setup() {
      IMAGE="${IMAGE:?Var IMAGE is null or unset. Exit.}"
      VERSION=$(
      curl --silent "https://api.github.com/repos/goodwithtech/dockle/releases/latest" | \
          grep '"tag_name":' | \
          sed -E 's/.*"v([^"]+)".*/\1/' \
      )
  }

@test "Check docker image" {
    run docker run --rm \
        -v /var/run/docker.sock:/var/run/docker.sock \
        -v "$(pwd)"/.dockleignore:/.dockleignore \
        goodwithtech/dockle:v"${VERSION}" \
        --exit-code 1 \
        --exit-level fatal \
        "${IMAGE}"
    assert_success
  }
