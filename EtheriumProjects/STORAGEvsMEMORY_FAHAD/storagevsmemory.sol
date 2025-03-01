// SPDX-License-Identifier: MIT
pragma solidity >=0.8.12 <0.9.0;

contract StorageVSMemory {
    string public storedText;

    constructor(){
        storedText = "first Note";
    }

    function changeMemory(string memory newtext) public pure returns(string memory){
        string memory memText = newtext;
        return memText;
    }
    function changeStorage(string memory newtext) public{
        storedText = newtext;
    }
}