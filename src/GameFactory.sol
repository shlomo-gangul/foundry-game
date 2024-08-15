// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "./DillemaGame.sol";

contract GameFactory {
    uint256 public gameCount;
    DillemaGame public game;
    DillemaGame[] public gamesHistory;

    constructor() {}

    function createNewGame(
        ERC20 token,
        uint256 tokenAmount,
        uint256 gameDuration
    ) external {
        game = new DillemaGame(token, tokenAmount, gameDuration);

        gameCount++;
    }

    function joinGame(address _player) public {
        game.joinGame(_player);
    }

    function isGameOver() public view returns (bool) {
        return game.getIsGameOver();
    }

    function addGameToHistory() public {
        if (game.getIsGameOver() == true) {
            gamesHistory.push(game);
        }
    }

    function getGamesHistory() public view returns (DillemaGame[] memory) {
        return gamesHistory;
    }

    function getGameCount() public view returns (uint256) {
        return gameCount;
    }
}
