import gleam/dynamic as dyn
import gleam/result

pub type DecodeError {
  InvalidTomlError(String)
  UnexpectedFormat(List(dyn.DecodeError))
}

/// Parse a toml file with a decoder.
///
/// ```gleam
/// pub fn decode_toml() {
///   let version =
///     gloml.decode("
///   [my-project]
///   version = \"1.2.3\"
///   ",
///     d.field("my-project", d.field("version", d.string)),
///   )
///   should.equal(version, Ok("1.2.3"))
/// }
/// ```
///
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
///
/// ```gleam
/// pub fn decode_toml() {
///   let dynamic =
///     gloml.decode("
///   [my-project]
///   version = \"1.2.3\"
///   ")
/// }
/// ```
///
pub fn decode_dynamic(toml_string: String) {
  decode_inner(toml_string)
}

@target(erlang)
type ElxInvalidTomlError

@target(erlang)
@external(erlang, "Elixir.Toml", "decode")
fn decode_ex(toml_string: String) -> Result(dyn.Dynamic, ElxInvalidTomlError)

@target(erlang)
@external(erlang, "Elixir.TomlFFI", "get_reason")
fn get_reason(err: ElxInvalidTomlError) -> String

@target(erlang)
fn decode_inner(toml_string: String) -> Result(dyn.Dynamic, DecodeError) {
  case decode_ex(toml_string) {
    Ok(value) -> Ok(value)
    Error(err) -> Error(InvalidTomlError(get_reason(err)))
  }
}

@target(javascript)
@external(javascript, "./toml_ffi.mjs", "parse_toml")
fn decode_js(toml_string: String) -> Result(dyn.Dynamic, String)

@target(javascript)
fn decode_inner(toml_string: String) -> Result(dyn.Dynamic, DecodeError) {
  decode_js(toml_string)
  |> result.map_error(InvalidTomlError)
}
