module zero_art_budget::attributes;

use std::string::String;


public struct Attributes has key, store{
    id: UID,
    nft_number: u16,
    data: AttributesData
}

public struct AttributesData has store{
    background: String,
    eyes: String,
    face: String

}

public struct CreateAttributesCap has key, store{
    id: UID,
    nft_number: u16
}

#[allow(unused_variable)]
public fun new(
    cap: CreateAttributesCap,
    background: String,
    eyes: String,
    face: String,
    ctx: &mut TxContext) :Attributes{
        let attributes_data = AttributesData{
            background: background,
            eyes: eyes,
            face: face
        };

        let attributes = Attributes{
            id: object::new(ctx),
            nft_number: cap.nft_number,
            data: attributes_data
        };
        let CreateAttributesCap{id, nft_number} = cap;
        id.delete();
        (attributes)

}

public(package) fun create_attributes_cap(number: u16,ctx: &mut TxContext) :CreateAttributesCap{
    let cap = CreateAttributesCap{
        id: object::new(ctx),
        nft_number: number
    };
    (cap)
}