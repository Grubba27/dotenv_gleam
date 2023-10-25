# gleam_dotenv

[![Package Version](https://img.shields.io/hexpm/v/dotenv)](https://hex.pm/packages/dotenv)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/dotenv/)

Similar to [Node](https://www.npmjs.com/package/dotenv) dotenv and [Ruby](https://github.com/bkeepers/dotenv) dotenv


## Installation

If available on Hex this package can be added to your Gleam project:

```sh
gleam add dotenv
```

then in your code:

```gleam

import dotenv
import gleam/erlang/os // do not forget to add gleam_erlang to the project

pub fn main() {
  dotenv.config() // this should load .env file

  let assert Ok(test) = os.get_env("TEST")
  let assert Ok(bar) = os.get_env("BAR")

}

// or you can specify the path to the .env file

pub fn main() {
  dotenv.config_with("path/to/.env") // this should load .env file

  let assert Ok(test) = os.get_env("TEST")
  let assert Ok(bar) = os.get_env("BAR")
}

```

and its documentation can be found at <https://hexdocs.pm/dotenv>.
