#!.bats-battery/bats-core/bin/bats
load './helpers.bash'

setup() {
    export CONTAINER_NAME="ubuntu-s6"
}

@test "Verify state status container ${CONTAINER_NAME} (running)" {
      run docker inspect --format 'result={{ .State.Status }}' "${CONTAINER_NAME}"
      assert_success
      assert_output 'result=running'
}

@test "Verify state running container ${CONTAINER_NAME} (true)" {
      run docker inspect --format 'result={{ .State.Running }}' "${CONTAINER_NAME}"
      assert_success
      assert_output 'result=true'
}

@test "Verify state restarting container ${CONTAINER_NAME} (false)" {
      run docker inspect --format 'result={{ .State.Restarting }}' "${CONTAINER_NAME}"
      assert_success
      assert_output 'result=false'
}

@test "Verify state error container ${CONTAINER_NAME} ("")" {
      run docker inspect --format 'result={{ .State.Error }}' "${CONTAINER_NAME}"
      assert_success
      assert_output 'result='
}

@test "Verify restart count container ${CONTAINER_NAME} (0)" {
      run docker inspect --format 'result={{ .RestartCount }}' "${CONTAINER_NAME}"
      assert_success
      assert_output 'result=0'
}

@test "Verify AppArmor Profile, if applicable: ${CONTAINER_NAME}" {
      skip
      run docker inspect --format 'AppArmorProfile={{ .AppArmorProfile }}' "${CONTAINER_NAME}"
      assert_success
      refute_output "AppArmorProfile=[]"
      refute_output "AppArmorProfile="
      refute_output "AppArmorProfile=<no value>"
}
