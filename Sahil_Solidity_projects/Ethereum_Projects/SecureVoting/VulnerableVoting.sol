// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract VulnerableVoting {
    struct Candidate {
        string name;
        uint256 voteCount;
    }

    mapping(address => bool) public hasVoted;
    Candidate[] public candidates;
    bool public votingOpen;

    constructor(string[] memory candidateNames) {
        for (uint256 i = 0; i < candidateNames.length; i++) {
            candidates.push(Candidate(candidateNames[i], 0));
        }
        votingOpen = true;
    }

    function vote(uint256 candidateIndex) public {
        require(votingOpen, "Voting is closed");
        require(candidateIndex < candidates.length, "Invalid candidate");

        // Vulnerability: External calls before updating state
        (bool success, ) = msg.sender.call(""); // Allows re-entrant calls
        require(success, "External call failed");

        candidates[candidateIndex].voteCount += 1;
        hasVoted[msg.sender] = true;
    }

    function closeVoting() public {
        votingOpen = false;
    }

    function getWinner() public view returns (string memory) {
        uint256 maxVotes = 0;
        uint256 winnerIndex = 0;

        for (uint256 i = 0; i < candidates.length; i++) {
            if (candidates[i].voteCount > maxVotes) {
                maxVotes = candidates[i].voteCount;
                winnerIndex = i;
            }
        }

        return candidates[winnerIndex].name;
    }
}
