module counter_addr::counter {
    use aptos_framework::signer;

    // Define a resource to store the counter value
    struct Counter has key {
        value: u64
    }

    // Initialize the counter (only callable once per account)
    public entry fun initialize(account: &signer) {
        assert!(!exists<Counter>(signer::address_of(account)), 1); // Prevent re-initialization
        move_to(account, Counter { value: 0 });
    }

    // Increment the counter
    public entry fun increment(account: &signer) acquires Counter {
        let counter = borrow_global_mut<Counter>(signer::address_of(account));
        counter.value = counter.value + 1;
    }

    // Decrement the counter
    public entry fun decrement(account: &signer) acquires Counter {
        let counter = borrow_global_mut<Counter>(signer::address_of(account));
        assert!(counter.value > 0, 2); // Prevent underflow
        counter.value = counter.value - 1;
    }

    // Get the counter value (view function)
    #[view]
    public fun get_value(addr: address): u64 acquires Counter {
        borrow_global<Counter>(addr).value
    }
}