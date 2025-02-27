// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Import hardhat console
import "hardhat/console.sol";

contract StorageVsMemory {
    // State variable stored permanently in blockchain
    string public storedText;
    
    // Event to log updates and gas usage
    event TextUpdated(string oldText, string newText, bool isPermanent);
    event GasUsed(string functionName, uint256 gasUsed);
    
    constructor(string memory initialText) {
        storedText = initialText;
    }
    
    // Memory function - temporary modification
    function updateWithMemory(string memory newText) public view  returns (string memory) {
        string memory temporaryText = storedText;  // Creates a copy in memory
        temporaryText = newText;  // Modifies only the memory copy
        console.log("Temporary text (in memory): ", temporaryText);
        console.log("Stored text (unchanged): ", storedText);
        return temporaryText;  // Returns modified text, but storage remains unchanged
    }
    
    // Storage function - permanent modification
    function updateWithStorage(string memory newText) public {
        string memory oldText = storedText;
        storedText = newText;  // Updates the state variable
        emit TextUpdated(oldText, newText, true);
    }
    
    // Get current stored text
    function getCurrentText() public view returns (string memory) {
        return storedText;
    }
    
    // Test function for memory operation with console logging
    function testMemoryOperation(string memory newText) public returns (uint256) {
        uint256 startGas = gasleft();
        string memory result = updateWithMemory(newText);
        uint256 gasUsed = startGas - gasleft();
        
        // Console log the results
        console.log("Gas used for memory operation: ", gasUsed);
        console.log("Temporary result: ", result);
        console.log("Stored text (unchanged): ", storedText);
        
        emit GasUsed("Memory Operation", gasUsed);
        return gasUsed;
    }
    
    // Test function for storage operation with console logging
    function testStorageOperation(string memory newText) public returns (uint256) {
        uint256 startGas = gasleft();
        updateWithStorage(newText);
        uint256 gasUsed = startGas - gasleft();
        
        // Console log the results
        console.log("Gas used for storage operation: ", gasUsed);
        console.log("New stored text: ", storedText);
        
        emit GasUsed("Storage Operation", gasUsed);
        return gasUsed;
    }
}