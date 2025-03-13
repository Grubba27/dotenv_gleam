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
  use env_file <- result.map(
    simplifile.read(file)
    |> result.map_error(ErrorReadingEnvFile),
  )

  string.split(env_file, "\n")
  |> list.filter(fn(line) { line != "" })
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

    envoy.set(key, value)
  })
}
