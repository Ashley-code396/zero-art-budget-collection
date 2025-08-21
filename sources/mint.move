module zero_art_budget::mint;

use sui::coin::Coin;
use sui::display;
use sui::kiosk;
use sui::package;
use sui::sui::SUI;
use sui::transfer_policy::{Self, TransferPolicy};
use zero_art_budget::admin::AdminCap;
use zero_art_budget::zero_art_budget::{Self, Inventory, ZeroArtBudget};

const EInsufficientPublicMintPrice: u64 = 0;
const EInsufficientWhitelistMintPrice: u64 = 1;

const SUPERADMIN: address = @0x17c9ba64e43dbb64c57c33bf10f9b3807f8bfcf29990d477cbb54d18a19de81e;

public struct WhitelistTicket has key, store {
    id: UID,
}

public struct MINT has drop {}

#[allow(unused_variable, lint(share_owned))]
fun init(otw: MINT, ctx: &mut TxContext) {
    let publisher = package::claim(otw, ctx);
    let mut whitelist_ticket_display = display::new<WhitelistTicket>(&publisher, ctx);
    whitelist_ticket_display.add(b"name".to_string(), b"A zero art budget whitelist".to_string());
    whitelist_ticket_display.add(
        b"description".to_string(),
        b"A zero art budget whitelist for zero art budget collection".to_string(),
    );
    whitelist_ticket_display.add(
        b"image_url".to_string(),
        b"https://i.ibb.co/PJQKhbW/photo-1601684632403-4ce4a06d8429.jpg".to_string(),
    );
    whitelist_ticket_display.update_version();

    let (policy, cap) = transfer_policy::new<ZeroArtBudget>(&publisher, ctx);

    transfer::public_transfer(whitelist_ticket_display, SUPERADMIN);
    transfer::public_transfer(publisher, SUPERADMIN);
    transfer::public_share_object(policy);
    transfer::public_transfer(cap, SUPERADMIN);
}

public fun issue_whitelist_ticket(admin: &AdminCap, beneficiary: address, ctx: &mut TxContext) {
    admin.verify_admin(ctx);
    let whitelist_ticket = WhitelistTicket { id: object::new(ctx) };

    transfer::public_transfer(whitelist_ticket, beneficiary);
}

#[allow(unused_let_mut, lint(self_transfer))]

public fun public_mint(
    payment: Coin<SUI>,
    inventory: &mut Inventory,
    _policy: &mut TransferPolicy<ZeroArtBudget>,
    ctx: &mut TxContext,
) {
    assert!(payment.value()<2000000000, EInsufficientPublicMintPrice);

    let (mut kiosk, kiosk_owner_cap) = kiosk::new(ctx);
    let mut pfp = zero_art_budget::pop_back_pfp(inventory);

    kiosk.lock(&kiosk_owner_cap, _policy, pfp);
    transfer::public_transfer(kiosk_owner_cap, ctx.sender());
    transfer::public_share_object(kiosk);

    transfer::public_transfer(payment, SUPERADMIN);
}

#[allow(unused_let_mut, lint(self_transfer))]
public fun whitelist_mint(
    payment: Coin<SUI>,
    whitelist: WhitelistTicket,
    _policy: &mut TransferPolicy<ZeroArtBudget>,
    inventory: &mut Inventory,
    ctx: &mut TxContext,
) {
    assert!(payment.value()<1000000000, EInsufficientWhitelistMintPrice);

    let (mut kiosk, kiosk_owner_cap) = kiosk::new(ctx);
    let mut pfp = zero_art_budget::pop_back_pfp(inventory);

    kiosk.lock(&kiosk_owner_cap, _policy, pfp);

    transfer::public_transfer(kiosk_owner_cap, ctx.sender());
    transfer::public_share_object(kiosk);

    transfer::public_transfer(payment, SUPERADMIN);

    let WhitelistTicket { id } = whitelist;
    id.delete();
}
