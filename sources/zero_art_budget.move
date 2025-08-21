module zero_art_budget::zero_art_budget;

use std::string::String;
use zero_art_budget::attributes::{Attributes};
use sui::table_vec;
use sui::package;
use sui::display;
use zero_art_budget::admin::{AdminCap};
use sui::table_vec::TableVec;
use sui::event;


const SUPERADMIN: address = @0x17c9ba64e43dbb64c57c33bf10f9b3807f8bfcf29990d477cbb54d18a19de81e;
const COLLECTION_SIZE: u16 = 100;


public struct ZERO_ART_BUDGET has drop{}

public struct ZeroArtBudget has key, store{
    id: UID,
    number: u16,
    image: Option<String>,
    attributes: Option<Attributes>,
    minted_by: Option<address>,

}

public struct Inventory has key, store{
    id: UID,
    pfps: TableVec<ZeroArtBudget>,
    is_initialised: bool,
    public_mint_price: u64,
    whitelist_mint_price: u64

    
}


public struct InventoryCreated has copy, drop{
    inventory_id: ID,
    created_by: address,
    public_price: u64,
    whitelist_price: u64,
}


#[allow(lint(share_owned), unused_let_mut)]
fun init(otw: ZERO_ART_BUDGET, ctx: &mut TxContext){  
    let publisher = package::claim(otw, ctx);

    let mut display = display::new<ZeroArtBudget>(&publisher, ctx);
    display.add(b"name".to_string(), b"ZeroArtBudget #{number}".to_string());
    display.add(b"description".to_string(), 
    b"Created by a developer with zero budget, zero artistic instincts, but 100% love for experimenting".to_string());
    display.add(b"image_url".to_string(), b"{image}".to_string());
    display.add(b"attributes".to_string(), b"{attributes}".to_string());
    display.add(b"minted_by".to_string(), b"{minted_by}".to_string());
    display.add(b"kiosk_id".to_string(), b"{kiosk_id}".to_string());
    display.add(b"kiosk_owner_cap_id".to_string(), b"{kiosk_owner_cap_id}".to_string());
    display.update_version();


    let mut inventory = Inventory {
        id: object::new(ctx),
        pfps:table_vec::empty(ctx),
        is_initialised: false,
        public_mint_price: 2000000000,
        whitelist_mint_price: 1000000000

    };
    

    event::emit(InventoryCreated{
        inventory_id: object::id(&inventory),
        created_by: ctx.sender(),
        public_price: inventory.public_mint_price,
        whitelist_price: inventory.whitelist_mint_price

    });
    

    transfer::public_share_object(inventory);
    transfer::public_transfer(publisher, SUPERADMIN);
    transfer::public_transfer(display, SUPERADMIN);
   
    
    

}


public fun make_collection(admin: &AdminCap, inventory: &mut Inventory, ctx: &mut TxContext){
    admin.verify_admin(ctx);

    let mut number = 1;
    

    while (number <= COLLECTION_SIZE) {
        
        let pfp = ZeroArtBudget {
            id: object::new(ctx),
            number,
            image: option::none(),
            attributes: option::none(),
            minted_by: option::none(),
    
        };


        table_vec::push_back(&mut inventory.pfps, pfp);
        number = number + 1;
    };

    inventory.is_initialised = true;
}


public(package) fun pop_back_pfp(inventory: &mut Inventory) :ZeroArtBudget{
    table_vec::pop_back(&mut inventory.pfps)

}


public(package)  fun public_mint_payment(inventory: &Inventory) :u64{
    inventory.public_mint_price
}