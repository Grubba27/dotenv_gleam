import envoy
import gleam/list
import gleam/result
import gleam/string
import simplifile

/// Tries to load environment variables from a `.env` file in the current
/// working directory.
/// this function calls for assert to make sure that the file is read.
/// if for some reason the file is not there will crash the program.
///
/// ## Examples
///
/// ```gleam
/// > config()
/// > envoy.get("TEST")
/// "test"
/// ```
pub fn config() {
  config_with(".env")
}

/// Tries to load environment variables from a file specified in the current
/// working directory.
/// this function calls for assert to make sure that the file is read.
/// if for some reason the file is not there will crash the program.
///
/// ## Examples
///
/// ```gleam
/// > config_with("path/to/.env")
/// > envoy.get("TEST")
/// "test"
/// ```
pub fn config_with(file: String) {
  let assert Ok(env_file) = simplifile.read(file)
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
