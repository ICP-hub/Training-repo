// SPDX-License-Identifier: MIT
pragma solidity <0.9.0;

contract Voting{

    struct choices{
        string title;
        uint votes;
        mapping(address => bool) allVoters;
    }
    struct poll{
        string title;
        bool status;
        string description;
        choices[] options;
    }
    address owner;
    poll public newPoll;
    mapping(address => uint) alreadyVoted;

    constructor(string memory _title, string memory _description){
        owner = msg.sender;
        newPoll.title = _title;
        newPoll.description = _description;
        newPoll.status = true;
    }

    function addChoice(string memory _title) public {
        require(msg.sender == owner, "Not Authorized.");
        require(newPoll.status, "Not Active.");
        choices storage newChoice = newPoll.options.push();
        newChoice.title = _title;
        newChoice.votes = 0;
    }

    function showChoices(uint _id) public view returns(string memory){
            choices storage selectedChoice = newPoll.options[_id];
            return selectedChoice.title;
    }

    function getChoices() public view returns (string[] memory, uint[] memory) {
        uint numChoices = newPoll.options.length;
        string[] memory titles = new string[](numChoices);
        uint[] memory votes = new uint[](numChoices);

        for (uint i = 0; i < numChoices; i++) {
            titles[i] = newPoll.options[i].title;
            votes[i] = newPoll.options[i].votes;
        }
        return (titles, votes);
    }

    function vote(uint _id) public {
        require(newPoll.status, "Not Active.");
        choices storage selectedChoice = newPoll.options[_id];
        require(selectedChoice.allVoters[msg.sender] != true, "Already Voted For this choice.");
        if(alreadyVoted[msg.sender] != _id){
            uint prevId = alreadyVoted[msg.sender];
            choices storage prevChoice = newPoll.options[prevId];
            if (prevChoice.votes > 0) {
                prevChoice.votes -= 1; 
            }
            prevChoice.allVoters[msg.sender] = false;
        }
        selectedChoice.votes = selectedChoice.votes + 1;
        selectedChoice.allVoters[msg.sender] = true;
        alreadyVoted[msg.sender] = _id;
    }
}