// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {Choice} from "./variables/variables.sol";

contract DillemaGame {
    address public player1;
    address public player2;

    Choice public player1Choice;
    Choice public player2Choice;

    // uint256 public player1Deposit;
    // uint256 public player2Deposit;
    ERC20 public tokenPool;

    uint256 public player1Points;
    uint256 public player2Points;

    bool public player1ChoiceCommitted;
    bool public player2ChoiceCommitted;
    bool public isGameOver;

    ERC20 token;
    uint256 public tokenAmount;
    uint256 gameDuration;
    uint256 public roundCount;
    uint256 gameCount;

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
    }

    function setPlayerChoice(Choice _choice) external {
        require(
            msg.sender == player1 || msg.sender == player2,
            "Invalid player"
        );
        require(
            _choice == Choice.Cooperate || _choice == Choice.Defect,
            "Invalid choice"
        );
        if (msg.sender == player1) {
            player1Choice = _choice;
            player1ChoiceCommitted = true;
        } else {
            player2Choice = _choice;
            player2ChoiceCommitted = true;
        }
    }

    function roundStart() external {
        roundCount++;
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
        setIsGameOver();
    }

    function setGameCount() internal {
        gameCount++;
    }

    function getGameCount() external view returns (uint256) {
        return gameCount;
    }

    function setIsGameOver() internal {
        if (roundCount == gameDuration) {
            isGameOver = true;
        } else {
            isGameOver = false;
            setGameCount();
        }
    }

    function getIsGameOver() external view returns (bool) {
        return isGameOver;
    }

    function getWinner() external returns (address) {
        require(roundCount == gameDuration, "Game is not over yet");
        setIsGameOver();
        if (player1Points > player2Points) {
            return player1;
        } else if (player1Points < player2Points) {
            return player2;
        } else {
            return address(0);
        }
    }
}
