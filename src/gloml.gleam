import gleam/dynamic as d
import gleam/result

pub type DecodeError {
  UnexpectedFormat(List(d.DecodeError))
}

/// Parse a toml file. This function returns `DecodeError` when there is an
/// error.
/// Note: timestamps are not supported.
pub fn decode(
  from toml_string: String,
  using decoder: d.Decoder(t),
) -> Result(t, DecodeError) {
  use dynamic_value <- result.then(decode_inner(toml_string))
  decoder(dynamic_value)
  |> result.map_error(UnexpectedFormat)
}

if erlang {
  external fn decode_inner(
    toml_string: String,
  ) -> Result(d.Dynamic, DecodeError) =
    "Elixir.Toml" "decode"
}

if javascript {
  external fn decode_inner(
    toml_string: String,
  ) -> Result(d.Dynamic, DecodeError) =
    "./toml.mjs" "parse_toml"
}
