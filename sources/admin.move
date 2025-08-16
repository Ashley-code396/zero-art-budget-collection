module zero_art_budget::admin;

const EAdminCapExpired: u64 = 0;

const SUPERADMIN: address = @0x17c9ba64e43dbb64c57c33bf10f9b3807f8bfcf29990d477cbb54d18a19de81e;

public struct SuperAdminCap has key, store {
    id: UID,
}

public struct AdminCap has key {
    id: UID,
    epoch: u64,
}

public struct ADMIN has drop {}

#[allow(unused_variable)]
fun init(otw: ADMIN, ctx: &mut TxContext) {
    let super_admin_cap = SuperAdminCap {
        id: object::new(ctx),
    };

    let admin_cap = internal_create_admins(ctx);
    transfer::public_transfer(super_admin_cap, SUPERADMIN);
    transfer::transfer(admin_cap, ctx.sender())
}

#[allow(unused_variable)]
public fun issue_admin_cap(cap: &SuperAdminCap, recipient: address, ctx: &mut TxContext) {
    let admin_cap = internal_create_admins(ctx);
    transfer::transfer(admin_cap, recipient);
}

public(package) fun verify_admin(cap: &AdminCap, ctx: &TxContext) {
    assert!(cap.epoch==ctx.epoch(), EAdminCapExpired);
}

fun internal_create_admins(ctx: &mut TxContext): AdminCap {
    let admin_cap = AdminCap {
        id: object::new(ctx),
        epoch: ctx.epoch(),
    };
    (admin_cap)
}
