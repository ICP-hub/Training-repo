use ic_cdk::storage;
use candid::CandidType;
use serde::{Deserialize, Serialize};
use std::cell::RefCell;

#[derive(CandidType, Deserialize, Serialize)]
struct Counter {
    value: i32,
}

thread_local! {
    static COUNTER: RefCell<Counter> = RefCell::new(Counter { value: 0 });
}

// Function to get the current counter value
#[ic_cdk::query]
fn get_count() -> i32 {
    COUNTER.with(|counter| counter.borrow().value)
}

// Function to increment the counter
#[ic_cdk::update]
fn increment() {
    COUNTER.with(|counter| {
        counter.borrow_mut().value += 1;
    });
}

// Function to decrement the counter
#[ic_cdk::update]
fn decrement() {
    COUNTER.with(|counter| {
        counter.borrow_mut().value -= 1;
    });
}

// Function to reset the counter
#[ic_cdk::update]
fn reset() {
    COUNTER.with(|counter| {
        counter.borrow_mut().value = 0;
    });
}
