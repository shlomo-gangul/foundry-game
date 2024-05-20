// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.25;

import {Test} from "forge-std/Test.sol";
import {DillemaGame} from "../src/DillemaGame.sol";
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract GameToken is ERC20 {
    constructor(string memory name, string memory symbol) ERC20(name, symbol) {}
}

contract DillemaGameTest is Test {
    DillemaGame game; // Declare the variable 'game'\
    ERC20 token;

    function testCreateNewGame() public {
        token = new GameToken("gameTk", "GTK");
        game = new DillemaGame(token, 3e18, 5);
        game.createNewGame();
        assertEq(game.getGameCount(), 1);
    }
}
