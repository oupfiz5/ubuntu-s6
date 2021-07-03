#!.bats-battery/bats-core/bin/bats
load './helpers.bash'

setup() {
    export CONTAINER_NAME="${CONTAINER_NAME:-ubuntu-s6}"
}

@test "Verify state status container - running" {
      sleep 5
      run docker inspect --format 'result={{ .State.Status }}' "${CONTAINER_NAME}"
      assert_success
      assert_output 'result=running'
}

@test "Verify state running container - true" {
      run docker inspect --format 'result={{ .State.Running }}' "${CONTAINER_NAME}"
      assert_success
      assert_output 'result=true'
}

@test "Verify state restarting container - false" {
      run docker inspect --format 'result={{ .State.Restarting }}' "${CONTAINER_NAME}"
      assert_success
      assert_output 'result=false'
}

@test "Verify state error container - <empty>" {
      run docker inspect --format 'result={{ .State.Error }}' "${CONTAINER_NAME}"
      assert_success
      assert_output 'result='
}

@test "Verify restart count container - 0" {
      run docker inspect --format 'result={{ .RestartCount }}' "${CONTAINER_NAME}"
      assert_success
      assert_output 'result=0'
}

@test "Verify AppArmor Profile - if applicable" {
      skip
      run docker inspect --format 'AppArmorProfile={{ .AppArmorProfile }}' "${CONTAINER_NAME}"
      assert_success
      refute_output "AppArmorProfile=[]"
      refute_output "AppArmorProfile="
      refute_output "AppArmorProfile=<no value>"
}

@test "Verify container stop" {
      run docker container stop "${CONTAINER_NAME}"
      assert_success
}
