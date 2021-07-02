#!.bats-battery/bats-core/bin/bats
load './helpers.bash'
@test "Verify state status container ubuntu-s6 (running)" {
      run docker inspect --format 'result={{ .State.Status }}' "ubuntu-s6"
      assert_success
      assert_output 'result=running'
}

@test "Verify state running container ubuntu-s6 (true)" {
      run docker inspect --format 'result={{ .State.Running }}' "ubuntu-s6"
      assert_success
      assert_output 'result=true'
}

@test "Verify state restarting container ubuntu-s6 (false)" {
      run docker inspect --format 'result={{ .State.Restarting }}' "ubuntu-s6"
      assert_success
      assert_output 'result=false'
}

@test "Verify state error container ubuntu-s6 ("")" {
      run docker inspect --format 'result={{ .State.Error }}' "ubuntu-s6"
      assert_success
      assert_output 'result='
}

@test "Verify restart count container ubuntu-s6 (0)" {
      run docker inspect --format 'result={{ .RestartCount }}' "ubuntu-s6"
      assert_success
      assert_output 'result=0'
}

@test "Verify AppArmor Profile, if applicable: ubuntu-s6" {
      skip
      run docker inspect --format 'AppArmorProfile={{ .AppArmorProfile }}' "ubuntu-s6"
      assert_success
      refute_output "AppArmorProfile=[]"
      refute_output "AppArmorProfile="
      refute_output "AppArmorProfile=<no value>"
}
