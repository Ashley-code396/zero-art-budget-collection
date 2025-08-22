module zero_art_budget::attributes;

use std::string::String;

public struct Attributes has copy, drop, store {
    background: String,
    eyes: String,
    face: String,
}

#[allow(unused_variable)]
public fun new(background: String, eyes: String, face: String, ctx: &mut TxContext): Attributes {
    let attributes = Attributes {
        background: background,
        eyes: eyes,
        face: face,
    };
    (attributes)
}
