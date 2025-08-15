
#[test_only]
module zero_art_budget::zero_art_budget_tests;
// uncomment this line to import the module
// use zero_art_budget::zero_art_budget;

const ENotImplemented: u64 = 0;

#[test]
fun test_zero_art_budget() {
    // pass
}

#[test, expected_failure(abort_code = ::zero_art_budget::zero_art_budget_tests::ENotImplemented)]
fun test_zero_art_budget_fail() {
    abort ENotImplemented
}

