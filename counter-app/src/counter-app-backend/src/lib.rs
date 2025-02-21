use ic_cdk::storage;
use std::cell::RefCell;

thread_local! {
    static COUNTER: RefCell<u64> = RefCell::new(0);
}

// Query function to get the counter value
#[ic_cdk::query]
fn get_count() -> u64 {
    COUNTER.with(|counter| *counter.borrow())
}

// Update function to increment the counter
#[ic_cdk::update]
fn increment() {
    COUNTER.with(|counter| *counter.borrow_mut() += 1);
}

// Update function to decrement the counter
#[ic_cdk::update]
fn decrement() {
    COUNTER.with(|counter| {
        if *counter.borrow() > 0 {
            *counter.borrow_mut() -= 1;
        }
    });
}

// Update function to reset the counter
#[ic_cdk::update]
fn reset() {
    COUNTER.with(|counter| *counter.borrow_mut() = 0);
}
