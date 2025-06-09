// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "forge-std/console.sol";
import {Choice} from "./variables/variables.sol";

contract DillemaGame is ReentrancyGuard, Ownable {
    address public player1;
    address public player2;
    address public winner;

    Choice public player1Choice = Choice.None;
    Choice public player2Choice = Choice.None;

    uint256 public player1Points;
    uint256 public player2Points;

    // Pack booleans into a single storage slot to save gas
    uint8 private gameState; // Bit flags: 0=p1Committed, 1=p2Committed, 2=p1Revealed, 3=p2Revealed, 4=gameOver

    function player1ChoiceCommitted() public view returns (bool) {
        return gameState & 1 != 0;
    }

    function player2ChoiceCommitted() public view returns (bool) {
        return gameState & 2 != 0;
    }

    function player1ChoiceRevealed() public view returns (bool) {
        return gameState & 4 != 0;
    }

    function player2ChoiceRevealed() public view returns (bool) {
        return gameState & 8 != 0;
    }

    function isGameOver() public view returns (bool) {
        return gameState & 16 != 0;
    }

    ERC20 public token;
    uint256 public tokenAmount;
    uint32 public gameDuration;
    uint32 public roundCount;
    uint32 public gameCount;

    mapping(address => bytes32) public commitments;
    mapping(uint256 => Choice) public player1Choices;
    mapping(uint256 => Choice) public player2Choices;

    // Define events
    event GameJoined(address indexed player);
    event ChoiceCommitted(address indexed player, bytes32 commitment);
    event ChoiceRevealed(address indexed player, Choice choice, uint256 nonce);
    event RoundOutcome(uint256 round, uint256 player1Points, uint256 player2Points);
    event GameOver(address winner);
    event GameEnded(address winner, uint256 amount);
    event EmergencyWithdraw(address indexed owner, uint256 amount);

    constructor(ERC20 _token, uint256 _tokenAmount, uint32 _gameDuration) Ownable(msg.sender) {
        token = _token;
        tokenAmount = _tokenAmount;
        gameDuration = _gameDuration;
        gameCount = 0;
        roundCount = 0;
    }

    function joinGame() external {
        require(token.balanceOf(msg.sender) >= tokenAmount / 2, "Insufficient balance");
        token.transferFrom(msg.sender, address(this), tokenAmount / 2);
        if (player1 == address(0)) {
            player1 = msg.sender;
        } else {
            player2 = msg.sender;
        }
        emit GameJoined(msg.sender); // Emit the GameJoined event
    }

    function commitChoice(bytes32 _commitment) external {
        require(msg.sender == player1 || msg.sender == player2, "Invalid player");
        commitments[msg.sender] = _commitment;
        if (msg.sender == player1) {
            gameState |= 1; // Set player1ChoiceCommitted
        } else {
            gameState |= 2; // Set player2ChoiceCommitted
        }
        emit ChoiceCommitted(msg.sender, _commitment); // Emit the ChoiceCommitted event
    }

    function revealChoice(Choice _choice, uint256 _nonce) external {
        require(msg.sender == player1 || msg.sender == player2, "Invalid player");
        require(commitments[msg.sender] != bytes32(0), "No commitment found");

        // Verify the commitment
        bytes32 hash = keccak256(abi.encodePacked(_choice, _nonce));
        require(hash == commitments[msg.sender], "Invalid choice or nonce");

        // Store the revealed choice and mark as revealed
        if (msg.sender == player1) {
            player1Choice = _choice;
            gameState |= 4; // Set player1ChoiceRevealed
        } else {
            player2Choice = _choice;
            gameState |= 8; // Set player2ChoiceRevealed
        }

        // Mark the commitment as revealed
        commitments[msg.sender] = bytes32(0);

        // Emit the ChoiceRevealed event
        emit ChoiceRevealed(msg.sender, _choice, _nonce);

        // Check if both players have revealed their choices
        if ((gameState & 12) == 12) {
            // Check if both revealed bits are set
            // Store the choices for the current round
            player1Choices[roundCount] = player1Choice;
            player2Choices[roundCount] = player2Choice;

            // Process the round outcome
            processRoundOutcome();
            roundCount++;
            gameState &= 16; // Keep only isGameOver bit, reset all other flags
        }
    }

    function processRoundOutcome() internal {
        require((gameState & 12) == 12, "Both players must reveal their choices");
        require(roundCount < gameDuration, "Game duration has expired");

        if (player1Choice == Choice.Cooperate && player2Choice == Choice.Cooperate) {
            player1Points += 5;
            player2Points += 5;
        } else if (player1Choice == Choice.Cooperate && player2Choice == Choice.Defect) {
            player1Points += 2;
            player2Points += 8;
        } else if (player1Choice == Choice.Defect && player2Choice == Choice.Cooperate) {
            player1Points += 8;
            player2Points += 2;
        } else if (player1Choice == Choice.Defect && player2Choice == Choice.Defect) {
            player1Points += 2;
            player2Points += 2;
        }

        // Emit the RoundOutcome event
        emit RoundOutcome(roundCount, player1Points, player2Points);

        setIsGameOver();
    }

    function setIsGameOver() internal {
        if (roundCount >= gameDuration) {
            gameState |= 16; // Set isGameOver
            winner = getWinner();
            gameCount++;
            emit GameOver(winner); // Emit the GameOver event
        }
    }

    function getIsGameOver() external view returns (bool) {
        return isGameOver();
    }

    function getWinner() public view returns (address) {
        require(roundCount >= gameDuration, "Game is not over yet");
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

    function endGame() external nonReentrant {
        require(msg.sender == player1 || msg.sender == player2, "Invalid player");
        require(token.balanceOf(address(this)) == tokenAmount, "Invalid token balance");
        require(isGameOver() || roundCount >= gameDuration, "Game is not over yet");

        // Set game state first to prevent reentrancy
        gameState |= 16; // Set isGameOver

        // Determine winner and transfer tokens
        if (player1Points > player2Points) {
            winner = player1;
            token.transfer(player1, tokenAmount);
        } else if (player1Points < player2Points) {
            winner = player2;
            token.transfer(player2, tokenAmount);
        } else {
            winner = address(0);
            token.transfer(player1, tokenAmount / 2);
            token.transfer(player2, tokenAmount / 2);
        }
        emit GameEnded(winner, tokenAmount); // Emit the GameEnded event
    }

    // Emergency functions - only owner can call
    function emergencyWithdraw() external onlyOwner {
        require(token.balanceOf(address(this)) > 0, "No tokens to withdraw");
        uint256 balance = token.balanceOf(address(this));
        token.transfer(owner(), balance);
        emit EmergencyWithdraw(owner(), balance);
    }

    function forceEndGame() external onlyOwner {
        gameState |= 16; // Set isGameOver
        emit GameOver(address(0));
    }
}
