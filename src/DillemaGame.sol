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

    bool public player1ChoiceCommitted;
    bool public player2ChoiceCommitted;

    bool public player1DepositCommitted;
    bool public player2DepositCommitted;

    ERC20 token;
    uint256 tokenAmount;
    uint256 gameDuration;
    uint256 gameCount;

    constructor(ERC20 _token, uint256 _tokenAmount, uint256 _gameDuration) {
        player1 = msg.sender;
        player2 = address(0);
        token = _token;
        tokenAmount = _tokenAmount;
        gameDuration = _gameDuration;
        gameCount = 0;
    }

    function createNewGame() external {
        require(player2 == address(0), "Game already has two players");
        player2 = msg.sender;
        gameCount++;
    }

    function getGameCount() external view returns (uint256) {
        return gameCount;
    }
}
