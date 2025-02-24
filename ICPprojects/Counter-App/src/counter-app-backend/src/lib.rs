use ic_cdk_macros::{query, update};
use std::cell::RefCell;

thread_local! {
    static COUNTER: RefCell<i32> = RefCell::new(0);
}

#[query]
fn get_count() -> i32 {
    COUNTER.with(|counter| *counter.borrow())
}

#[update]
fn increment() {
    COUNTER.with(|counter| *counter.borrow_mut() += 1);
}

#[update]
fn decrement() {
    COUNTER.with(|counter| *counter.borrow_mut() -= 1);
}

#[update]
fn reset() {
    COUNTER.with(|counter| *counter.borrow_mut() = 0);
}
