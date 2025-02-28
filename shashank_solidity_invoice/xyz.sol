// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;


contract Blockchain {
    struct Block {
        uint index;
        uint timestamp;
        string[] transactions;
        bytes32 previousHash;
        bytes32 hash;
        uint nonce;
    }

    Block[] public chain;
    uint public difficulty = 4;

    constructor() {
        chain.push(createGenesisBlock());
    }

    function createGenesisBlock() private view returns (Block memory) {
        return Block({
            index: 0,
            timestamp: block.timestamp,
            transactions: new string[](0),
            previousHash: bytes32(0),
            hash: calculateHash(0, block.timestamp, new string[](0), bytes32(0), 0),
            nonce: 0
        });
    }

    function getLatestBlock() public view returns (Block memory) {
        return chain[chain.length - 1];
    }

    function addBlock(string[] memory transactions) public {
        Block memory previousBlock = getLatestBlock();
        uint newIndex = previousBlock.index + 1;
        uint newTimestamp = block.timestamp;
        bytes32 newPreviousHash = previousBlock.hash;
        uint newNonce = 0;
        bytes32 newHash;

        while (true) {
            newHash = calculateHash(newIndex, newTimestamp, transactions, newPreviousHash, newNonce);
            if (uint256(newHash) < 2 ** (256 - difficulty)) {
                break;
            }
            newNonce++;
        }

        chain.push(Block({
            index: newIndex,
            timestamp: newTimestamp,
            transactions: transactions,
            previousHash: newPreviousHash,
            hash: newHash,
            nonce: newNonce
        }));
    }

    function calculateHash(
        uint index,
        uint timestamp,
        string[] memory transactions,
        bytes32 previousHash,
        uint nonce
    ) private pure returns (bytes32) {
        return keccak256(abi.encode(index, timestamp, transactions, previousHash, nonce));
    }

    function isChainValid() public view returns (bool) {
        for (uint i = 1; i < chain.length; i++) {
            Block memory currentBlock = chain[i];
            Block memory previousBlock = chain[i - 1];

            if (currentBlock.hash != calculateHash(
                currentBlock.index,
                currentBlock.timestamp,
                currentBlock.transactions,
                currentBlock.previousHash,
                currentBlock.nonce
            )) {
                return false;
            }

            if (currentBlock.previousHash != previousBlock.hash) {
                return false;
            }
        }

        return true;
    }
}
