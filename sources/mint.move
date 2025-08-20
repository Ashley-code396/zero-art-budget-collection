// module zero_art_budget::mint;
// use sui::package;
// use sui::display;
// use zero_art_budget::admin::{Self,AdminCap};
// use zero_art_budget::zero_art_budget::{Self, ZeroArtBudget};
// use sui::table_vec::{Self,TableVec};





// const EInventoryAlreadyInitialised: u64 = 0;

// const SUPERADMIN: address = @0x17c9ba64e43dbb64c57c33bf10f9b3807f8bfcf29990d477cbb54d18a19de81e;





// public struct WhitelistTicket has key, store{
//     id: UID
// }

// public struct MINT has drop{}

// #[allow(unused_variable)]
// fun init(otw: MINT, ctx: &mut TxContext){

//     let publisher = package::claim(otw, ctx);
//     let  mut whitelist_ticket_display = display::new<WhitelistTicket>(&publisher, ctx);
//     whitelist_ticket_display.add(b"name".to_string(), b"A zero art budget whitelist".to_string());
//     whitelist_ticket_display.add(b"description".to_string(), b"A zero art budget whitelist for zero art budget collection".to_string());
//     whitelist_ticket_display.add(b"image_url".to_string(), b"https://i.ibb.co/PJQKhbW/photo-1601684632403-4ce4a06d8429.jpg".to_string());
//     whitelist_ticket_display.update_version();
    




    

    
//     transfer::public_transfer(whitelist_ticket_display, SUPERADMIN);
//     transfer::public_transfer(publisher, SUPERADMIN);

    
// }


// public fun add_pfp_to_inventory(
//     admin: &AdminCap,
//     inventory: &mut Inventory,
//     ctx: &mut TxContext
// ) {
//     admin.verify_admin(ctx);
//     assert!(inventory.is_initialised == false, EInventoryAlreadyInitialised);

//     let pfps: TableVec<ZeroArtBudget> = zero_art_budget::make_collection(admin,  ctx);
//     inventory.pfps;
    
//     inventory.is_initialised = true;
// }






// public fun issue_whitelist_ticket(admin: &AdminCap, beneficiary: address,ctx: &mut TxContext){
//     admin.verify_admin(ctx);
//     let whitelist_ticket = WhitelistTicket { id: object::new(ctx) };
//     transfer::public_transfer(whitelist_ticket, beneficiary);


// }


// public fun public_mint(){


    
// }





