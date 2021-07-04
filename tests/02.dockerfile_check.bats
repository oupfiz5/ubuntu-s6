#!.bats-battery/bats-core/bin/bats
load './helpers.bash'

@test "Check Dockerfile" {
      run docker run --rm -i hadolint/hadolint < ../src/Dockerfile
      assert_success
}
