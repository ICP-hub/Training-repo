// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SecureVoting {
    // Tracks whether an address has voted
    mapping(address => bool) public hasVoted;
    // Stores vote count for each candidate
    mapping(uint => uint) public voteCounts;
    // Number of candidates (set to 2 for this example)
    uint public constant CANDIDATE_COUNT = 2;

    // Function to cast a vote
    function vote(uint candidateId) public {
        // Ensure the candidate ID is valid
        require(candidateId < CANDIDATE_COUNT, "Invalid candidate");
        // Ensure the voter hasn’t voted yet
        require(!hasVoted[msg.sender], "Already voted");

        // Mark the voter as having voted
        hasVoted[msg.sender] = true;
        // Increment the vote count for the chosen candidate
        voteCounts[candidateId]++;
    }

    // Function to check if an address has voted
    function checkHasVoted(address voter) public view returns (bool) {
        return hasVoted[voter];
    }

    // Function to get the vote count for a candidate
    function getVoteCount(uint candidateId) public view returns (uint) {
        require(candidateId < CANDIDATE_COUNT, "Invalid candidate");
        return voteCounts[candidateId];
    }
}