# gloml

[![Package Version](https://img.shields.io/hexpm/v/gloml)](https://hex.pm/packages/gloml)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/gloml/)

A toml 0.4.0 decoder for gleam. If you are using javascript, you must install the `fast-toml` module.

```gleam
import gleam/io

pub fn main() {
  decode(
    "
[my-project]
version = \"1.2.3\"
",
    d.field("my-project", d.field("version", d.string)),
  )
  |> io.println()
}
```



## Quick start

```sh
gleam run   # Run the project
gleam test  # Run the tests
gleam shell # Run an Erlang shell
```

## Installation

If available on Hex this package can be added to your Gleam project:

```sh
gleam add gloml
```

and its documentation can be found at <https://hexdocs.pm/gloml>.
