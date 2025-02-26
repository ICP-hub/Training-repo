// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;
contract Vote {
    struct Voter {
        string name;
        uint age;
        uint voterId;
        Gender gender;
        uint voteCandidateId;
        address voterAddress;
    }
    struct Candidate {
        string name;
        string party;
        uint age;
        Gender gender;
        uint candidateId;
        address candidateAddress;
        uint votes;
    }
    address public electionCommission;
    address public winner;
    uint nextVoterId = 1;
    uint nextCandidateId = 1;
    // uint startTime;
    // uint endTime;
    bool Voting;


    mapping(uint => Voter) voterDetails;
    mapping(uint => Candidate) candidateDetails;


    enum Gender {NotSpecified, Male, Female, Other}


    constructor() {
        electionCommission=msg.sender;
    }


   

    modifier checkAge(uint _age){
        require(_age>=18,"your age is not suitable for eligibility");
        _;
    }
    modifier onlyCommissioner() {
        require(msg.sender==electionCommission);
        _;
    }


    function registerCandidate(
        string calldata _name,
        string calldata _party,
        uint _age,
        Gender _gender
    ) external checkAge(_age) {
        require(isCandidateNotRegistered(msg.sender),"you are already registered as candidate");
        require(nextCandidateId<3 ,"limit of candidate registration is over");
        require(msg.sender!=electionCommission,"election commissioners are not allowed to become candidate");
       candidateDetails[nextCandidateId]=Candidate(
        {
            name:_name,
            party:_party,
            age:_age,
            gender:_gender,
            candidateId:nextCandidateId,
            candidateAddress:msg.sender,
            votes:0
        });
       nextCandidateId++;
    }


    function isCandidateNotRegistered(address _person) internal view returns (bool) {
           for (uint i=1;i<nextCandidateId;i++){
            if(_person==candidateDetails[i].candidateAddress)
            return false;
           }
           return true;
    }


    function getCandidateList() public view returns (Candidate[] memory) {
        Candidate[] memory candidateList=new Candidate[](nextCandidateId-1);
        for (uint i=0;i<nextCandidateId-1;i++){
            candidateList[i]=candidateDetails[i+1];
        }
        return candidateList;
    }

    function isVoterNotRegistered(address _person) internal view returns (bool) {
         for(uint i=1;i<nextVoterId;i++){
            if(_person==voterDetails[i].voterAddress)
            return false;
         }
         return true;
    }


    function registerVoter(
        string calldata _name,
        uint _age,
        Gender _gender
    ) external checkAge(_age){
        require(isVoterNotRegistered(msg.sender),"you are already registered as voter");

        voterDetails[nextVoterId]=
        Voter({
            name:_name,
            age:_age,
            gender:_gender,
            voterId:nextVoterId,
            voteCandidateId:0,
            voterAddress:msg.sender
        });
        nextVoterId++;
    }


    function getVoterList() public view returns (Voter[] memory) {
        Voter[] memory voterList=new Voter[](nextVoterId-1);
        for (uint i=0;i<nextVoterId-1;i++){
            voterList[i]=voterDetails[i+1];
        }
        return voterList;
    }
    
    // 1=>{name ,age ,address} 1=>{}
    function castVote(uint _voterId, uint _candidateId) external isVotingOn{
        require(voterDetails[_voterId].voteCandidateId==0,"you have already voted");
        require(msg.sender==voterDetails[_voterId].voterAddress,"invalid voter id");
        require(_candidateId>0 && _candidateId<3,"invalid candidate id");
        require(_voterId>0,"invalid voter id");

        voterDetails[_voterId].voteCandidateId=_candidateId;
        candidateDetails[_candidateId].votes++;
    }


    // function setVotingPeriod(uint _startDuration, uint _endDuration) external onlyCommissioner() {
    //     require(_endDuration>=3600,"end time duration must be greater than 1 hour");
    //     startTime=block.timestamp+_startDuration;
    //     endTime=startTime+_endDuration;
    // }

    enum VotingStatus {notStarted,started}

    function getVotingStatus() public view returns (VotingStatus) {
        if(Voting==false)
        return VotingStatus.notStarted;
        return VotingStatus.started;
    }
     modifier isVotingOn() {
        require(Voting==true,"this is not voting time");
      _;
    }

    function announceVotingResult() external onlyCommissioner() {
        uint max=0;
        for (uint i=1;i<nextCandidateId;i++){
            if(candidateDetails[i].votes>max)
            max=candidateDetails[i].votes;
            winner=candidateDetails[i].candidateAddress;
        }
    }


    function StopVoting() public onlyCommissioner {
       Voting=false;
    }
    function StartVoting() public onlyCommissioner{
        Voting=true;
    }
}