import * as TOML from "../priv/node_modules/toml/index.mjs";

import {
    Error,
    Ok,
} from "./gleam.mjs";

export function parse_toml(string) {
    try {
        return new Ok(TOML.default.parse(string));
    } catch (e) {
        return new Error(e.message)
    }
}
