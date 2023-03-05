import gleam/dynamic as dyn
import gleam/result

pub type DecodeError {
  InvalidTomlError(String)
  UnexpectedFormat(List(dyn.DecodeError))
}

/// Parse a toml file with a decoder.
pub fn decode(
  from toml_string: String,
  using decoder: dyn.Decoder(t),
) -> Result(t, DecodeError) {
  use dyn <- result.then(decode_inner(toml_string))
  dyn
  |> decoder
  |> result.map_error(UnexpectedFormat)
}

/// Parse a toml file into a `gleam/dynamic.Dynamic`.
pub fn decode_dynamic(toml_string: String) {
  decode_inner(toml_string)
}

if erlang {
  external type ElxInvalidTomlError

  external fn decode_ex(
    toml_string: String,
  ) -> Result(dyn.Dynamic, ElxInvalidTomlError) =
    "Elixir.Toml" "decode"

  external fn get_reason(err: ElxInvalidTomlError) -> String =
    "Elixir.TomlFFI" "get_reason"

  fn decode_inner(toml_string: String) -> Result(dyn.Dynamic, DecodeError) {
    case decode_ex(toml_string) {
      Ok(value) -> Ok(value)
      Error(err) -> Error(InvalidTomlError(get_reason(err)))
    }
  }
}

if javascript {
  external fn decode_js(toml_string: String) -> Result(dyn.Dynamic, String) =
    "./toml_ffi.mjs" "parse_toml"

  fn decode_inner(toml_string: String) -> Result(dyn.Dynamic, DecodeError) {
    decode_js(toml_string)
    |> result.map_error(InvalidTomlError)
  }
}
