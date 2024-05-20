// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "openzeppelin-solidity/contracts/token/ERC20/ERC20.sol";

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

    constructor(_token, _tokenAmount, _gameDuration) {
        player1 = msg.sender;
        player2 = address(0);
        token = _token;
        tokenAmount = _tokenAmount;
        gameDuration = _gameDuration;
    }
}
