// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract BankingSystem {
    // Mapping to store balances
    mapping(address => uint) private balances;
    // Mapping to check if an account exists
    mapping(address => bool) private accountExists;

    // Modifier to check if the account exists
    modifier onlyExistingAccount() {
        require(accountExists[msg.sender], "Account does not exist!");
        _;
    }

    // Function to create a new account
    function createAccount() public {
        require(!accountExists[msg.sender], "Account already exists!");
        accountExists[msg.sender] = true;
        balances[msg.sender] = 0;
    }

    // Function to deposit Ether
    function deposit() public payable onlyExistingAccount {
        require(msg.value > 0, "Deposit amount must be greater than 0!");
        balances[msg.sender] += msg.value;
    }

    // Function to withdraw Ether
    function withdraw(uint _amount) public onlyExistingAccount {
        require(balances[msg.sender] >= _amount, "Insufficient balance!");
        balances[msg.sender] -= _amount;
        payable(msg.sender).transfer(_amount);
    }

    // Function to transfer Ether
    function transfer(address _to, uint _amount) public onlyExistingAccount {
        require(accountExists[_to], "Recipient account does not exist!");
        require(balances[msg.sender] >= _amount, "Insufficient balance!");
        balances[msg.sender] -= _amount;
        balances[_to] += _amount;
    }

    // Function to check balance
    function getBalance() public view onlyExistingAccount returns (uint) {
        return balances[msg.sender];
    }

    // Add this only if you want to send Ether during deployment
constructor() payable {
    // Logic for handling Ether sent during deployment, if needed
}

}
