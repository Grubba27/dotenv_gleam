import gleeunit
import gleeunit/should
import gleam/erlang/os
import dotenv_gleam

pub fn main() {
  gleeunit.main()
}

fn check() {
  let assert Ok(test_) = os.get_env("TEST")
  let assert Ok(bar) = os.get_env("BAR")
  let assert Ok(ops) = os.get_env("OPS")
  let assert Ok(k) = os.get_env("K")
  let assert Ok(uri) = os.get_env("SOME_HARDURI")

  should.equal(test_, "FOO")
  should.equal(bar, "BAR")
  should.equal(ops, "ops")
  should.equal(k, "9")
  should.equal(uri, "db://root:passw@url.nett.dasd.kk/?retryWrites=true&w=majority")
}

// gleeunit test functions end in `_test`
pub fn should_set_env_from_file_test() {
  dotenv_gleam.config()
  check()
}

pub fn should_set_env_from_file_selected_test() {
  dotenv_gleam.config_with(".env.test")
  check()
}
