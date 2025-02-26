// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract StorageVsMemory {
    string public storedText; // Permanent 

    // temporarily changes the note but does not store it
    function updateWithMemory(string memory newText) public pure returns (string memory) {
        string memory tempText = newText; // Stored in memory, not blockchain
        return tempText;
    }

    // permanently updates the stored note
    function updateWithStorage(string memory newText) public {
        storedText = newText; // Stored on blockchain (storage)
    }
}
