#[test_only]
module counter_addr::counter_tests {
    use counter_addr::counter;
    use aptos_framework::signer;

    #[test(account = @counter_addr)]
    fun test_counter(account: &signer) {
        // Initialize the counter
        counter::initialize(account);
        assert!(counter::get_value(signer::address_of(account)) == 0, 1);

        // Increment the counter
        counter::increment(account);
        assert!(counter::get_value(signer::address_of(account)) == 1, 2);

        // Increment again
        counter::increment(account);
        assert!(counter::get_value(signer::address_of(account)) == 2, 3);

        // Decrement the counter
        counter::decrement(account);
        assert!(counter::get_value(signer::address_of(account)) == 1, 4);

        // Decrement again
        counter::decrement(account);
        assert!(counter::get_value(signer::address_of(account)) == 0, 5);
    }

    #[test(account = @counter_addr)]
    #[expected_failure] // Should fail if we decrement below 0
    fun test_decrement_underflow(account: &signer) {
        counter::initialize(account);
        counter::decrement(account); // Should fail since counter is 0
    }
}