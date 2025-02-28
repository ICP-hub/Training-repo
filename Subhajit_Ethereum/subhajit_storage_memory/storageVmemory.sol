// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract StorageVsMemory {
    // Stored permanently on the blockchain (storage)
    uint[] public storedArray;

    constructor() {
        storedArray.push(1);
        storedArray.push(2);
        storedArray.push(3);
    }

    // Modifies the storage array directly
    function modifyStorage(uint _index, uint _value) public {
        storedArray[_index] = _value;
    }

    // Uses memory, creates a copy, doesn't affect storage
    function modifyMemory(uint _index, uint _value) public view returns (uint[] memory) {
        uint[] memory tempArray = storedArray;
        tempArray[_index] = _value;
        return tempArray;
    }

    // Returns the current state of storedArray
    function getStoredArray() public view returns (uint[] memory) {
        return storedArray;
    }
}