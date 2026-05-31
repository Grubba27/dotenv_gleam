import envoy
import gleam/list
import gleam/result
import gleam/string
import simplifile

/// An error that can occur when loading environment variables from a `.env` file.
pub type DotEnvError {
  ErrorReadingEnvFile(simplifile.FileError)
}

/// Tries to load environment variables from a `.env` file in the current
/// working directory.
/// this function returns a result with the error if it's not possible to read
/// the file.
///
/// ## Examples
///
/// ```gleam
/// > let assert Ok(Nil) = config()
/// > envoy.get("TEST")
/// Ok("test")
/// ```
///
/// ```gleam
/// > use _ <- result.try(config())
/// > envoy.get("TEST")
/// Ok("test")
/// ```
pub fn config() {
  config_with(".env")
}

/// Tries to load environment variables from a file specified in the current
/// working directory.
/// this function returns a result with the error if it's not possible to read
/// the file.
///
/// ## Examples
///
/// ```gleam
/// > let assert Ok(Nil) = config_with("path/to/.env")
/// > envoy.get("TEST")
/// Ok("test")
/// ```
///
/// ```gleam
/// > use _ <- result.try(config_with("path/to/.env"))
/// > envoy.get("TEST")
/// Ok("test")
/// ```
pub fn config_with(file: String) -> Result(Nil, DotEnvError) {
  load(file:, override_existing: True)
}

/// Tries to load environment variables from a `.env` file in the current
/// working directory, without replacing variables that are already set.
///
/// This is useful when `.env` files provide local development defaults but the
/// host environment should remain authoritative.
pub fn config_preserving_env() {
  config_with_preserving_env(".env")
}

/// Tries to load environment variables from a file specified in the current
/// working directory, without replacing variables that are already set.
///
/// This is useful when `.env` files provide local development defaults but the
/// host environment should remain authoritative.
pub fn config_with_preserving_env(file: String) -> Result(Nil, DotEnvError) {
  load(file:, override_existing: False)
}

fn load(file file: String, override_existing override_existing: Bool) {
  use env_file <- result.map(
    simplifile.read(file)
    |> result.map_error(ErrorReadingEnvFile),
  )

  string.split(env_file, "\n")
  |> list.map(string.trim)
  |> list.filter(fn(line) { line != "" && !string.starts_with(line, "#") })
  |> list.each(fn(line) {
    // sometimes can be more than one = in the line
    let splited_line = string.split(line, "=")
    let key =
      list.first(splited_line)
      |> result.unwrap("")
      |> string.trim()

    // so for those cases we need to join the rest of the line
    // and split again
    let value =
      list.drop(splited_line, 1)
      |> string.join("=")
      |> string.trim()
      |> strip_quotes

    set_env(key:, value:, override_existing:)
  })
}

fn set_env(
  key key: String,
  value value: String,
  override_existing override: Bool,
) {
  case override, envoy.get(key) {
    True, _ -> envoy.set(key, value)
    False, Error(Nil) -> envoy.set(key, value)
    False, Ok(_) -> Nil
  }
}

fn strip_quotes(value: String) -> String {
  let is_single_quoted =
    string.starts_with(value, "'") && string.ends_with(value, "'")
  let is_double_quoted =
    string.starts_with(value, "\"") && string.ends_with(value, "\"")

  case is_single_quoted || is_double_quoted {
    True -> string.drop_end(string.drop_start(value, 1), 1)
    False -> value
  }
}
