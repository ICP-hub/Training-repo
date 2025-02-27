use ic_cdk::{query, update};
use std::cell::RefCell;

thread_local! {
    static COUNTER:RefCell<i32>=RefCell::new(i32::from(0 as i32));
}

#[query]
fn get() -> i32 {
    COUNTER.with(|counter| counter.borrow().clone())
}
#[update]
fn increment() {
    COUNTER.with(|counter| *counter.borrow_mut() += 1 as i32)
}

#[update]
fn decrement() {
    COUNTER.with(|counter| *counter.borrow_mut() -= 1 as i32)
}
#[update]
fn set(n: i32) {
    COUNTER.with(|counter| *counter.borrow_mut() = n);
}
