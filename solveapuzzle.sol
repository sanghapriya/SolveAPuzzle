pragma solidity ^0.4.19;

contract PuzzleSubmission{

    event NewPuzzleSubmitted(uint id,address owner);

    mapping (uint => address) public puzzleCreatedBy;
    mapping (uint => uint) public puzzleSubmitFee;

    struct Puzzle {
        string challenge;
        uint256 reward;
        bool isSolved;
        }

    Puzzle[] public puzzles;

    function createPuzzle(string _challenge, uint _reward) public {
        uint id = puzzles.push(Puzzle(_challenge, _reward,false)) - 1;
        puzzleCreatedBy[id] = msg.sender;
        puzzleSubmitFee[id] = _reward/10;
        NewPuzzleSubmitted(id, msg.sender);

        }

}


contract AttemptPuzzle is PuzzleSubmission{

    event PuzzleSolutionSubmitted(uint id, address owner);

    mapping (address => uint) public solutionSubmittedByAddress;

    struct PuzzleSolver {
        string solution;
        uint puzzleId;
    }

    PuzzleSolver[] public solutions;

    function submitPuzzleSolution(string _solution, uint _puzzleId,uint submissionFee) public payable {
        require( puzzleSubmitFee[_puzzleId] == submissionFee);
        uint id = solutions.push(PuzzleSolver(_solution,_puzzleId)) - 1;
        solutionSubmittedByAddress[msg.sender] = id;
        PuzzleSolutionSubmitted(id, msg.sender);
    }
}


contract ClosePuzzle is PuzzleSubmission{

    function closePuzzle(uint _puzzleId, address _owner) public {
        require(puzzleCreatedBy[_puzzleId] == _owner);
        puzzles[_puzzleId].isSolved = true;
    }
}
