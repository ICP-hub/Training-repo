use ic_cdk::{query, update};

static mut COUNTER: i64 = 0; // Declare a mutable static variable for storing the counter

#[query]
fn get_count() -> i64 {
    unsafe { COUNTER } // Return the current counter value
}

#[update]
fn increment() -> () {  // No return value, return unit type
    unsafe {
        COUNTER += 1; // Increment the counter
    }
}

#[update]
fn decrement() -> () {  // No return value, return unit type
    unsafe {
        COUNTER -= 1; // Decrement the counter
    }
}
