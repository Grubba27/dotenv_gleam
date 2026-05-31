import dotenv_gleam
import envoy
import gleeunit
import gleeunit/should
import simplifile

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
  let _ = dotenv_gleam.config()
  check()
}

pub fn should_set_env_from_file_selected_test() {
  let _ = dotenv_gleam.config_with(".env.test")
  check()
}

pub fn should_return_error_when_file_not_found_test() {
  let assert Error(_) = dotenv_gleam.config_with(".env.notfound")
}

pub fn should_preserve_existing_env_test() {
  let key = "DOTENV_GLEAM_PRESERVE_TEST"
  let path = "build/preserve.env"
  envoy.set(key, "from-env")
  let assert Ok(Nil) =
    simplifile.write(to: path, contents: key <> "='from-file'\n")

  let assert Ok(Nil) = dotenv_gleam.config_with_preserving_env(path)

  should.equal(envoy.get(key), Ok("from-env"))
  envoy.unset(key)
}

pub fn should_strip_quotes_test() {
  let key = "DOTENV_GLEAM_QUOTES_TEST"
  let path = "build/quotes.env"
  envoy.unset(key)
  let assert Ok(Nil) =
    simplifile.write(to: path, contents: key <> "=\"from-file\"\n")

  let assert Ok(Nil) = dotenv_gleam.config_with(path)

  should.equal(envoy.get(key), Ok("from-file"))
  envoy.unset(key)
}
