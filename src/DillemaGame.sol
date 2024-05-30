// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract DillemaGame {
    address public player1;
    address public player2;

    uint256 public player1Choice;
    uint256 public player2Choice;

    uint256 public player1Deposit;
    uint256 public player2Deposit;

    uint256 public player1Points;
    uint256 public player2Points;

    bool public player1ChoiceCommitted;
    bool public player2ChoiceCommitted;

    ERC20 token;
    uint256 public tokenAmount;
    uint256 gameDuration;
    uint256 gameCount;

    constructor(ERC20 _token, uint256 _tokenAmount, uint256 _gameDuration) {
        token = _token;
        tokenAmount = _tokenAmount;
        gameDuration = _gameDuration;
        gameCount = 0;
    }

    function createNewGame(ERC20 _token) external {
        require(player1 == address(0), "Game already has two players");
        player1 = msg.sender;
        token = _token;
        gameCount++;
    }

    function getGameCount() external view returns (uint256) {
        return gameCount;
    }

    function joinGamePlayer1(address _player1) external {
        require(player1 != address(0), "Game has no player 1");
        require(player2 == address(0), "Game already has two players");
        player1 = _player1;
        require(player1 != address(0), "Player 1 faild to join Game");
    }

    function joinGamePlayer2(address _player2) external {
        require(player1 != address(0), "Game has no player 1");
        player2 = _player2;
        require(player2 != address(0), "Player 2 faild to join Game");
    }

    function depositPlayer1(
        address _player1,
        ERC20 _token,
        uint256 _amount
    ) external {
        require(player1 == _player1, "Player 1 is not the sender");
        require(_amount != 0, "Can't deposit 0 tokens");
        require(_token == token, "Token is not the same as the game token");
        player1Deposit = _amount;
    }

    function depositPlayer2(
        address _player2,
        ERC20 _token,
        uint256 _amount
    ) external {
        require(player2 == _player2, "Player 2 is not the sender");
        require(_amount != 0, "Can't deposit 0 tokens");
        require(_token == token, "Token is not the same as the game token");
        player2Deposit = _amount;
    }

    function setPlayer1Choice(address _player1, uint256 _choice) external {
        require(player1 == _player1, "Player 1 is not the sender");
        require(_choice == 1 || _choice == 2, "Invalid choice");
        player1Choice = _choice;
        player1ChoiceCommitted = true;
    }

    function setPlayer2Choice(address _player2, uint256 _choice) external {
        require(player2 == _player2, "Player 2 is not the sender");
        require(_choice == 1 || _choice == 2, "Invalid choice");
        player2Choice = _choice;
        player2ChoiceCommitted = true;
    }

    function roundStart() external {
        require(
            player1ChoiceCommitted && player2ChoiceCommitted,
            "Both players must commit their choices"
        );
        require(gameCount < gameDuration, "Game duration has expired");
        if (player1Choice == 1 && player2Choice == 1) {
            player1Points += 5;
            player2Points += 5;
        } else if (player1Choice == 1 && player2Choice == 2) {
            player1Points += 2;
            player2Points += 8;
        } else if (player1Choice == 2 && player2Choice == 1) {
            player1Points += 8;
            player2Points += 2;
        } else if (player1Choice == 2 && player2Choice == 2) {
            player1Points += 2;
            player2Points += 2;
        }
    }
}
