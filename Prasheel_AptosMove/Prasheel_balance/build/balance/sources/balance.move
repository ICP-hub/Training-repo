module balance::balance {
   
    use aptos_framework::signer;

    /// Struct to hold the balance for an account
    struct Balance has key {
        amount: u64
    }

    /// Initialize the balance for an account
    public entry fun initialize(account: &signer) {
        let balance = Balance { amount: 0 };
        move_to(account, balance);
    }

    /// Deposit coins into the balance
    public entry fun deposit(account: &signer, amount: u64) acquires Balance {
        let balance = borrow_global_mut<Balance>(signer::address_of(account));
        // Transfer coins from the account to the balance holder (for simplicity, we'll assume the account holds them)
        balance.amount = balance.amount + amount;
        // Note: In a real scenario, you'd need to transfer coins to a vault or escrow, not just update a number
    }

    /// Withdraw coins from the balance
    public entry fun withdraw(account: &signer, amount: u64) acquires Balance {
        let balance = borrow_global_mut<Balance>(signer::address_of(account));
        assert!(balance.amount >= amount, 1); // Error if insufficient balance
        balance.amount = balance.amount - amount;
        // Note: This doesn't actually transfer coins back yet; see below for a proper fix
    }

    #[view]
    public fun get_balance(account_addr: address): u64 acquires Balance {
        let balance = borrow_global<Balance>(account_addr);
        balance.amount
    }
}