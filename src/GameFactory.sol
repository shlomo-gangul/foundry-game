// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "./DillemaGame.sol";

contract GameFactory {
    uint256 public gameCount;
    DillemaGame public game;
    DillemaGame[] public gamesHistory;

    event GameCreated(address indexed gameAddress, uint256 gameCount);

    constructor() {}

    function createNewGame(
        ERC20 token,
        uint256 tokenAmount,
        uint256 gameDuration
    ) external {
        game = new DillemaGame(token, tokenAmount, gameDuration);
        gamesHistory.push(game);

        gameCount++;
        emit GameCreated(address(game), gameCount);
    }

    function getGameHistory() external view returns (DillemaGame[] memory) {
        return gamesHistory;
    }

    function getGameAtIndex(uint256 index) external view returns (DillemaGame) {
        require(index < gamesHistory.length, "Index out of bounds");
        return gamesHistory[index];
    }

    function getGameCount() public view returns (uint256) {
        return gameCount;
    }
}
