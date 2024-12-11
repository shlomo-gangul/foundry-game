// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "forge-std/console.sol";
import {Choice} from "./variables/variables.sol";

contract DillemaGame {
    address public player1;
    address public player2;
    address public winner;

    Choice public player1Choice = Choice.None;
    Choice public player2Choice = Choice.None;

    uint256 public player1Points;
    uint256 public player2Points;

    bool public player1ChoiceCommitted;
    bool public player2ChoiceCommitted;
    bool public isGameOver;

    ERC20 public token;
    uint256 public tokenAmount;
    uint256 public gameDuration;
    uint256 public roundCount;
    uint256 public gameCount;

    mapping(address => bytes32) public commitments;
    mapping(uint256 => Choice) public player1Choices;
    mapping(uint256 => Choice) public player2Choices;

    // Define events
    event GameJoined(address indexed player);
    event ChoiceCommitted(address indexed player, bytes32 commitment);
    event ChoiceRevealed(address indexed player, Choice choice, uint256 nonce);
    event RoundOutcome(
        uint256 round,
        uint256 player1Points,
        uint256 player2Points
    );
    event GameOver(address winner);
    event GameEnded(address winner, uint256 amount);

    constructor(ERC20 _token, uint256 _tokenAmount, uint256 _gameDuration) {
        token = _token;
        tokenAmount = _tokenAmount;
        gameDuration = _gameDuration;
        gameCount = 0;
        roundCount = 0;
    }

    function joinGame() external {
        require(
            token.balanceOf(msg.sender) >= tokenAmount / 2,
            "Insufficient balance"
        );
        token.transferFrom(msg.sender, address(this), tokenAmount / 2);
        if (player1 == address(0)) {
            player1 = msg.sender;
        } else {
            player2 = msg.sender;
        }
        emit GameJoined(msg.sender); // Emit the GameJoined event
    }

    function commitChoice(bytes32 _commitment) external {
        require(
            msg.sender == player1 || msg.sender == player2,
            "Invalid player"
        );
        commitments[msg.sender] = _commitment;
        if (msg.sender == player1) {
            player1ChoiceCommitted = true;
        } else {
            player2ChoiceCommitted = true;
        }
        emit ChoiceCommitted(msg.sender, _commitment); // Emit the ChoiceCommitted event
    }

    function revealChoice(Choice _choice, uint256 _nonce) external {
        require(
            msg.sender == player1 || msg.sender == player2,
            "Invalid player"
        );
        require(commitments[msg.sender] != bytes32(0), "No commitment found");

        // Verify the commitment
        bytes32 hash = keccak256(abi.encodePacked(_choice, _nonce));
        require(hash == commitments[msg.sender], "Invalid choice or nonce");

        // Store the revealed choice
        if (msg.sender == player1) {
            player1Choice = _choice;
        } else {
            player2Choice = _choice;
        }

        // Mark the commitment as revealed
        commitments[msg.sender] = bytes32(0);

        // Emit the ChoiceRevealed event
        emit ChoiceRevealed(msg.sender, _choice, _nonce);

        // Check if both players have revealed their choices
        if (player1ChoiceCommitted && player2ChoiceCommitted) {
            // Store the choices for the current round
            player1Choices[roundCount] = player1Choice;
            player2Choices[roundCount] = player2Choice;

            // Process the round outcome
            processRoundOutcome();
            roundCount++;
            player1ChoiceCommitted = false;
            player2ChoiceCommitted = false;
        }
    }

    function processRoundOutcome() internal {
        require(
            player1ChoiceCommitted && player2ChoiceCommitted,
            "Both players must commit their choices"
        );
        require(roundCount <= gameDuration, "Game duration has expired");

        if (
            player1Choice == Choice.Cooperate &&
            player2Choice == Choice.Cooperate
        ) {
            player1Points += 5;
            player2Points += 5;
        } else if (
            player1Choice == Choice.Cooperate && player2Choice == Choice.Defect
        ) {
            player1Points += 2;
            player2Points += 8;
        } else if (
            player1Choice == Choice.Defect && player2Choice == Choice.Cooperate
        ) {
            player1Points += 8;
            player2Points += 2;
        } else if (
            player1Choice == Choice.Defect && player2Choice == Choice.Defect
        ) {
            player1Points += 2;
            player2Points += 2;
        }

        // Emit the RoundOutcome event
        emit RoundOutcome(roundCount, player1Points, player2Points);

        setIsGameOver();
    }

    function setIsGameOver() internal {
        if (roundCount == gameDuration) {
            isGameOver = true;
            winner = getWinner();
            gameCount++;
            emit GameOver(winner); // Emit the GameOver event
        } else {
            isGameOver = false;
        }
    }

    function getIsGameOver() external view returns (bool) {
        return isGameOver;
    }

    function getWinner() public view returns (address) {
        require(roundCount == gameDuration, "Game is not over yet");
        if (player1Points > player2Points) {
            return player1;
        } else if (player1Points < player2Points) {
            return player2;
        } else {
            return address(0);
        }
    }

    function getRoundChoices() external view returns (Choice, Choice) {
        return (player1Choice, player2Choice);
    }

    function endGame() external {
        require(
            msg.sender == player1 || msg.sender == player2,
            "Invalid player"
        );
        require(
            token.balanceOf(address(this)) == tokenAmount,
            "Invalid token balance"
        );
        isGameOver = true;
        if (player1Points > player2Points) {
            token.transfer(player1, tokenAmount);
            winner = player1;
        } else if (player1Points < player2Points) {
            token.transfer(player2, tokenAmount);
            winner = player2;
        } else {
            token.transfer(player1, tokenAmount / 2);
            token.transfer(player2, tokenAmount / 2);
            winner = address(0);
        }
        emit GameEnded(winner, tokenAmount); // Emit the GameEnded event
    }
}
