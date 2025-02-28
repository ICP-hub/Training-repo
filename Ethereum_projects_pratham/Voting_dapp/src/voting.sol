// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract Election {
    struct Voter {
        string fullName;
        uint age;
        uint id;
        uint chosenCandidate;
        address voterWallet;
    }

    struct Candidate {
        string fullName;
        string partyAffiliation;
        uint age;
        uint id;
        address candidateWallet;
        uint voteCount;
    }

    address public electionAuthority;
    address public electedLeader;
    uint private nextVoterId = 1;
    uint private nextCandidateId = 1;
    bool public isVotingActive;

    mapping(uint => Voter) private voters;
    mapping(uint => Candidate) private candidates;

    constructor() {
        electionAuthority = msg.sender;
    }

    modifier ageRequirement(uint _age) {
        require(_age >= 18, "You must be at least 18 to participate.");
        _;
    }

    modifier onlyAuthority() {
        require(
            msg.sender == electionAuthority,
            "Only the election authority can perform this action."
        );
        _;
    }

    function registerCandidate(
        string calldata _fullName,
        string calldata _partyAffiliation,
        uint _age
    ) external ageRequirement(_age) {
        require(
            isCandidateUnique(msg.sender),
            "You are already a registered candidate."
        );
        require(nextCandidateId <= 3, "Candidate registration limit reached.");
        require(
            msg.sender != electionAuthority,
            "Election authority cannot run for election."
        );

        candidates[nextCandidateId] = Candidate({
            fullName: _fullName,
            partyAffiliation: _partyAffiliation,
            age: _age,
            id: nextCandidateId,
            candidateWallet: msg.sender,
            voteCount: 0
        });

        nextCandidateId++;
    }

    function isCandidateUnique(
        address _candidate
    ) internal view returns (bool) {
        for (uint i = 1; i < nextCandidateId; i++) {
            if (_candidate == candidates[i].candidateWallet) {
                return false;
            }
        }
        return true;
    }

    function listCandidates() public view returns (Candidate[] memory) {
        Candidate[] memory candidateList = new Candidate[](nextCandidateId - 1);
        for (uint i = 0; i < nextCandidateId - 1; i++) {
            candidateList[i] = candidates[i + 1];
        }
        return candidateList;
    }

    function isVoterUnique(address _voter) internal view returns (bool) {
        for (uint i = 1; i < nextVoterId; i++) {
            if (_voter == voters[i].voterWallet) {
                return false;
            }
        }
        return true;
    }

    function registerVoter(
        string calldata _fullName,
        uint _age
    ) external ageRequirement(_age) {
        require(
            isVoterUnique(msg.sender),
            "You are already registered as a voter."
        );

        voters[nextVoterId] = Voter({
            fullName: _fullName,
            age: _age,
            id: nextVoterId,
            chosenCandidate: 0,
            voterWallet: msg.sender
        });

        nextVoterId++;
    }

    function listVoters() public view returns (Voter[] memory) {
        Voter[] memory voterList = new Voter[](nextVoterId - 1);
        for (uint i = 0; i < nextVoterId - 1; i++) {
            voterList[i] = voters[i + 1];
        }
        return voterList;
    }

    function vote(uint _voterId, uint _candidateId) external votingActive {
        require(
            voters[_voterId].chosenCandidate == 0,
            "You have already voted."
        );
        require(
            msg.sender == voters[_voterId].voterWallet,
            "Invalid voter credentials."
        );
        require(
            _candidateId > 0 && _candidateId < nextCandidateId,
            "Invalid candidate ID."
        );
        require(_voterId > 0, "Invalid voter ID.");

        voters[_voterId].chosenCandidate = _candidateId;
        candidates[_candidateId].voteCount++;
    }

    enum VotingState {
        Inactive,
        Active
    }

    function checkVotingStatus() public view returns (VotingState) {
        return isVotingActive ? VotingState.Active : VotingState.Inactive;
    }

    modifier votingActive() {
        require(isVotingActive, "Voting is currently not active.");
        _;
    }

    function announceWinner() external onlyAuthority {
        uint maxVotes = 0;
        address currentWinner;

        for (uint i = 1; i < nextCandidateId; i++) {
            if (candidates[i].voteCount > maxVotes) {
                maxVotes = candidates[i].voteCount;
                currentWinner = candidates[i].candidateWallet;
            }
        }
        electedLeader = currentWinner;
    }

    function startVoting() public onlyAuthority {
        isVotingActive = true;
    }

    function stopVoting() public onlyAuthority {
        isVotingActive = false;
    }
}
