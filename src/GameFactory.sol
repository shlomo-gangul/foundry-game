// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "openzeppelin-solidity/contracts/token/ERC20/ERC20.sol";

contract GameFactory {
    ERC20 public token;
    uint256 public tokenAmount;
    uint256 public gameDuration;
    uint256 public gameCount;
    DillemaGame public game;

    constructor(_tokenAddress, _tokenAmount, _gameDuration) {
        token = ERC20(_tokenAddress);
        tokenAmount = _tokenAmount;
        gameDuration = _gameDuration;
        game = new DillemaGame();
        gameCount = 0;
    }

    function createNewGame() external {
        game.createNewGame(token, tokenAmount, gameDuration);
        gameCount++;
    }
}
