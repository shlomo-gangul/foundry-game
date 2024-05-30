// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "./DillemaGame.sol";

contract GameFactory {
    ERC20 public token;
    uint256 public tokenAmount;
    uint256 public gameDuration;
    uint256 public gameCount;

    DillemaGame public game;

    constructor(
        address _tokenAddress,
        uint256 _tokenAmount,
        uint256 _gameDuration
    ) {
        token = ERC20(_tokenAddress);
        tokenAmount = _tokenAmount;
        gameDuration = _gameDuration;

        gameCount = 0;
    }

    function setNewGame() external {
        game = new DillemaGame(token, tokenAmount, gameDuration);
        game.createNewGame(token);
        gameCount++;
    }
}
