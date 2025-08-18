module zero_art_budget::mint;

use sui::table_vec::{Self, TableVec};
use sui::package;
use zero_art_budget::zero_art_budget::{Self,Registry,ZeroArtBudget};
use sui::display;
use zero_art_budget::admin::{Self,AdminCap};


const EInventoryAlreadyInitialised: u64 = 0;

const SUPERADMIN: address = @0x17c9ba64e43dbb64c57c33bf10f9b3807f8bfcf29990d477cbb54d18a19de81e;



public struct Inventory has key, store{
    id: UID,
    pfps: TableVec<ZeroArtBudget>,
    is_initialised: bool,
    public_mint_price: u64,
    whitelist_mint_price: u64

    
}


public struct WhitelistTicket has key, store{
    id: UID
}

public struct MINT has drop{}

#[allow(unused_variable)]
fun init(otw: MINT, ctx: &mut TxContext){

    let publisher = package::claim(otw, ctx);
    let  mut whitelist_ticket_display = display::new<WhitelistTicket>(&publisher, ctx);
    whitelist_ticket_display.add(b"name".to_string(), b"A zero art budget whitelist".to_string());
    whitelist_ticket_display.add(b"description".to_string(), b"A zero art budget whitelist for zero art budget collection".to_string());
    whitelist_ticket_display.add(b"image_url".to_string(), b"https://i.ibb.co/PJQKhbW/photo-1601684632403-4ce4a06d8429.jpg".to_string());
    whitelist_ticket_display.update_version();
    




    let  inventory = Inventory {
        id: object::new(ctx),
        pfps: table_vec::empty<ZeroArtBudget>(ctx),
        is_initialised: false,
        public_mint_price: 2000000000,
        whitelist_mint_price: 1000000000
    };

    transfer::public_share_object(inventory);
    transfer::public_transfer(whitelist_ticket_display, SUPERADMIN);
    transfer::public_transfer(publisher, SUPERADMIN);

    
}


public fun add_pfp_to_inventory(
    admin: &AdminCap,
    registry: &mut Registry,
    inventory: &mut Inventory,
    ctx: &mut TxContext
) {
    admin.verify_admin(ctx);
    assert!(inventory.is_initialised == false, EInventoryAlreadyInitialised);

    let mut pfps: vector<ZeroArtBudget> = zero_art_budget::make_collection(admin, registry, ctx);
    let len = vector::length(&pfps);
    let mut i = 0;
    while (i < len) {
        let pfp = vector::pop_back(&mut pfps);
        table_vec::push_back(&mut inventory.pfps, pfp);
        i = i + 1;
    };

    vector::destroy_empty(pfps);

    inventory.is_initialised = true;
}

public fun issue_whitelist_ticket(admin: &AdminCap, beneficiary: address,ctx: &mut TxContext){
    admin.verify_admin(ctx);
    let whitelist_ticket = WhitelistTicket { id: object::new(ctx) };
    transfer::public_transfer(whitelist_ticket, beneficiary);


}


public fun public_mint(){


    
}





