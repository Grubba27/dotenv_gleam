import gleeunit
import gleeunit/should
import gleam/erlang/os
import dotenv

pub fn main() {
  gleeunit.main()
}

fn check() {
  let assert Ok(test) = os.get_env("TEST")
  let assert Ok(bar) = os.get_env("BAR")
  let assert Ok(ops) = os.get_env("OPS")
  let assert Ok(k) = os.get_env("K")

  should.equal(test, "FOO")
  should.equal(bar, "BAR")
  should.equal(ops, "ops")
  should.equal(k, "9")
}

// gleeunit test functions end in `_test`
pub fn should_set_env_from_file_test() {
  dotenv.config()
  check()
}

pub fn should_set_env_from_file_selected_test() {
  dotenv.config_with(".env.test")
  check()
}
