// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.25;

import {Test, console} from "forge-std/Test.sol";
import {GameFactory} from "../src/GameFactory.sol";
import {DillemaGame} from "../src/DillemaGame.sol";
import {GameToken} from "../src/GameToken.sol";
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {Choice} from "../src/variables/variables.sol";

contract GameFactoryTest is Test {
    GameFactory factory;
    GameToken token;
    address player1 = 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266;
    address player2 = 0x70997970C51812dc3A010C7d01b50e0d17dc79C8;

    function setUp() external {
        token = new GameToken("gameTk", "GTK");
        factory = new GameFactory();
    }

    function testCreateNewGame() public {
        factory.createNewGame(token, 4e18, 5);
        assertEq(factory.gameCount(), 1);
    }

    function testAddGameToHistory() public {
        // console.log("Before ", factory.gamesHistory.length);
        uint gameHistoryBefore = factory.getGameCount();

        //fake game so i can add it to history
        factory.createNewGame(token, 4e18, 5);

        uint gameHistoryAfter = factory.getGameCount();

        assert(gameHistoryBefore + 1 == gameHistoryAfter);
    }
}
