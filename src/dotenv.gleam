import gleam/io
import gleam/string
import gleam/list
import gleam/erlang/file
import gleam/erlang/os

/// Tries to load environment variables from a `.env` file in the current
/// working directory.
/// this function calls for assert to make sure that the file is read.
/// if for some reason the file is not there will crash the program.
///
/// ## Examples
///
/// ```gleam
/// > config()
/// > os.get_env("TEST")
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
/// > os.get_env("TEST")
/// "test"
/// ```
pub fn config_with(file: String) {
  let assert Ok(env_file) = file.read(file)
  string.split(env_file, "\n")
  |> list.filter(fn(line) { line != "" })
  |> list.each(fn(line) {
    case string.split(line, "=") {
      [key, value] -> {
        let key = string.trim(key)
        let value = string.trim(value)
        os.set_env(key, value)
      }
      _ -> {
        io.println("Invalid line in .env file:")
        io.println(line)
      }
    }
  })
}
