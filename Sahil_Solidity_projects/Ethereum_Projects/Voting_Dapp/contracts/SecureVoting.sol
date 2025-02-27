// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SecureVoting {
    // Enum to represent voting options
    enum Choice { ETHEREUM, SOLANA, ICP }
    
    // Struct to store vote counts
    struct VoteCount {
        uint256 ethereum;
        uint256 solana;
        uint256 icp;
        uint256 totalVotes;
    }
    
    // State variables
    VoteCount public voteCount;
    uint256 public votingEndTime;
    bool public winnerDeclared;
    
    // Mapping to track if an address has voted
    mapping(address => bool) public hasVoted;
    
    // Events
    event VoteCast(address indexed voter, Choice choice);
    event WinnerDeclared(string winner, uint256 winningVotes);
    
    // Modifiers
    modifier hasNotVoted() {
        require(!hasVoted[msg.sender], "Address has already voted");
        _;
    }
    
    modifier votingOpen() {
        require(block.timestamp < votingEndTime, "Voting period has ended");
        _;
    }
    
    // Constructor - sets voting period to 1 hour
    constructor() {
        voteCount = VoteCount(0, 0, 0, 0);
        votingEndTime = block.timestamp + 1 hours;
        winnerDeclared = false;
    }
    
    // Function to cast vote
    function castVote(Choice choice) external hasNotVoted votingOpen {
        // Mark the sender as having voted before making any state changes
        hasVoted[msg.sender] = true;
        
        // Update vote counts based on choice
        if (choice == Choice.ETHEREUM) {
            voteCount.ethereum += 1;
        } else if (choice == Choice.SOLANA) {
            voteCount.solana += 1;
        } else if (choice == Choice.ICP) {
            voteCount.icp += 1;
        } else {
            revert("Invalid choice");
        }
        
        // Increment total votes
        voteCount.totalVotes += 1;
        
        // Emit event
        emit VoteCast(msg.sender, choice);
    }
    
    // Function to declare winner
    function declareWinner() external {
        require(block.timestamp >= votingEndTime, "Voting period not yet ended");
        require(!winnerDeclared, "Winner already declared");
        
        string memory winner;
        uint256 winningVotes;
        
        if (voteCount.ethereum >= voteCount.solana && voteCount.ethereum >= voteCount.icp) {
            winner = "Ethereum";
            winningVotes = voteCount.ethereum;
        } else if (voteCount.solana >= voteCount.ethereum && voteCount.solana >= voteCount.icp) {
            winner = "Solana";
            winningVotes = voteCount.solana;
        } else {
            winner = "ICP";
            winningVotes = voteCount.icp;
        }
        
        winnerDeclared = true;
        emit WinnerDeclared(winner, winningVotes);
    }
    
    // View functions to get results
    function getResults() external view returns (VoteCount memory) {
        return voteCount;
    }
    
    function getHasVoted(address voter) external view returns (bool) {
        return hasVoted[voter];
    }
    
    // Function to check remaining voting time
    function getRemainingTime() external view returns (uint256) {
        if (block.timestamp >= votingEndTime) return 0;
        return votingEndTime - block.timestamp;
    }
}