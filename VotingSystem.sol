// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract EVotingSystem {
    // Struct to represent a candidate
    struct Candidate {
        string name;
        uint voteCount;
    }

    // Owner of the contract (the election admin)
    address public electionAdmin;

    // List of candidates
    Candidate[] public candidates;

    // To track if an address has voted
    mapping(address => bool) public hasVoted;

    // Event to be emitted when a vote is cast
    event VoteCast(address indexed voter, uint candidateIndex);

    // Modifier to restrict functions to admin only
    modifier onlyAdmin() {
        require(msg.sender == electionAdmin, "Only admin can call this function");
        _;
    }

    // Modifier to ensure the voter hasn't voted already
    modifier hasNotVoted() {
        require(!hasVoted[msg.sender], "You have already voted");
        _;
    }

    // Constructor to initialize the admin and the list of candidates
    constructor(string[] memory candidateNames) {
        electionAdmin = msg.sender;
        for (uint i = 0; i < candidateNames.length; i++) {
            candidates.push(Candidate({
                name: candidateNames[i],
                voteCount: 0
            }));
        }
    }

    // Function to vote for a candidate
    function vote(uint candidateIndex) external hasNotVoted {
        require(candidateIndex < candidates.length, "Invalid candidate index");

        // Mark the sender as having voted
        hasVoted[msg.sender] = true;

        // Increment the selected candidate's vote count
        candidates[candidateIndex].voteCount++;

        // Emit the VoteCast event
        emit VoteCast(msg.sender, candidateIndex);
    }

    // Function to get the list of candidates
    function getCandidates() external view returns (Candidate[] memory) {
        return candidates;
    }

    // Function to get the total votes of a candidate
    function getVoteCount(uint candidateIndex) external view returns (uint) {
        require(candidateIndex < candidates.length, "Invalid candidate index");
        return candidates[candidateIndex].voteCount;
    }

    // Function to add new candidates (only admin can add)
    function addCandidate(string memory candidateName) external onlyAdmin {
        candidates.push(Candidate({
            name: candidateName,
            voteCount: 0
        }));
    }

    // Function to get the winner
    function getWinner() external view returns (string memory winnerName) {
        uint maxVotes = 0;
        uint winnerIndex = 0;

        for (uint i = 0; i < candidates.length; i++) {
            if (candidates[i].voteCount > maxVotes) {
                maxVotes = candidates[i].voteCount;
                winnerIndex = i;
            }
        }

        return candidates[winnerIndex].name;
    }
}
