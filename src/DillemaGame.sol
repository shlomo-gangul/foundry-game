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

    function joinGame(address _player) external {
        require(_player != address(0), "Address does not exist");
        require(player1 == address(0), "Game already has a player 1");
        require(
            token.balanceOf(_player) >= tokenAmount / 2,
            "Insufficient balance"
        );
        token.transfer(_player, tokenAmount / 2);
        player1 = _player;
    }

    function withdrawOnJoinGame(address _player) external {
        require(_player != address(0), "Address does not exist");
        token.transfer(_player, tokenAmount / 2);
        player2 = _player;
        gameCount++;
    }

    // function joinGamePlayer1(address _player1) external {
    //     require(player1 != address(0), "Game has no player 1");
    //     require(player2 == address(0), "Game already has two players");
    //     player1 = _player1;
    //     require(player1 != address(0), "Player 1 faild to join Game");
    // }

    // function joinGamePlayer2(address _player2) external {
    //     require(player1 != address(0), "Game has no player 1");
    //     player2 = _player2;
    //     require(player2 != address(0), "Player 2 faild to join Game");
    // }

    // function depositPlayer1(
    //     address _player1,
    //     ERC20 _token,
    //     uint256 _amount
    // ) external {
    //     require(player1 == _player1, "Player 1 is not the sender");
    //     require(_amount != 0, "Can't deposit 0 tokens");
    //     require(_token == token, "Token is not the same as the game token");
    //     player1Deposit = _amount;
    // }

    // function depositPlayer2(
    //     address _player2,
    //     ERC20 _token,
    //     uint256 _amount
    // ) external {
    //     require(player2 == _player2, "Player 2 is not the sender");
    //     require(_amount != 0, "Can't deposit 0 tokens");
    //     require(_token == token, "Token is not the same as the game token");
    //     player2Deposit = _amount;
    // }

    function setPlayer1Choice(address _player1, Choice _choice) external {
        require(player1 == _player1, "Player 1 is not the sender");
        require(
            _choice == Choice.Cooperate || _choice == Choice.Defect,
            "Invalid choice"
        );
        player1Choice = _choice;
        player1ChoiceCommitted = true;
    }

    function setPlayer2Choice(address _player2, Choice _choice) external {
        require(player2 == _player2, "Player 2 is not the sender");
        require(
            _choice == Choice.Cooperate || _choice == Choice.Defect,
            "Invalid choice"
        );
        player2Choice = _choice;
        player2ChoiceCommitted = true;
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
        player1ChoiceCommitted = false;
        player2ChoiceCommitted = false;
    }

    function getGameCount() external view returns (uint256) {
        return gameCount;
    }

    function getIsGameOver() external view returns (bool) {
        return isGameOver;
    }

    function getWinner() external returns (address) {
        require(roundCount == gameDuration, "Game is not over yet");
        isGameOver = true;
        if (player1Points > player2Points) {
            return player1;
        } else if (player1Points < player2Points) {
            return player2;
        } else {
            return address(0);
        }
    }
}
