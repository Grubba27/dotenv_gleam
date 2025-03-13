# dotenv_gleam

[![Package Version](https://img.shields.io/hexpm/v/dotenv)](https://hex.pm/packages/dotenv_gleam)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/dotenv_gleam/)

Similar to [Node](https://www.npmjs.com/package/dotenv) dotenv and [Ruby](https://github.com/bkeepers/dotenv) dotenv


## Installation

If available on Hex this package can be added to your Gleam project:

```sh
gleam add dotenv_gleam
```

then in your code:

```gleam

import dotenv_gleam
import envoy // do not forget to add envoy to the project

pub fn main() {
  let assert Ok(Nil) = dotenv_gleam.config() // this should load .env file or return an error if it does not exist

  let assert Ok(test) = envoy.get("TEST")
  let assert Ok(bar) = envoy.get("BAR")
}

// or you can specify the path to the .env file

pub fn main() {
  let assert Ok(Nil) = dotenv_gleam.config_with("path/to/.env") // this should load .env file or return an error if it does not exist

  let assert Ok(test) = envoy.get("TEST")
  let assert Ok(bar) = envoy.get("BAR")
}

```

and its documentation can be found at <https://hexdocs.pm/dotenv_gleam>.
