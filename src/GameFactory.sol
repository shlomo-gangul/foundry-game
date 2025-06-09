// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./DillemaGame.sol";

contract GameFactory is Ownable {
    uint256 public gameCount;
    DillemaGame public game;
    DillemaGame[] public gamesHistory;

    event GameCreated(address indexed gameAddress, uint256 gameCount);

    constructor() Ownable(msg.sender) {}

    function createNewGame(ERC20 token, uint256 tokenAmount, uint32 gameDuration) external {
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
