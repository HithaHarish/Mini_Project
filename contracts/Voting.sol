// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Voting {
    struct Candidate {
        uint id;
        string name;
        uint voteCount;
    }

    struct Voter {
        bool authorized;
        bool voted;
        uint vote;
    }

    address public admin;
    string public electionName;
    mapping(uint => Candidate) public candidates;
    mapping(address => Voter) public voters;
    uint public totalVotes;
    uint public candidateCount;

    constructor(string memory _name) {
    admin = msg.sender;
    electionName = _name;
}


    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can do this");
        _;
    }

    function addCandidate(string memory _name) public onlyAdmin {
        candidateCount++;
        candidates[candidateCount] = Candidate(candidateCount, _name, 0);
    }

    function authorize(address _voter) public onlyAdmin {
        voters[_voter].authorized = true;
    }

    function vote(uint _candidateId) public {
        require(voters[msg.sender].authorized, "Not authorized");
        require(!voters[msg.sender].voted, "Already voted");
        require(_candidateId > 0 && _candidateId <= candidateCount, "Invalid candidate");

        voters[msg.sender].voted = true;
        voters[msg.sender].vote = _candidateId;
        candidates[_candidateId].voteCount++;
        totalVotes++;
    }

    function getResults() public view returns (string memory winnerName, uint winnerVotes) {
        uint maxVotes = 0;
        uint winnerId = 0;
        for (uint i = 1; i <= candidateCount; i++) {
            if (candidates[i].voteCount > maxVotes) {
                maxVotes = candidates[i].voteCount;
                winnerId = i;
            }
        }
        winnerName = candidates[winnerId].name;
        winnerVotes = candidates[winnerId].voteCount;
    }
}
