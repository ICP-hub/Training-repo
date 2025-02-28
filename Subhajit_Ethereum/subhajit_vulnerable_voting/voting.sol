// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface VoterContract {
    function notifyVote(uint candidateId) external;
}

contract VulnerableVoting {
    // Tracks whether an address has voted
    mapping(address => bool) public hasVoted;
    // Stores vote count for each candidate
    mapping(uint => uint) public voteCounts;
    // Number of candidates (for validation)
    uint public constant CANDIDATE_COUNT = 2;

    function vote(uint candidateId) public {
        require(candidateId < CANDIDATE_COUNT, "Invalid candidate");
        require(!hasVoted[msg.sender], "Already voted");

        // If voter is a contract, notify it (vulnerable external call)
        if (isContract(msg.sender)) {
            VoterContract voter = VoterContract(msg.sender);
            voter.notifyVote(candidateId);
        }

        // State updates after external call (vulnerability)
        hasVoted[msg.sender] = true;
        voteCounts[candidateId]++;
    }

    // Checks if an address is a contract
    function isContract(address _addr) private view returns (bool) {
        uint size;
        assembly {
            size := extcodesize(_addr)
        }
        return size > 0;
    }
}