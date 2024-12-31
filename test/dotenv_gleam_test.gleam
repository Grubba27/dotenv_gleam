import dotenv_gleam
import envoy
import gleeunit
import gleeunit/should

pub fn main() {
  gleeunit.main()
}

fn check() {
  let assert Ok(test_) = envoy.get("TEST")
  let assert Ok(bar) = envoy.get("BAR")
  let assert Ok(ops) = envoy.get("OPS")
  let assert Ok(k) = envoy.get("K")
  let assert Ok(uri) = envoy.get("SOME_HARDURI")

  should.equal(test_, "FOO")
  should.equal(bar, "BAR")
  should.equal(ops, "ops")
  should.equal(k, "9")
  should.equal(
    uri,
    "db://root:passw@url.nett.dasd.kk/?retryWrites=true&w=majority",
  )
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
