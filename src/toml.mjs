import * as TOML from 'toml'

import {
    Error,
    Ok,
} from "./gleam.mjs";

export function parse_toml(string) {
    console.log("here")
    try {
        return new Ok(TOML.default.parse(string));
    } catch (e) {
        console.log(e)
        return new Error(e.message)
    }
}
