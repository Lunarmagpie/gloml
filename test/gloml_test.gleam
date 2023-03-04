import gleam/dynamic as d
import gleeunit
import gleeunit/should
import gloml

pub fn main() {
  gleeunit.main()
}

pub fn decode_works_test() {
  gloml.decode(
    "
[my-project]
version = \"1.2.3\"
",
    d.field("my-project", d.field("version", d.string)),
  )
  |> should.equal(Ok("1.2.3"))
}
