#!.bats-battery/bats-core/bin/bats
load './helpers.bash'
setup() {
   DOCKERFILE="${DOCKERFILE:-Dockerfile}"
}

@test "Check Dockerfile" {
      run docker run --rm -i -v "${PWD}/../src":/work --workdir=/work  hadolint/hadolint hadolint -f json "${DOCKERFILE}"
      assert_success
}
