import gleam/dynamic as d
import gleam/result

pub type DecodeError {
  InvalidTomlError(String)
  UnexpectedFormat(List(d.DecodeError))
}

/// Parse a toml file. This function returns `DecodeError` when there is an
/// error.
/// Note: timestamps are not supported.
pub fn decode(
  from toml_string: String,
  using decoder: d.Decoder(t),
) -> Result(t, DecodeError) {
  decode_inner(toml_string, decoder)
}

if erlang {
  external type ElxInvalidTomlError

  external fn decode_ex(
    toml_string: String,
  ) -> Result(d.Dynamic, ElxInvalidTomlError) =
    "Elixir.Toml" "decode"

  external fn get_reason(err: ElxInvalidTomlError) -> String =
    "Elixir.TomlFFI" "get_reason"

  pub fn decode_inner(
    toml_string: String,
    decoder: d.Decoder(t),
  ) -> Result(t, DecodeError) {
    case decode_ex(toml_string) {
      Ok(value) ->
        decoder(value)
        |> result.map_error(UnexpectedFormat)
      Error(err) -> Error(InvalidTomlError(get_reason(err)))
    }
  }
}

if javascript {
  external fn decode_js(toml_string: String) -> Result(d.Dynamic, String) =
    "./toml.mjs" "parse_toml"

  pub fn decode_inner(
    toml_string: String,
    decoder: d.Decoder(t),
  ) -> Result(t, DecodeError) {
    case decode_erl(toml_string) {
      Ok(value) ->
        decoder(value)
        |> result.map_error(UnexpectedFormat)
      Error(err) -> Error(InvalidTomlError(err))
    }
  }
}
